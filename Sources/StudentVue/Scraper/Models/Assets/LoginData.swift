//
//  LoginData.swift
//  StudentVue
//
//  Created by Peter Duanmu on 3/8/23.
//

import Foundation

extension StudentVueScraper {
    internal struct LoginData {
        /// This gets the current state of the website, which is used for login authentication.
        var vueState: VueState

        /// The username of the the account to login.
        private var username: String {
            didSet {
                username = username.percentEncoding(withAllowedCharacters: .alphanumerics)
                    .replacing("%20", with: "%2520")
            }
        }

        /// The password of the account to login.
        private var password: String {
            didSet {
                password = password.percentEncoding(withAllowedCharacters: .alphanumerics)
                    .replacing("%20", with: "%2520")
            }
        }

        /// Compiles the information required to send to the website and converts it into
        /// type `Data`.
        public var data: Data {
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

        init(viewState: String,
             viewStateGenerator: String,
             eventValidation: String,
             username: String,
             password: String) {
            self.init(vueState: VueState(viewState: viewState,
                                         viewStateGenerator: viewStateGenerator,
                                         eventValidation: eventValidation),
                      username: username,
                      password: password)
        }
    }
}
