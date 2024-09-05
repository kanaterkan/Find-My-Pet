//
//  ReportList.swift
//  FindMyPet
//
//  Created by Erkan Kanat on 22.11.23.
//

import SwiftUI
struct ReportList: View {
    @State private var userPetReports: [ReportDetail] = []
    var receivedToken:String?
    var user: UserDetail?

    
    
    var body: some View {
        NavigationView{
            List(userPetReports, id: \.id) { report in
                NavigationLink(destination: PetReportDetail(report: report, user: user!, receivedToken: receivedToken!)) {
                    ReportRow(report: report)
                }
            }
            .navigationTitle("My Reports")
        }
        .onAppear {
            Task {
                do {
                    // Annahme: Du hast bereits eine userID, die verwendet werden soll
                    let urlString2 = "\(AppConfig.baseURL)/whoAmI"
                    
                    let user = try await whoAmI(urlString: urlString2, token: receivedToken!) // Beispielwert, ersetze dies durch deine Logik

                    // Annahme: Du hast bereits eine baseURL, die verwendet werden soll
                    let urlString = "\(AppConfig.baseURL)" // Beispielwert, ersetze dies durch deine Logik

                    let reports = try await getUserPetReports(urlString: urlString, userID: user.id!)
                    
                    userPetReports = reports
                } catch {
                    print("Error fetching user pet reports: \(error)")
                    // Handle errors appropriately
                }
            }
        }
    }
}

