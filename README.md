## cumulocity-microservice-archetype

Maven archetype to generate cumulocity microservice. Based on https://cumulocity.com/guides/microservice-sdk/java/#java-microservice 

The project will contain of:

```console
project
|-- pom.xml
`-- src
    |-- main
    |  | -- java
    |  |    `-- package
    |  |         | -- App.java
    |  |         | -- controller/ExampleController.java
    |  |          `-- service/ExampleService.java
    |  | -- resources
    |  |    |-- application.properties
    |  |    |-- application-dev.properties
    |  |    |-- application-test.properties
    |  |    |-- application-prod.properties
    |  |     `-- banner.txt
    |   `-- configuration
    |       |-- cumulocity.json
    |        `-- logging.xml
```

## Run

Install archetype localy in your maven repository

```console
mvn install
```

Generate C8y miroservice project using interactive mode

```console
mvn archetype:generate -DarchetypeGroupId=cumulocity.microservice -DarchetypeArtifactId=cumulocity-microservice-archetype
```

Running the microservice locally you have to add microservice service user to application-dev.properties

```console
C8Y.bootstrap.tenant=<tenant ID>
C8Y.baseURL=<URL>
C8Y.bootstrap.user=<service-user>
C8Y.bootstrap.password=<service-user-password>
```

Hot to create an application and acquire microservice credentials see also https://cumulocity.com/guides/microservice-sdk/java/#java-microservice


## Authors 

[Alexander Pester](mailto:alexander.pester@softwareag.com)

## Disclaimer

These tools are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG welcomes contributions, we cannot guarantee to include every contribution in the master project.

## Contact

For more information you can Ask a Question in the [TECHcommunity Forums](http://tech.forums.softwareag.com/techjforum/forums/list.page?product=cumulocity).

You can find additional information in the [Software AG TECHcommunity](http://techcommunity.softwareag.com/home/-/product/name/cumulocity).

_________________
Contact us at [TECHcommunity](mailto:technologycommunity@softwareag.com?subject=Github/SoftwareAG) if you have any questions.