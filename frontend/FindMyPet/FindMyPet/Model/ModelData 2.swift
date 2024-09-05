//
//  ModelData.swift
//  FindMyPet
//
//  Created by Erkan Kanat on 28.11.23.
//

import Foundation

func loadPetReports(completion: @escaping ([ReportDetail]) -> Void) async throws {
    guard let url = URL(string: "http://localhost:3000/pet-reports") else {
        throw RequestError.invalidURL
    }

    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw RequestError.httpError
        }

        let decoder = JSONDecoder()
        let petReports = try decoder.decode([ReportDetail].self, from: data)
        
        completion(petReports)  // Hier wird der Completion-Handler aufgerufen
    } catch {
        throw error
    }
}


