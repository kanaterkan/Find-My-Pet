
| Name: | Register |
| --- | --- |
| Actor: | Person |
| Description: | Person wants to create an account |
| Pre-condition: | email does not belong to an existing account |
| Scenario: | 1. Person indicates that he wants to create an account<br />2. System displays all required fields<br />3. Person types in his firstname,lastname,email, password and phone number<br /> 4. System creates an account |
| Result: | Person is now a user and can log in<br />
| Exception: | 4. System informs that email already belongs to an account<br />&emsp;4.1 Use Case ends here<br />4. System informs that passwords doesn't match<br />&emsp;4.1 Use Case ends here |
| Extension: | / |

<br /><br />

| Name: | Login |
| --- | --- |
| Actor: | User |
| Description: | User wants to login |
| Pre-condition: | User has already an account |
| Scenario: | 1. Person inicates that he wants to login<br />2. System displays all required fields<br />3. Person types in his email and password <br /> 4. System logs in into his account |
| Result: | Person is now logged in<br />
| Exception: | 4. Password doesn‘t match with email<br />&emsp;4.1 Use Case ends here<br />4. leaves one of the fields blanc<br />&emsp;4.1 Use Case ends here |
| Extension: | / |

<br /><br />


| Use Case Name 	| Create a Pet Report                                                                                                                                                                                                                               	|
|---------------	|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| Description   	| The Actor creates a pet report which is going to be added into the app. 	|
| Actors        	| User	|
| Pre-condition 	| Actor is logged in.           	|
| Scenario      	| 1. System shows format to add a report.<br>2. Actor enters picture of pet, name of pet, type of pet, breed of pet, description of pet, location of last seen.<br>3. Actors submits format.<br>4. System adds pet report with related information. 	|
| Result        	| System adds the pet report with the related information successfully.   |
| Exception    	| 3. If actor inserts invalid and missing information.<br>3.1 Use Case ends here.    	|
| Extension | None.     |
<br /><br />

| Use Case Name 	| Delete a Pet Report                                                                                                                                                                                             	|
|---------------	|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| Description   	| The Actor deletes an existing pet report from the add.	|
| Actors        	| User  	|
| Pre-condition 	| Actor is in the profile view window. 	|
| Scenario      	| 1. System shows all published pet reports of the user.<br>2. Actor selects his pet report.<br>3. System shows the format and the option to delete it.<br>4. System deletes pet report with related information. 	|
| Result        	| System deletes the pet report with the related information successfully.	|
| Exception    	| 2. Actor has not uploaded any pet report.<br> 2.1 Use Case ends here.  	|     
| Extension | None.     |
<br /><br />

| Use Case Name 	| Edit a Pet Report                                                                                                                                                                                                                                                                                                              	|
|---------------	|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| Description   	| The Actor edits an existing pet report.  	|
| Actors        	| User    |
| Pre-condition 	| Actor is in the profile view window.        	|
| Scenario      	| 1. System shows all published pet reports of the user.<br>2. Actor selects his pet report.<br>3. System shows the format and the option to edit it.<br>4. Actor edits the desired information.(picture, name of pet, type of pet, breed of pet, description of pet, location of last seen)<br>5. System overrides the changes. 	|
| Result        	| System edits the pet report with the related information successfully.    	|
| Exception    	| 4. Actor enters invalid information and missing information.<br>4.1 Use case ends here.    	|
| Extension | None.     |


<br /><br />

| Name | <div id="receivePushNotification"> Receive Push notification  </div>                                                                                                                                                           |
| -------- |--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Actor | User  |
| Description | User receives a push notification   |
| Pre-condition | User is registered and logged in.   |
| Scenario | 1. System displays push notification for pet report.<br>2. User opens push notification.<br>3. System displays the pet report.|
| Result | User got a push notification and opened the pet report.       |
| Exception | 3. User is not logged in. <br> &emsp;3.1. System asks user to log in.<br>&emsp;3.2 User loggs in.    <br>&emsp;3.3 System displays the pet report.            |
| Extension | None.     |


<br /><br />


| Name | View Profile |
| --- | --- |
| Actor | User |
| Description | User views his profile |
| Pre-condition | Registered and logged in |
| Scenario | 1. User chooses option to view his profile <br />2. System displays profile of user <br /> 3. User can see his profile details |
| Result | System displays profile details |
| Exception | 2. User is not logged in <br> System displays login |
| Extension | None |


<br /><br />
| Name | Edit Profile |
| --- | --- |
| Actor | User |
| Description | User edits his profile details |
| Pre-condition | Registered and logged in |
| Scenario | 1. User chooses option to view his profile <br />2. System displays profile of user <br /> 3. User can see his profile details <br> 4. System offers option to change profile details <br> 5. User makes changes to his profile details <br> 5. System asks to confirm changes <br> 6. User confirms |
| Result | System overwrites profile details |
| Exception | 5. User inputs empty or wrong data <br> 5.1 Use case ends |
| Extension | None |


<br /><br />

| Name | Delete Profile |
| --- | --- |
| Actor | User |
| Description | User deletes his profile |
| Pre-condition | Registered and logged in |
| Scenario | 1. User chooses option to view his profile <br />2. System displays profile of user <br /> 3. User chooses to delete his profile <br> 4. System asks for confirmation <br> 5. User confirms <br> 6. Sustem deletes user profile |
| Result | System deletes user account |
| Exception | 5. User does not confirm<br> 5.1 Use case ends|
| Extension | None |


<br /><br />
