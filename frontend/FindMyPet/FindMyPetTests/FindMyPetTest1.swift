//
//  FindMyPetTest1.swift
//  FindMyPetTests
//
//  Created by Erkan Kanat on 19.12.23.
//

import XCTest
@testable import FindMyPet

final class FindMyPetTest1: XCTestCase {
    
    let basicURL2 = "\(AppConfig.baseURL)/pet-reports"
 
    
    func testPostReport() async throws {
        
        
        let basicURL = "\(AppConfig.baseURL)"
        
        // Get the inital count value - prepare an Int for comparison
        
        
        let initReportsCount = try await getReportsCount(urlString: basicURL)
        let initCount = Int(initReportsCount.count)
        
        let aReport = ReportDetail(petName: "Test", petType: "Wuff", petBreed: "Wuff", petDescription: "This is a test", petGender: true, dateReported: 2, petPicture: "NoImage", isFound: false, location: "Normallyacoordinate", userId: 87)
        
        // Post the Report
        try await postReport(urlString: basicURL2, reportDetail: aReport)
        
        
        let finalReportsCount = try await getReportsCount(urlString: basicURL)
        let finalCount = Int(finalReportsCount.count)
        
        XCTAssertTrue(initCount == (finalCount-1), "Expected initial count \(initCount) to be 1 less than final count \(finalCount)")
    }
    
    //Setup und Tierdown um die Umgebung zu simulieren
    
    
    
    func testDeleteReport() async throws{
        
        
        
        
    }
    
    // func testCreateUser() async throws{
    
    //     let basicURL = "\(AppConfig.baseURL)/users/count"
    //    let basicURL2 = "\(AppConfig.baseURL)/signup"
    
    
    //   let initUsersCount = try await getUsersCount(urlString: basicURL)
    //     let initCount = Int(initUsersCount.count)
    
    //     let aUser = UserDetail(firstname: "Erkan", lastname: "Kanat", email: "ErkanKanat@gmail.com", phoneNumber: "2232322222")
    
    //   try await postUser(urlString: basicURL2, userDetail: aUser)
    //
    //   let finalUsersCount = try await getUsersCount(urlString: basicURL)
    //    let finalCount = Int(finalUsersCount.count)
    
    //   XCTAssertTrue(initCount == (finalCount-1), "Expected initial count \(initCount) to be 1 less than final count \(finalCount)")
    
    //}
    

    func testLoginUser() async throws {
        let basicURL = "\(AppConfig.baseURL)/users/login"
        let basicURL2 = "\(AppConfig.baseURL)/whoAmI"
        
        let aUser = LoginUser(email: "Test1234@gmail.com", password: "Test1234")
        
        let token = try await postLogin(urlString: basicURL, loginUser: aUser)
        
        let user = try await whoAmI(urlString: basicURL2, token: token)
        
        XCTAssertEqual(user.email, aUser.email, "Test1234@gmail.com", file: "User email should be Test1234@gmail.com")
        
    }
    
    
    
    
    
    
    
    
    
    
    
}
