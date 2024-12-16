# StudentVue.swift

![Supported Platforms](https://img.shields.io/badge/platform-ios%20%7C%20macos-lightgrey.svg?style=flat)
[![MIT](https://img.shields.io/github/license/TheMoonThatRises/StudentVue.swift.svg?style=flat)](https://github.com/TheMoonThatRises/StudentVue.swift)

Swift library for interacting with StudentVue's api. This project was heavily influenced by [StudentVue.js](https://github.com/StudentVue/StudentVue.js) and relied on information provided by their [documentation](https://github.com/StudentVue/docs). This library is still a work in progress and if you encounter an issue, feel free to create an [issue](https://github.com/TheMoonThatRises/StudentVue.swift/issues/new) or submit a [pull request](https://github.com/TheMoonThatRises/StudentVue.swift/pulls).

Checkout this project in action here: [**PortalBook** by TheMoonThatRises](https://github.com/TheMoonThatRises/PortalBook)

## Documentation

Read the documentation here: [https://plduanm.com/projects/documentation/studentvue/](https://plduanm.com/projects/documentation/studentvue/)

## Installation

```swift
.package(url: "https://github.com/TheMoonThatRises/StudentVue.swift", from: "1.0.0")
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

For checking the validity of credentials use the `checkCredentials` method in the API. This method is the fastest way to check the validity of the input credentials, and should resolve in about 0.7 seconds.

```swift
let isCredentialsValid = try await client.api.checkCredentials()
```

You can use the built-in scraper parser to parse specific endpoints. These structs are in the `StudentVueScraper` class and has the `html` parameter for html to parse. Some will include `client` which is of class `StudentVueScraper` which may be used to access additional helper pieces of information. Some endpoints will have built-in class structures

```swift
try await client.scraper.getCourseHistory() // Returns course history
```

Lower level access is possible through both the API and the Scraper. Read the documentation for more information about available methods. If the specific endpoint you are looking for is not incorporated in the endpoint or methods enum, you can extend the enum and add more. More methods and endpoints can be discovered by installing the official StudentVUE app and running MITMProxy.

```swift
extension StudentVueApi.Methods {
    static let anotherMethod = StudentVueApi.Methods(rawValue: "AnotherMethod")
}

if let anotherMethod = StudentVueApi.Methods.anotherMethod {
    let item = try await client.api.makeServiceRequest(methodName: anotherMethod)
}

try await client.scraper.autoThrowApi(endpoint: .attendance)
```

### Static functions

For some functions, logging in is not required, such as getting district zip codes. Note that `getDistricts` is an endpoint that has rate limits, so be careful when using it with updating UI.

```swift
let districts = try await client.api.getDistricts(zip: "a zip code")
```

You can also use the scraper which gives more information and functionality, but is not fully implemented. The line below that will log the scraper in and out of StudentVue. More and easier functionality will be added to the scraper in the future.

```swift
try await client.scraper.login() // Log into StudentVue. NOTE: login returns gradebook html

try await client.scraper.logout() // Log out of StudentVue. Returns boolean indicating success
```

Because the username and password are not publicly accessible variables within the library, a hash function is provided to check if the stored username, password, and domain combination is similar to others you may have stored.

```swift
let hash = client.getAccountHash()
```

## Library Used

1. [SWXMLHash](https://github.com/drmohundro/SWXMLHash) - Simple XML parsing in Swift
1. [SwiftSoup](https://github.com/scinfu/SwiftSoup) - SwiftSoup: Pure Swift HTML Parser, with best of DOM, CSS, and jquery (Supports Linux, iOS, Mac, tvOS, watchOS)
