//
//  ClassData.swift
//  
//
//  Created by TheMoonThatRises on 3/10/23.
//

import Foundation
import SwiftSoup

extension StudentVueScraper {
    public struct PointStruct {
        public var score: Double
        public var outOf: Double
    }

    public struct ClassGrades {
        public var mark: String
        public var count: Int
    }

    public struct GradeHistory {
        public var date: Date
        public var score: Int
    }

    public struct Weight {
        public var name: String
        public var weight: Int
        public var percent: Double
        public var percentOfTotal: Double
    }

    public struct ClassData {
        public var guid: String
        public var teacher: String
        public var period: Int
        public var name: String
        public var room: String
        public var lastUpdated: Date
        public var currentMark: String
        public var currentScore: Double
        public var missingAssignments: Int
        public var totalAssignments: Int
        public var upcomingAssignments: Int
        public var highestScore: Int
        public var lowestScore: Int
        public var weights: [Weight]
        public var history: [GradeHistory]
        public var assignments: [GradeData]
        public var classGrades: [ClassGrades]
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
