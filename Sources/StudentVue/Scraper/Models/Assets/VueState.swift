//
//  VueState.swift
//
//
//  Created by TheMoonThatRises on 3/8/23.
//

import SwiftSoup

extension StudentVueScraper {
    struct VueState {
        var viewState: String {
            didSet {
                viewState = viewState.percentEncoding(withAllowedCharacters: .alphanumerics)
            }
        }
        var viewStateGenerator: String {
            didSet {
                viewStateGenerator = viewStateGenerator.percentEncoding(withAllowedCharacters: .alphanumerics)
            }
        }
        var eventValidation: String {
            didSet {
                eventValidation = eventValidation.percentEncoding(withAllowedCharacters: .alphanumerics)
            }
        }

        init(viewState: String, viewStateGenerator: String, eventValidation: String) {
            self.viewState = viewState.percentEncoding(withAllowedCharacters: .alphanumerics)
            self.viewStateGenerator = viewStateGenerator.percentEncoding(withAllowedCharacters: .alphanumerics)
            self.eventValidation = eventValidation.percentEncoding(withAllowedCharacters: .alphanumerics)
        }

        init(html: String) throws {
            let doc = try SwiftSoup.parse(html)

            self.init(viewState: try doc.getElementById("__VIEWSTATE")?.val() ?? "",
                      viewStateGenerator: try doc.getElementById("__VIEWSTATEGENERATOR")?.val() ?? "",
                      eventValidation: try doc.getElementById("__EVENTVALIDATION")?.val() ?? "")
        }
    }
}
