## Table of Contents 

## Test Scenarios

| Name: | Login |
| --- | --- |
| Actor: | User |
| Description: | User wants to login |
| Pre-condition: | User is already registered |
| Scenario: | 1. User inicates that he wants to login<br />2. System asks for email and password<br /> 3. User types in his **email maxmustermann@email.com and password xxxxxxxx** <br />4. System logs user into his account |
| Result: | Person is now logged in<br />
| Exception: | 4. Password doesn‘t match with email **xxxxxxxx and zzzzzzzzz**<br />&emsp;4.1 Use Case ends here<br />4. leaves one of the fields blank<br />&emsp;5.1 Use Case ends here |
| Extension: | / |

<br /><br />


| Name | Register |
| --- | --- |
| Actor | Person|
|Description| Person wants to sign up|
| Pre-condition | Email does not belong to an existing account |
| Scenario | 1. Person wants to sign up <br /> 2. System asks for **firstname, lastname, phone number, email and password** <br /> 3. Person enters **(firstName - John)**, **(lastName - Doe)**, **(phoneNumber 0172/123456)**, **(email johndoe@icloud.com)**  , **(password xxxxxxxxx)** and **(repeatPassword xxxxxxxxx)** and confirms <br /> 4. System creates account|
| Result | Person has an account and is a new user |
| Extensions | None |
| Exception | 3. User enters different passwords **xxxxxxxx** and **zzzzzzzzz** <br> 3.1 System informs Person that passwords does not match|

<br>

Valid
| Name | <div id="receivePushNotification"> Receive Push notification  </div>                                                                                                                                                           |
| -------- |--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Actor | User                                                                                                                                        |
| Description | User receives a push notification                                                                                                                                     |
| Pre-condition | User is registered and logged in                                                                                                                                        |
| Scenario | 1. System displays push notification for pet report 1.<br>2. User opens push notification.<br>3. System displays the pet report 1.|
| Result | User got a push notification and opened the pet report.                                                                                  |
| Exception | 3. User is not logged in. <br> &emsp;3.1. System asks user to log in.<br>&emsp;3.2 User loggs in.    <br>&emsp;3.3 System displays the pet report 1.                                                   |
| Extentions | None.     |

<br>
                                                          

Valid

| Name     | Create a Pet Report                                                                                                                                                                                                                                                                                                                                                                   |
|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Scenario | 1. System shows the option to create a pet report.<br>2. Actor selects the option<br>3. System shows a form with the following information: picture, pet name, species, breed, gender, description, location)<br>4. Actor enters the details (image, Bello, dog, beagle, m, listens to the name Bello, geopoint (Venlo)<br>5. Actor uploads the details<br>6. System saves the report |
| Result   | System uploads the report successfully.                                                                                                                                                                                                                                                                                                                                               |


 <br>

Invalid 

 | Name     | Create a Pet Report                                                                                                                                                                                                                                                                                                                                                                   |
|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Scenario | 1. System shows the option to create a pet report.<br>2. Actor selects the option<br>3. System shows a form with the following information: picture, pet name, species, breed, gender, description, location)<br>4. Actor enters the details (image, (no name), dog, beagle, m, listens to the name Bello, geopoint (Venlo)<br>5. Actor uploads the details<br>6. System saves the report |
| Result   | System does not upload report because no pet name was given.                                                                                                                                                                                                                                                                                                                                               |



| Name          | Delete a Pet Report                                                                                             |
|---------------|-----------------------------------------------------------------------------------------------------------------|
| Pre-condition | User is on the report                                                                                           |
| Scenario      | 1. System shows the option to delete a report<br>2. Actor selects the option<br>3. System overrides the change. |
| Result        | System deletes the report successfully.                                                                         |

Valid

| Name     	| Edit a Pet Report                                                                                                                                                                                                                                                                                                                                                                                                                                                         	|
|----------	|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| Scenario 	| 1. System shows all published pet reports of the user. (Pet 1(Dog), Pet 2(Cat)...)<br>2. Actor selects his pet report Pet 1(Dog).<br>3. System shows the format with all information (picture, Bella, dog, beagle, description:xxx, location Venlo) and the option to edit it.<br>4. Actor edits the desired information.(picture, name of pet, type of pet, breed of pet, description of pet, location of last seen)<br>name: Bello.<br>5. System overrides the changes. 	|
| Result   	| System edits the pet report with the related information successfully.                                                                                                                                                                                                                                                                                                                                                                                                    	|

Invalid

| Name     	| Edit a Pet Report                                                                                                                                                                                                                                                                                                                                                                                                                                                         	|
|----------	|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| Scenario 	| 1. System shows all published pet reports of the user. (Pet 1(Dog), Pet 2(Cat)...)<br>2. Actor selects his pet report Pet 1(Dog).<br>3. System shows the format with all information (picture, Bella, dog, beagle, description:xxx, location Venlo) and the option to edit it.<br>4. Actor edits the desired information.(picture, name of pet, type of pet, breed of pet, description of pet, location of last seen)<br>name: <br>5. System overrides the changes. 	|
| Result   	| System should not update the pet report with the related information successfully and should end the use case.                                                                                                                                                                                                                                                                                                                                                                                                    	|



| Name | View Profile |
| --- | --- |
| Actor | User |
| Description | User views his profile |
| Pre-condition | Registered and logged in |
| Scenario | 1. User chooses option to view his profile <br />2. System displays firstName: "Max", lastName: "Mustermann", email: "max@mustermann.de", password "123" <br /> 3. User can see his profile details |
| Result | System displays profile details firstName: "Max", lastName: "Mustermann", email: "max@mustermann.de", password "123" |
| Extension | None |
| Exception | None |

<br> <br>

| Name | Edit Profile |
| --- | --- |
| Actor | User |
| Description | User edits his profile details |
| Pre-condition | Registered and logged in |
| Scenario | 1. User chooses option to view his profile <br />2. System displays firstName: "Max", lastName: "Mustermann", email: "max@mustermann.de", password "123" <br /> 3. User can see his profile details <br> 4. System offers option to change profile details <br> 5. User makes changes password from "123" to "1234" <br> 5. System asks to confirm changes <br> 6. User confirms |
| Result | System overwrites password "123" with "1234" |
| Extension | None |
| Exception | 5. User inputs email: maxmustermann.de (no @) <br> 6. Use case ends here |

<br> <br>

| Name | Delete Profile |
| --- | --- |
| Actor | User |
| Description | User deletes his profile |
| Pre-condition | Registered and logged in |
| Scenario | 1. User chooses option to view his profile <br />2.System displays firstName: "Max", lastName: "Mustermann", email: "max@mustermann.de", password "123" <br /> 3. User chooses to delete his profile <br> 4. System asks for confirmation <br> 5. User confirms |
| Result | System deletes user account with firstName: "Max", lastName: "Mustermann", email: "max@mustermann.de", password "123" |
| Extension | None |
| Exception | None |

<br> <br>
