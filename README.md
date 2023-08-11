# StudentVue.swift

![Supported Platforms](https://img.shields.io/badge/platform-ios%20%7C%20macos-lightgrey.svg?style=flat)
[![MIT](https://img.shields.io/github/license/TheMoonThatRises/StudentVue.swift.svg?style=flat)](https://github.com/TheMoonThatRises/StudentVue.swift)

Swift library for interacting with StudentVue's api. This project was heavily influenced by [StudentVue.js](https://github.com/StudentVue/StudentVue.js) and relied on information provided by their [documentation](https://github.com/StudentVue/docs). This library is still a work in progress and if you encounter an issue, feel free to create an [issue](https://github.com/TheMoonThatRises/StudentVue.swift/issues/new) or submit a [pull request](https://github.com/TheMoonThatRises/StudentVue.swift/pulls).

## Installation

```swift
.package(url: "https://github.com/TheMoonThatRises/StudentVue.swift", from: "0.1.1")
```

## Basic usage

### Logging in as a student

To create a client instance, use:

```swift
import StudentVue

let client = StudentVue(domain: "something.edupoint.com", username: "123456789", password: "password")
```

With the client initialized, you can access information from the official api by using the provided functions such as `getGradeBook`, `getClassSchedule`, `getSchoolInfo`, and many more. If one of the functions fails to parse or you want to access information in which a data structure is not created, you can call the `makeServiceRequest` and parse the XML manually.

```swift
let gradebook = try await client.api.getGradeBook()
```

### Static functions

For some functions, logging in is not required, such as getting district zip codes.

```swift
let districts = try await client.api.getDistricts(zip: "a zip code")
```

You can also use the scraper which gives more information and functionality, but is not fully implemented. With the following example you can assess whether or not a username and password combination are valid. The line below that will you out of StudentVue. More and easier functionality will be added to the scraper in the future.

```swift
try await client.scraper.login() // Log into StudentVue. NOTE: login returns gradebook html

try await client.scraper.logout() // Log out of StudentVue. Returns boolean indicating success
```

You can use the built-in scraper parser to parse specific endpoints. These classes typically start with the word `Scrape` and has the `html` parameter for html to parse. Some will include `client` which is of class `StudentVue` which may be used to access additional helper pieces of information.

```swift
try await ScrapeGradeBook(html: try await client.scraper.login(), client: client) // Returns gradebook in an array of `ClassData`
```

## Todo List

- [ ] A website for documentation
- [ ] More complete structures for returned data
    - [ ] Use the WSDL file to help with the data structure
- [ ] Use a proper SOAP handler instead of the "hacky" solution
- [ ] More complete scraper parser - In progress

## Library Used

- [SWXMLHash](https://github.com/drmohundro/SWXMLHash)
- [SwiftSoup](https://github.com/scinfu/SwiftSoup)
