//
//  AccessPoints.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 8/20/24.
//

import Foundation

extension StudentVueApi {
    /// Endpoints that StudentVue uses for it's API.
    ///
    /// This enum is used to access different endpoints using
    /// ``StudentVueApi/makeServiceRequest(endpoint:methodName:serviceHandle:params:)`` and
    /// ``StudentVueApi/xmlServiceRequest(endpoint:methodName:serviceHandle:params:)``.
    ///
    /// New endpoints can be created by making an extension and creating a constant and accessed
    /// by nil-unwrapping.
    ///
    /// ```swift
    /// extension StudentVueApi.Endpoints {
    ///     static let newEndpoint = StudentVueApi.Endpoints(rawValue: "newEndpoint")
    /// }
    ///
    /// if let newEndpoint = StudentVueApi.Endpoints.newEndpoint {
    ///    ...
    /// }
    /// ```
    public enum Endpoints: String, Equatable {
        case pxpCommunication = "PXPCommunication"

        /// Only used for `support.edupoint.com` to access available districts.
        case hdInfoCommunication = "HDInfoCommunication"
    }

    /// SOAP methods that are accessable and useful to have.
    ///
    /// There are other methods available, but have either not be discovered
    /// or are not thought to be useful enough to be added here.
    ///
    /// This enum is used to access different methods using
    /// ``StudentVueApi/makeServiceRequest(endpoint:methodName:serviceHandle:params:)`` and
    /// ``StudentVueApi/xmlServiceRequest(endpoint:methodName:serviceHandle:params:)``.
    ///
    /// New methods can be created by making an extension and creating a constant and accessed
    /// by nil-unwrapping.
    ///
    /// ```swift
    /// extension StudentVueApi.Methods {
    ///     static let newMethod = StudentVueApi.Methods(rawValue: "newMethod")
    /// }
    ///
    /// if let newMethod = StudentVueApi.Endpoints.newMethod {
    ///    ...
    /// }
    /// ```
    public enum Methods: String {
        case getMatchingDistrictList = "GetMatchingDistrictList"
        case getPXPMessages = "GetPXPMessages"
        case studentCalendar = "StudentCalendar"
        case attendance = "Attendance"
        case gradebook = "Gradebook"
        case studentHWNotes = "StudentHWNotes"
        case studentInfo = "StudentInfo"
        case studentClassList = "StudentClassList"
        case studentSchoolInfo = "StudentSchoolInfo"
        case getReportCardInitialData = "GetReportCardInitialData"
        case getReportCardDocumentData = "GetReportCardDocumentData"
        case getStudentDocumentInitialData = "GetStudentDocumentInitialData"
        case getContentOfAttachedDoc = "GetContentOfAttachedDoc"
        case synergyMailGetAttachment = "SynergyMailGetAttachment"
        case updatePXPMessage = "UpdatePXPMessage"
        case studentHealthInfo = "StudentHealthInfo"

        case getSupportedLanguages = "GetSupportedLanguages"
        case getSoundFileData = "GetSoundFileData"
    }

    /// Web services that StudentVue uses.
    public enum WebServices: String {
        case pxpWebServices = "PXPWebServices"

        /// Only used to access the `HDInfoCommunication` endpoint.
        case hdInfoServices = "HDInfoServices"
    }

}
