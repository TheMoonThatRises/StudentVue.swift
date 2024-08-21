//
//  AccessEndpoints.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 8/20/24.
//

import Foundation

extension StudentVueScraper {
    /// All of StudentVue's website endpoints.
    public enum Endpoints: String {
        case assessment = "/PXP2_Assessment.aspx"
        case attendence = "/PXP2_Attendance.aspx"
        case calendar = "/PXP2_Calendar.aspx"
        case classSchedule = "/PXP2_ClassSchedule.aspx"
        case conference = "/PXP2_Conference.aspx"
        case courseHistory = "/PXP2_CourseHistory.aspx"
        case courseRequest = "/PXP2_CourseRequest.aspx"
        case graduationRequirements = "/PXP2_UserModule.aspx"
        case digitalLocker = "/PXP2_DigitalLocker.aspx"
        case fee = "/PXP2_Fee.aspx"
        case gradeBook = "/PXP2_Gradebook.aspx"
        case health = "/PXP2_Health.aspx"
        case login = "/PXP2_Login_Student.aspx"
        case mail = "/PXP2_Messages.aspx"
        case mtss = "/PXP2_MTSS.aspx"
        case reportCard = "/PXP2_ReportCard.aspx"
        case schoolInformation = "/PXP2_SchoolInformation.aspx"
        case studentInfo = "/PXP2_Student.aspx"

        case loadControl = "/service/PXP2Communication.asmx/LoadControl"
    }
}
