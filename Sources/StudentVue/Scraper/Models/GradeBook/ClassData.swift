//
//  ClassData.swift
//  
//
//  Created by TheMoonThatRises on 3/10/23.
//

import Foundation
import SwiftSoup

extension StudentVueScraper {
    struct PointStruct {
        var score: Double
        var outOf: Double
    }

    struct ClassGrades {
        var mark: String
        var count: Int
    }

    struct GradeHistory {
        var date: Date
        var score: Int
    }

    struct Weight {
        var name: String
        var weight: Int
        var percent: Double
        var percentOfTotal: Double
    }

    public struct ClassData {
        var guid: String
        var teacher: String
        var period: Int
        var name: String
        var room: String
        var lastUpdated: Date
        var currentMark: String
        var currentScore: Double
        var missingAssignments: Int
        var totalAssignments: Int
        var upcomingAssignments: Int
        var highestScore: Int
        var lowestScore: Int
        var weights: [Weight]
        var history: [GradeHistory]
        var assignments: [GradeData]
        var classGrades: [ClassGrades]
    }
}

extension StudentVueScraper.ClassData {
    init() {
        self.init(guid: "",
                  teacher: "",
                  period: 0,
                  name: "",
                  room: "",
                  lastUpdated: Date(),
                  currentMark: "",
                  currentScore: 0.0,
                  missingAssignments: 0,
                  totalAssignments: 0,
                  upcomingAssignments: 0,
                  highestScore: 0,
                  lowestScore: 0,
                  weights: [],
                  history: [],
                  assignments: [],
                  classGrades: [])
    }

    public var maxHistoryScore: Int {
        (history.max(by: { $0.score < $1.score })?.score ?? 90) + 10
    }

    public var minHistoryScore: Int {
        (history.max(by: { $0.score > $1.score })?.score ?? 60) - 10
    }

    public var largestWeightValue: Double {
        max(weights.last?.computedWeight ?? 0.0, Double(weights.last?.weight ?? 0)) + 15
    }
}

extension StudentVueScraper.Weight {
    public var computedWeight: Double {
        Double(weight) * (percent / 100)
    }
}
