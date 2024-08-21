# ``StudentVue``

An easy and lightweight way to interact with StudentVue's' api.

@Metadata {
    @PageColor(green)
}

## Overview

StudentVue provides methods for interacting with StudentVue's api and website. The package also provides structures to easily access attributes and variables returned by StudentVue's SOAP api. You can easily enter create a StudentVue access instance using ``StudentVue/StudentVue``. The validity of the username and password can be checked using  ``StudentVue/StudentVue/checkCredentials()``. User credentials and domains can also be easily updated with ``StudentVue/StudentVue/updateCredentials(domain:username:password:)``.

## Featured

@Links(visualStyle: detailedGrid) {
    - <doc:GettingStarted>
<!--    - <doc:StudentVueSample>-->
}

## Topics

### Essentials

- <doc:GettingStarted>
<!--- <doc:StudentVueSample>-->
- ``StudentVue``

### API Access

- ``StudentVueApi``
- ``StudentVueApi/getGradeBook(reportPeriod:)``

### Scraper Access

- ``StudentVueScraper``
- ``StudentVueScraper/getCourseHistory()``
