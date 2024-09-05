//
//  ReportTests.swift
//  FindMyPetTests
//
//  Created by Erkan Kanat on 03.01.24.
//

import XCTest
@testable import FindMyPet


final class ReportTests: XCTestCase {

    var testUser: UserDetail!
    var testToken: String!
    var user: UserDetail?
    var report: ReportDetail?
    
    
   
    override func setUp() async throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let basicURL2 = "\(AppConfig.baseURL)/signup"
  
        let basicURL3 = "\(AppConfig.baseURL)/whoAmI"

    
        testUser = UserDetail(firstname: "John", lastname: "Joe", email: "Johnjoe19997@gmail.com", password: "Johnjoe", phoneNumber: "12345")
        
        do{
            testToken = try await postUser(urlString: basicURL2, userDetail: testUser)
            
            user = try await whoAmI(urlString: basicURL3, token: testToken)
            
        } catch{
            print("Error \(error)")
        }
    }

    func testPostReport() async throws {
        
        
        let basicURL = "\(AppConfig.baseURL)"
        let basicURL2 = "\(AppConfig.baseURL)/pet-reports"

        // Get the inital count value - prepare an Int for comparison
        
        
        let initReportsCount = try await getReportsCount(urlString: basicURL)
        let initCount = Int(initReportsCount.count)
        
        print("Test \(user)")
        
        
        let report = ReportDetail(petName: "Test", petType: "Wuff", petBreed: "Wuff", petDescription: "This is a test", petGender: true, dateReported: 2, petPicture: "NoImage", isFound: false, location: "33,4", userId: (user?.id)! )
        
        // Post the Report
        try await postReport(urlString: basicURL2, reportDetail: report)
        
        
        let finalReportsCount = try await getReportsCount(urlString: basicURL)
        let finalCount = Int(finalReportsCount.count)
        
        XCTAssertTrue(initCount == (finalCount-1), "Expected initial count \(initCount) to be 1 less than final count \(finalCount)")
    }
    override func tearDown() async throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let basicURL: String
        let basicURL23: String
        let basicURL2 = "\(AppConfig.baseURL)/whoAmI"
        
        if let userId = user?.id{
            let nonOptionalUserId = userId
            
            basicURL = "\(AppConfig.baseURL)/users"
            basicURL23 = "\(AppConfig.baseURL)"
            do{
                
                try await deleteReport(urlString: basicURL23, reportDetail: report!)
                try await deleteUser(urlString: basicURL, userDetail: user!, token: testToken)
            } catch {
                print("Error deleting \(error)")
            }
            
            
        }
    }

}
