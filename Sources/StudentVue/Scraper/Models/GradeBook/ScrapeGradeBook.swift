//
//  GradeBook.swift
//  
//
//  Created by TheMoonThatRises on 3/16/23.
//

import Foundation
import SwiftSoup

struct ScrapeGradeBook {
    var classes: [ClassData] = []

    init(html: String, client: StudentVue) async throws {
        let doc = try SwiftSoup.parse(html)

        let roomRows = try doc.getElementsByClass("row gb-class-header gb-class-row flexbox horizontal")
        let classDetails = try doc.getElementsByClass("pxp-panel")[1]

        classes = try await withThrowingTaskGroup(of: ClassData.self) { group in
            for element in try doc.getElementsByClass("row gb-class-row") {
                group.addTask {
                    var currentClass = ClassData()

                    currentClass.guid = try element.attr("data-guid")

                    let currentRoomRow = try roomRows.first(where: { try $0.attr("data-guid") ==  currentClass.guid})
                    let button = try currentRoomRow?.getElementsByTag("button")
                    let periodAndName = try button?
                        .first()?
                        .text()
                        .split(separator: ":")
                        .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })

                    let loadControlData = try JSONDecoder().decode(LoadControlData.self,
                                                                            from: try button?.attr("data-focus")
                        .data(using: .utf8) ?? Data())
                    currentClass.period = Int(periodAndName?[0] ?? "") ?? 0
                    currentClass.name = periodAndName?[1] ?? ""

                    currentClass.teacher = try currentRoomRow?.getElementsByClass("teacher hide-for-screen")
                        .first()?
                        .text() ?? ""

                    currentClass.room = try currentRoomRow?.getElementsByClass("teacher-room hide-for-print")
                        .first()?
                        .text()
                        .split(separator: " ")[1...]
                        .joined(separator: " ") ?? ""

                    currentClass.currentMark = try element.getElementsByClass("mark").first()?.text() ?? ""
                    currentClass.currentScore = Double((try element.getElementsByClass("score").first()?.text() ?? "")
                        .trimmingCharacters(in: .numbersextended)) ?? 0.0

                    let scoreHistory = try element.getElementsByClass("col-sm-4 hide-for-print").first()

                    currentClass.lastUpdated = try ParseDate
                        .getDate(date: scoreHistory?.getElementsByClass("last-update")
                        .text()
                        .trimmingCharacters(in: .numbersextended
                            .inverted) ?? "") ?? Date()

                    let scoresInHistory = try scoreHistory?.getElementsByClass("sr-only")

                    currentClass.lowestScore = Int(try scoresInHistory?[0]
                        .text()
                        .trimmingCharacters(in: .numbers) ?? ""
                    ) ?? 0
                    currentClass.highestScore = Int(try scoresInHistory?[1]
                        .text()
                        .trimmingCharacters(in: .numbers) ?? ""
                    ) ?? 0

                    try scoreHistory?.getElementsByClass("score-history sr-only")
                        .first()?
                        .getElementsByTag("li").forEach { scoreElement in
                            currentClass.history.append(
                                GradeHistory(date: ParseDate.getDate(date: try scoreElement.getElementsByClass("date")
                                    .first()?.text() ?? "") ?? Date(),
                                             score: Int(try scoreElement.getElementsByClass("score")
                                                .first()?.text() ?? "") ?? 0)
                            )
                        }

                    let currentClassDetails = try classDetails.getElementsByClass("gb-class-row")
                        .first(where: { try $0.attr("data-guid") == currentClass.guid })

                    try currentClassDetails?.getElementsByClass("class-summary-info")
                        .first()?.getElementsByTag("li").forEach { assignmentValues in
                            let title = try assignmentValues.getElementsByClass("name")
                                .first()?
                                .text().lowercased() ?? ""
                            if title.contains("total") {
                                currentClass.totalAssignments = Int(try assignmentValues.getElementsByClass("value")
                                    .first()?.text() ?? "") ?? 0
                            } else if title.contains("upcoming") {
                                currentClass.upcomingAssignments = Int(try assignmentValues.getElementsByClass("value")
                                    .first()?.text() ?? "") ?? 0
                            }
                        }

                    try currentClassDetails?.getElementsByTag("tbody")
                        .first()?
                        .getElementsByTag("tr").forEach { weights in
                        let nums = try weights.getElementsByTag("td")
                        currentClass.weights.append(Weight(name: try weights.getElementsByTag("th")
                            .first()?.text() ?? "",
                                                           weight: Int(try nums[0].text()
                                                            .trimmingCharacters(in: .numbersextended)) ?? 0,
                                                           percent: Double(try nums[1].text()
                                                            .trimmingCharacters(in: .numbersextended)) ?? 0.0,
                                                           percentOfTotal: Double(try nums[2].text()
                                                            .trimmingCharacters(in: .numbersextended)) ?? 0.0))
                    }

                    currentClass.weights.sort(by: { $0.weight < $1.weight })

                    try currentClassDetails?.getElementsByTag("ul")[1].getElementsByTag("li").forEach { classGrades in
                        currentClass.classGrades
                            .append(ClassGrades(mark: try classGrades.getElementsByClass("mark").text(),
                                                count: Int(try classGrades.getElementsByClass("mark-count")
                                                                        .text()) ?? 0))
                    }

                    let gradeDetails = try await client.scraper.autoThrowApi(endpoint: .loadControl,
                                                                             method: .post,
                                                                             headerType: .api,
                                                                             data: loadControlData.toRequestable())

                    let gradeData = try JSONDecoder().decode(API.self,
                                                             from: gradeDetails.html.data(using: .utf8) ?? Data())

                    let dataSource = gradeData.result.data.html.matches("\"dataSource\":\\[.+?\\]")
                        .last

                    if let dataSource = dataSource,
                       !dataSource.isEmpty,
                       let parenIdx = dataSource.firstIndex(of: "["),
                       let gradeData = String(dataSource[parenIdx...]).data(using: .utf8) {
                        currentClass.assignments = try JSONDecoder().decode([GradeData].self, from: gradeData)
                    }

                    return currentClass
                }
            }

            return try await group.reduce(into: [ClassData]()) { partialResult, rclass in
                partialResult.append(rclass)
            }
        }

        classes.sort(by: { $0.period < $1.period })
    }
}
