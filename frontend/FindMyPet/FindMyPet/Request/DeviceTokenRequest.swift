//
//  DeviceTokenRequest.swift
//  FindMyPet
//
//  Created by Vincent Siopis on 07.01.24.
//

import Foundation

struct DeviceTokenRequest {
    static func sendDeviceTokenToServer(token: String, userID: String) async {
        print("Sending device token to server with token: \(token) and userID: \(userID)")
        
        guard let url = URL(string: "\(AppConfig.baseURL)/users/\(userID)/device-token") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["deviceToken": token]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 {
                print("Device token updated successfully")
            } else {
                print("Server responded with an error")
            }
        } catch {
            print("Error sending device token: \(error)")
            print("Error sending device token: \(error.localizedDescription)")
        }
    }
}
