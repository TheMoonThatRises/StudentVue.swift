//
//  VueState.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 3/8/23.
//

import SwiftSoup

extension StudentVueScraper {
    internal struct VueState {
        /// Gets the view state of the StudentVue website and encodes the alphanumerical values.
        var viewState: String {
            didSet {
                viewState = viewState.percentEncoding(withAllowedCharacters: .alphanumerics)
            }
        }

        /// Gets the view state generator value of the StudentVue website and encodes the
        /// alphanumerical values.
        var viewStateGenerator: String {
            didSet {
                viewStateGenerator = viewStateGenerator.percentEncoding(withAllowedCharacters: .alphanumerics)
            }
        }

        /// Gets the event validation state value of the StudentVue website and encodes the
        /// alphanumerical values.
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

        /// Parses the scraped contents of the StudentVue website for its state values.
        init(html: String) throws {
            let doc = try SwiftSoup.parse(html)

            self.init(viewState: try doc.getElementById("__VIEWSTATE")?.val() ?? "",
                      viewStateGenerator: try doc.getElementById("__VIEWSTATEGENERATOR")?.val() ?? "",
                      eventValidation: try doc.getElementById("__EVENTVALIDATION")?.val() ?? "")
        }
    }
}
