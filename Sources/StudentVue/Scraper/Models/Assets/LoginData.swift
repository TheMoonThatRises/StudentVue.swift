//
//  LoginData.swift
//  
//
//  Created by TheMoonThatRises on 3/8/23.
//

import Foundation

extension StudentVueScraper {
    struct LoginData {
        var vueState: VueState

        private var username: String {
            didSet {
                username = username.percentEncoding(withAllowedCharacters: .alphanumerics)
                    .replacing("%20", with: "%2520")
            }
        }
        private var password: String {
            didSet {
                password = password.percentEncoding(withAllowedCharacters: .alphanumerics)
                    .replacing("%20", with: "%2520")
            }
        }

        var data: Data {
            let value = "__VIEWSTATE=\(vueState.viewState)&__VIEWSTATEGENERATOR=\(vueState.viewStateGenerator)&" +
            "__EVENTVALIDATION=\(vueState.eventValidation)&" +
            "ctl00%24MainContent%24username=\(username)&ctl00%24MainContent%24password=\(password)&" +
            "ctl00%24MainContent%24Submit1=Login"

            return Data([UInt8](Array(value.utf8)))
        }

        init(vueState: VueState, username: String, password: String) {
            self.vueState = vueState
            self.username = username.percentEncoding(withAllowedCharacters: .alphanumerics)
                .replacing("%20", with: "%2520")
            self.password = password.percentEncoding(withAllowedCharacters: .alphanumerics)
                .replacing("%20", with: "%2520")
        }

        init(viewState: String, viewStateGenerator: String, eventValidation: String, username: String, password: String) {
            self.init(vueState: VueState(viewState: viewState,
                                         viewStateGenerator: viewStateGenerator,
                                         eventValidation: eventValidation),
                      username: username,
                      password: password)
        }
    }
}
