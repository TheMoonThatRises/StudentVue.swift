//
//  StudentInfoData.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 8/17/24.
//

import Foundation

extension StudentVueScraper {
    @available(swift, deprecated: 0.1.0, message: "Use StudentVueApi.StudentInfo instead.")
    public struct StudentInfoData {
        public var id: String
        public var name: String
        public var grade: Int
        public var school: String
        public var phone: String
        public var photo: URL?
    }
}
