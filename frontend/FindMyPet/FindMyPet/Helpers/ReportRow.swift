//
//  ReportRow.swift
//  FindMyPet
//
//  Created by Erkan Kanat on 22.11.23.
//

import SwiftUI
class ReportRowViewModel: ObservableObject {
    @Published var decodedImage: UIImage?
    
    init(report: ReportDetail) {
        decodeBase64ToImage(report: report)
    }
    
    func decodeBase64ToImage(report: ReportDetail) {
        var cleanedBase64String = report.petPicture

        // Entferne das Präfix "data:image/jpeg;base64,"
        if let prefixRange = cleanedBase64String.range(of: "base64,") {
            cleanedBase64String.removeSubrange(cleanedBase64String.startIndex..<prefixRange.upperBound)
        }

        // Entferne Zeilenumbrüche und Leerzeichen
        cleanedBase64String = cleanedBase64String.replacingOccurrences(of: "\r\n", with: "")
        cleanedBase64String = cleanedBase64String.replacingOccurrences(of: " ", with: "")

        if let data = Data(base64Encoded: cleanedBase64String) {
            print("Base64-decoded data: \(data)")

            if let image = UIImage(data: data) {
                print("Image created successfully")
                decodedImage = image
            } else {
                print("Failed to create image from data")
            }
        } else {
            print("Failed to decode Base64 string to data")
        }
    }
}

struct ReportRow: View {
    @StateObject private var viewModel: ReportRowViewModel
    var report: ReportDetail
    
    init(report: ReportDetail) {
        _viewModel = StateObject(wrappedValue: ReportRowViewModel(report: report))
        self.report = report
    }
    
    var body: some View {
        HStack {
            if let image = viewModel.decodedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .padding()
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 80, height: 80)
                    .padding()
            }
            
            Text(report.petName)
            
            Spacer()
        }
        .onAppear {
            viewModel.decodeBase64ToImage(report: report)
        }
    }
}
