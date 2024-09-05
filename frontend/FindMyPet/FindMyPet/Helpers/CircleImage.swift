//
//  CircleImage.swift
//  FindMyPet
//
//  Created by Erkan Kanat on 08.11.23.
//
import SwiftUI

struct CircleImage: View {
    var report: ReportDetail
    
    var body: some View {
        AnyView(content)
    }
    
    @ViewBuilder
    private var content: some View {
        if let imageData = decodeBase64ToImage(report.petPicture),
           let uiImage = UIImage(data: imageData) {
            
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .frame(maxWidth: .infinity)
                .shadow(color: .black, radius: 5)
        } else {
            // Fallback-Ansicht, falls das Bild nicht geladen werden kann
            Image(systemName: "photo")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .frame(maxWidth: .infinity)
                .shadow(color: .black, radius: 5)
        }
    }
}

// Die decodeBase64ToImage Funktion hier einfügen
func decodeBase64ToImage(_ base64String: String) -> Data? {
    var cleanedBase64String = base64String

    // Entferne das Präfix "data:image/jpeg;base64,"
    if let prefixRange = cleanedBase64String.range(of: "base64,") {
        cleanedBase64String.removeSubrange(cleanedBase64String.startIndex..<prefixRange.upperBound)
    }

    // Entferne Zeilenumbrüche und Leerzeichen
    cleanedBase64String = cleanedBase64String.replacingOccurrences(of: "\r\n", with: "")
    cleanedBase64String = cleanedBase64String.replacingOccurrences(of: " ", with: "")

    return Data(base64Encoded: cleanedBase64String)
}
