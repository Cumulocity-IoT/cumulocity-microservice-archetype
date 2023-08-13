## cumulocity-microservice-archetype

Maven archetype to generate cumulocity microservice project. Based on https://github.com/SoftwareAG/cumulocity-clients-java and https://cumulocity.com/guides/microservice-sdk/java/#java-microservice 

The project will contain following project structure:

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

The project contains also an example REST controller which must be replaced or removed depending on your further development.
However the complete project is directly runnable without any additional changes. It uses also some best practices like:

- using spring profiles (dev, test and prod)
- using spring dev tool
- using local configured application-dev.properties to run localy on development env
- using Logback configuration file
- using current java cumulocity microservice SDK
- using custom banner with cumulocity SDK version

In order to make it even faster to setup your project, the archetype contains a post-generation script which registers your microservice automatically on your tenant. This step is optional.

The post-generation script does following steps: 

- Generate microservice application on tenant
- Subscribes microservice to tenant
- Acquires microservice credentials
- writes all information to application-dev.properties

## Prerequisites

- Java installed >= 11
- Maven installed >= 3.6
- Cumulocity IoT Tenant >= 1010.0.0
- Cumulocity IoT User Credentials (Base64 encoded)


## Run

Cloning this repository into you local GIT repository

```console
git clone ...
```

Install archetype localy in your local maven repository

```console
mvn install
```

Go to the folder you want to generate the project

```console
cd ..
```

Generate C8y miroservice project using interactive mode

```console
mvn archetype:generate -DarchetypeGroupId=cumulocity.microservice -DarchetypeArtifactId=cumulocity-microservice-archetype
```

### Step 1: Define your microservice name

```console
[INFO] Generating project in Interactive mode
[INFO] Archetype [cumulocity.microservice:cumulocity-microservice-archetype:1.0.0-SNAPSHOT] found in catalog local
Define value for property 'microserviceName':
```

If your microservice name has more than one words, seperate the words by '-'


### Step 2: Define your artifact id (default value cumulocity-microservice-<microservice name>)

```console
[INFO] Generating project in Interactive mode
[INFO] Archetype [cumulocity.microservice:cumulocity-microservice-archetype:1.0.0-SNAPSHOT] found in catalog local
Define value for property 'microserviceName': hello-devices
[INFO] Using property: groupId = cumulocity.microservice
[INFO] Using property: version = 1.0.0-SNAPSHOT
[INFO] Using property: c8yVersion = 1013.0.0
[INFO] Using property: devC8yBaseURL = null
[INFO] Using property: devC8yUserCredentialsBASE64 = null
Define value for property 'artifactId' cumulocity-microservice-hello-devices: :
```

You can now just hit enter to continue with default or enter your own artificat id.

### Step 3: Define your package name (default value cumulocity.microservice.<microservice name>)

```console
[INFO] Generating project in Interactive mode
[INFO] Archetype [cumulocity.microservice:cumulocity-microservice-archetype:1.0.0-SNAPSHOT] found in catalog local
Define value for property 'microserviceName': hello-devices
[INFO] Using property: groupId = cumulocity.microservice
[INFO] Using property: version = 1.0.0-SNAPSHOT
[INFO] Using property: c8yVersion = 1013.0.0
[INFO] Using property: devC8yBaseURL = null
[INFO] Using property: devC8yUserCredentialsBASE64 = null
Define value for property 'artifactId' cumulocity-microservice-hello-devices: :
Define value for property 'package' cumulocity.microservice.hello-devices: : cumulocity.microservice.hello_devices
```

You can now just hit enter to continue with default or enter your own artificat id. **!!! Beaware that '-' can't be used at java packages. In that case you must replace '-' with '_'. !!!**

### Step 4.1: Confirm your configuration with 'Y' without running post-generation script

```console
[INFO] Generating project in Interactive mode
[INFO] Archetype [cumulocity.microservice:cumulocity-microservice-archetype:1.0.0-SNAPSHOT] found in catalog local
Define value for property 'microserviceName': hello-devices
[INFO] Using property: groupId = cumulocity.microservice
[INFO] Using property: version = 1.0.0-SNAPSHOT
[INFO] Using property: c8yVersion = 1013.0.0
[INFO] Using property: devC8yBaseURL = null
[INFO] Using property: devC8yUserCredentialsBASE64 = null
Define value for property 'artifactId' cumulocity-microservice-hello-devices: :
Define value for property 'package' cumulocity.microservice.hello-devices: : cumulocity.microservice.hello_devices
Confirm properties configuration:
microserviceName: hello-devices
groupId: cumulocity.microservice
version: 1.0.0-SNAPSHOT
c8yVersion: 1013.0.0
devC8yBaseURL: null
devC8yUserCredentialsBASE64: null
artifactId: cumulocity-microservice-hello-devices
package: cumulocity.microservice.hello_devices
 Y: : Y
```

Now you have created your microservice project successfully! However, you could configure even more and run the post-generation script. To do so, you have to initialize devC8yBaseURL and devC8yUserCredentialsBASE64.

_IMPORTANT!!!_

If you haven't setup your application-dev.properties to a specific tenant, the predefined unit test will not succeed! This unit test is starting the spring boot application and checks if the application is successfully starting. The microservice can't start if the c8y configuration isn't setup. However you can build with skipping the test by:

```
mvn clean install -Dmaven.test.skip=true
```

### Step 4.2: Confirm your configuration with 'N' with running post-generation script

And repeate step 1 - 3 and insert devC8yBaseURL and devC8yUserCredentialsBASE64

```console
 Y: : N
Define value for property 'microserviceName': hello-devices
Define value for property 'groupId' cumulocity.microservice: :
Define value for property 'version' 1.0.0-SNAPSHOT: :
Define value for property 'c8yVersion' 1013.0.0: :
Define value for property 'devC8yBaseURL': https://ms-template.eu-latest.cumulocity.com
Define value for property 'devC8yUserCredentialsBASE64': Basic XXXXX
Define value for property 'artifactId' cumulocity-microservice-hello-devices: :
Define value for property 'package' cumulocity.microservice.hello-devices: : cumulocity.microservice.hello_devices
Confirm properties configuration:
microserviceName: hello-devices
groupId: cumulocity.microservice
version: 1.0.0-SNAPSHOT
c8yVersion: 1013.0.0
devC8yBaseURL: https://ms-template.eu-latest.cumulocity.com
devC8yUserCredentialsBASE64: Basic XXXXX
artifactId: cumulocity-microservice-hello-devices
package: cumulocity.microservice.hello_devices
 Y: : Y
```

### Step 5: Build your fresh generated project

Go to the project folder

```console
cd cumulocity-microservice-hello-devices/
```

and build the project:

```console
mvn install
```

Running the microservice locally you have to add microservice service user to application-dev.properties, have you run the script with step 4.2 the properties are automatically configured

```console
C8Y.bootstrap.tenant=<tenant ID>
C8Y.baseURL=<URL>
C8Y.bootstrap.user=<service-user>
C8Y.bootstrap.password=<service-user-password>
```

### Step 6: Start the microservice and test

Go to target and run the spring boot appliation

java -jar cumulocity-microservice-hello-devices-1.0.0-SNAPSHOT.jar

Open the browser and open link http://localhost:8080/api/hello/devices, you have to insert your Cumulocity credentials, keep in mind to set the tenant Id in front of your user name like t2134/alexander.pester@softwareag.com.

Now your microservice is ready to evolve!!!

For building docker container please change property in pom file to:

```console
<c8y.docker.skip>false</c8y.docker.skip>
```
## Live Demo

https://youtu.be/2j21ULZbtlg

## Authors 

[Alexander Pester](mailto:alexander.pester@softwareag.com)

## Disclaimer

These tools are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG welcomes contributions, we cannot guarantee to include every contribution in the master project.

## Contact

For more information you can Ask a Question in the [TECHcommunity Forums](http://tech.forums.softwareag.com/techjforum/forums/list.page?product=cumulocity).

You can find additional information in the [Software AG TECHcommunity](https://tech.forums.softwareag.com/tag/Cumulocity-IoT).

_________________
Contact us at [TECHcommunity](mailto:technologycommunity@softwareag.com?subject=Github/SoftwareAG) if you have any questions.
