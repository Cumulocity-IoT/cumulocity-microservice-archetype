import groovy.json.JsonSlurper
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.io.File 

println("########## C8y Dev Tools, Local microservice runtime setup ################")
println("Cumulocity URL: $devC8yBaseURL")
println("User Credentials: $devC8yUserCredentialsBASE64")
println("Microservice name: $microserviceName")

def jsonSlurper = new JsonSlurper()

// Step 1.1: Create application on Cumulocity Tenant
def post1 = new URL("$devC8yBaseURL/application/applications").openConnection();
def message1 = """{
  "key": "$microserviceName",
  "name": "$microserviceName",
  "contextPath": "$microserviceName",
  "type": "MICROSERVICE",
  "manifest":{},	
	"requiredRoles": [
		"ROLE_INVENTORY_READ",
		"ROLE_INVENTORY_CREATE",
		"ROLE_INVENTORY_ADMIN",
		"ROLE_IDENTITY_READ",
		"ROLE_IDENTITY_ADMIN",
		"ROLE_AUDIT_READ",
		"ROLE_AUDIT_ADMIN",
		"ROLE_MEASUREMENT_READ",
		"ROLE_MEASUREMENT_ADMIN",
		"ROLE_EVENT_READ",
		"ROLE_EVENT_ADMIN",
		"ROLE_DEVICE_CONTROL_READ",
		"ROLE_DEVICE_CONTROL_ADMIN"
	],
	"roles": [
	]
}"""
post1.setRequestMethod("POST")
post1.setDoOutput(true)
post1.setRequestProperty("Content-Type", "application/json")
post1.setRequestProperty("Authorization", devC8yUserCredentialsBASE64)
post1.getOutputStream().write(message1.getBytes("UTF-8"));
def postRC1 = post1.getResponseCode();
println(postRC1);

def responseBody1 = post1.getInputStream().getText()
println(responseBody1);

def object1 = jsonSlurper.parseText(responseBody1)

def msInternalId = object1.id
def msTenantId = object1.owner.tenant.id
println("Microservice internal ID: $msInternalId")
println("Template Microservice id: $msTenantId")

// Step 1.2: Subscribe to application for tenant
def post2 = new URL("$devC8yBaseURL/tenant/tenants/$msTenantId/applications").openConnection();
def message2 = """{
    "application": {
        "id": "$msInternalId"
    }
}"""
post2.setRequestMethod("POST")
post2.setDoOutput(true)
post2.setRequestProperty("Content-Type", "application/json")
post2.setRequestProperty("Authorization", devC8yUserCredentialsBASE64)
post2.getOutputStream().write(message2.getBytes("UTF-8"));
def postRC2 = post2.getResponseCode();
println(postRC2);

//Step 1.3: Acquiring microservice credentials
def get3 = new URL("$devC8yBaseURL/application/applications/$msInternalId/bootstrapUser").openConnection();
get3.setRequestProperty("Content-Type", "application/json")
get3.setRequestProperty("Authorization", devC8yUserCredentialsBASE64)
def getRC3 = get3.getResponseCode();
println(getRC3);
def responseBody3 = get3.getInputStream().getText()
def object3 = jsonSlurper.parseText(responseBody3)

def devC8yBootstrapUser = object3.name
def devC8yBootstrapPassword = object3.password
def devC8yTenantId = object3.tenant

def propertyFileText = """
#Do not edit, version properties are set at build time
c8y.version=@c8y.version@
microservice.version=@project.version@

#Cumulocity configuration for running localy and connecting to cumulocity
application.name=$microserviceName
C8Y.bootstrap.register=true
C8Y.bootstrap.tenant=$devC8yTenantId
C8Y.baseURL=$devC8yBaseURL
C8Y.bootstrap.user=$devC8yBootstrapUser
C8Y.bootstrap.password=$devC8yBootstrapPassword
C8Y.microservice.isolation=MULTI_TENANT
"""
println(propertyFileText)
Path projectPath = Paths.get(request.outputDirectory, request.artifactId)
println(projectPath)
def filePath = projectPath.toString() + "\\src\\main\\resources\\application-dev.properties"
println("Write properties file: $filePath")
File file = new File(filePath)
file.write(propertyFileText)
println("########## C8y Dev Tools, Local microservice runtime setup ################")
