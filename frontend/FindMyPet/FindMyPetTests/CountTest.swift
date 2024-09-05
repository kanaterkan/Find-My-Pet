//
//  CountTest.swift
//  FindMyPetTests
//
//  Created by Erkan Kanat on 19.12.23.
//

import XCTest

final class CountTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testGetReportsCount() async throws {
        let basicURL = "\(AppConfig.baseURL)/pet-reports/count"
        let basicURL2 = "\(AppConfig.baseURL)/pet-reports"
        
        // Get the inital count value - prepare an Int for comparison
        
        let initReportsCount = try await getReportsCount(urlString: basicURL  )
        let initCount = Int(initReportsCount.count)
        
        let aReport = ReportDetail(petName: "Test", petType: "Wuff", petBreed: "Wuff", petDescription: "This is a test", petGender: true, dateReported: 2, petPicture: "NoImage", isFound: false, location: "Normallyacoordinate", userId: 87)
        
    try await postReport(urlString: basicURL2, reportDetail: aReport)
        
        let finalReportsCount = try await getReportsCount(urlString: basicURL)
        let finalCount = Int(finalReportsCount.count)
        
        XCTAssertTrue(initCount == (finalCount-1), "Expected initial count \(initCount) to be 1 less than final count \(finalCount)")
    }

}
