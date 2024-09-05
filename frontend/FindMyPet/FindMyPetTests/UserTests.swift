//
//  UserTests.swift
//  FindMyPetTests
//
//  Created by Erkan Kanat on 28.12.23.
//

import XCTest
@testable import FindMyPet

final class UserTests: XCTestCase {

    var testUser: UserDetail!
    var testToken: String!
    var user: UserDetail!
    
    override func setUp() async throws {
        testUser = UserDetail(firstname: "Berkay", lastname: "Mann", email: "berkaymann123345678@gmail.com",password: "Johndoe123!", phoneNumber: "123445678")
        
        let basicURL2 = "\(AppConfig.baseURL)/signup"
  
        let basicURL3 = "\(AppConfig.baseURL)/whoAmI"

        do{
            testToken = try await postUser(urlString: basicURL2, userDetail: testUser)
            user = try await whoAmI(urlString: basicURL3, token: testToken)
        }
        catch{
            print("Error \(error)")
        }
           // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() async throws {
        
        let basicURL: String
        let basicURL2 = "\(AppConfig.baseURL)/whoAmI"

        let user = try await whoAmI(urlString: basicURL2, token: testToken)
        
        
          if let userId = user.id {
              // Wenn testUser.id nicht nil ist, wandele es in eine nicht optionale Int um
              let nonOptionalUserId = userId
              
              basicURL = "\(AppConfig.baseURL)/users"
              print("Deleting user with ID: \(nonOptionalUserId)")
              
              do {
                  try await deleteUser(urlString: basicURL, userDetail: user, token: testToken)
                  print("User deleted successfully.")
              } catch {
                  print("Error deleting user: \(error)")
              }
          } else {
              // Handle den Fall, wenn testUser.id nil ist
              print("Error: User id is nil")
              print("\(testToken)")
          }

       
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoginUser() async throws {
        let basicURL = "\(AppConfig.baseURL)/users/login"
        let basicURL2 = "\(AppConfig.baseURL)/whoAmI"
        
        let aUser = LoginUser(email: testUser.email, password: testUser.password!)
        
        let token = try await postLogin(urlString: basicURL, loginUser: aUser)
        
        let user = try await whoAmI(urlString: basicURL2, token: token)
        
        XCTAssertEqual(user.email, aUser.email, "Johndoe@gmail.com", file: "User email should be Johndoe@gmail.com")
        
    }
    
   
  

}


