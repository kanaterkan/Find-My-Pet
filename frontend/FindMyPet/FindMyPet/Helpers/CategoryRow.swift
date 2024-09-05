//
//  CategoryRow.swift
//  FindMyPet
//
//  Created by Erkan Kanat on 28.11.23.
//

import SwiftUI
struct CategoryRow: View {
    @EnvironmentObject var distanceCalculator: DistanceCalculator
    var user: UserDetail?
    var receivedToken: String

    
    var body: some View {
        VStack {
            // Nearby Reports
            if !distanceCalculator.nearbyReports.isEmpty {
                Text("Nearby Reports: (< 50 km)")
                    .font(.headline)
                    .padding(.bottom, 5)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(distanceCalculator.nearbyReports) { report in
                            NavigationLink(destination: PetReportDetail(report: report, user: user!, receivedToken: receivedToken)) {
                                ReportThumbnail(report: report)
                            }
                        }
                    }
                }
            }

            // Distant Reports
            if !distanceCalculator.distantReports.isEmpty {
                Text("Distant Reports: (> 50 km)")
                    .font(.headline)
                    .padding(.top, 10)
                    .padding(.bottom, 5)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(distanceCalculator.distantReports) { report in
                            NavigationLink(destination: PetReportDetail(report: report, user: user!, receivedToken: receivedToken)) {
                                ReportThumbnail(report: report)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ReportThumbnail: View {
    var report: ReportDetail

    var body: some View {
        VStack {
            if let uiImage = decodeBase64ToImage(report.petPicture) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
            }

            Text(report.petName)
                .font(.caption)
                .lineLimit(1)
        }
    }

    func decodeBase64ToImage(_ base64String: String) -> UIImage? {
        var cleanedBase64String = base64String

        // Entferne das Präfix "data:image/jpeg;base64,"
        if let prefixRange = cleanedBase64String.range(of: "base64,") {
            cleanedBase64String.removeSubrange(cleanedBase64String.startIndex..<prefixRange.upperBound)
        }

        // Entferne Zeilenumbrüche und Leerzeichen
        cleanedBase64String = cleanedBase64String.replacingOccurrences(of: "\r\n", with: "")
        cleanedBase64String = cleanedBase64String.replacingOccurrences(of: " ", with: "")

        if let data = Data(base64Encoded: cleanedBase64String) {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
}
