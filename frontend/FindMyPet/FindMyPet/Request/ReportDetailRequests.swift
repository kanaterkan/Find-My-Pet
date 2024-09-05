//
//  ReportDetailRequests.swift
//  FindMyPet
//
//  Created by Feyza Serin on 15.11.23.
//

import Foundation


//enum RequestError: Error {
//    case invalidURL
//    case missingData
//    case httpError
//    case missingID
//}



    
func postReport(urlString: String, reportDetail: ReportDetail, token: String) async throws {
        
        //Check the URL
        guard let url = URL(string: "\(urlString)") else {
            throw RequestError.invalidURL
        }
        
        //Define the request
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        //Encode the data to post
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        
        let encoded = try JSONEncoder().encode(reportDetail)
        request.httpBody = encoded
        
        if let jsonString = String(data: encoded, encoding: .utf8) {
            print("Encoded JSON string: \(jsonString)")
        } else {
            print("Unable to convert encoded data to string.")
        }
        //Do thr rquest with a DataTask
        
        
        //Throw an error if request could not be processed
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299) ~= httpResponse.statusCode else {
            let code = (response as? HTTPURLResponse)!.statusCode
            
            // Versuchen, den Text der Serverantwort zu extrahieren
            if let data = response as? Data, let errorMessage = String(data: data, encoding: .utf8) {
                print("Server Error Message: \(errorMessage)")
            }
            
            switch code {
            case 401: throw RequestError.unauthorized
            case 400...499: throw RequestError.clientError(code: code)
            case 500...510: throw RequestError.serverError(code: code)
            default: throw RequestError.unknown
            }
            
            //print("HTTP Error Status Code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            
            //throw RequestError.httpError
        }
        
        
    }
    
    
func deleteReport(urlString: String, reportDetail: ReportDetail, token: String) async throws  {
        
        
        guard reportDetail.id != nil else {
            throw RequestError.missingID
        }
        //http://localhost:3000/pet-reports/14
        
        
        let aString = "\(urlString)/\(reportDetail.id!)"
        print(aString)
        
        //check the url
        guard let url = URL(string: "\(urlString)/\(reportDetail.id!)") else {
            throw RequestError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        
        let encoded = try? JSONEncoder().encode(reportDetail)
        request.httpBody = encoded
        
        
        //Throw an error if request could not be processed
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                print("HTTP Error Status Code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                throw RequestError.httpError
            }
        } catch {
            throw error
        }
        
        
        
        
        
    }


    
func getReport(urlString:String, reportDetail:ReportDetail) async throws -> ReportDetail {
        
        //Check the URL
        guard let url = URL(string: "\(urlString)/\(reportDetail.id)") else {
            throw RequestError.invalidURL
        }
        
    
        
        //Do the request - no forced unwrap of url as it has been checked above
        let(data,response) = try await URLSession.shared.data(from: url)
        
        
        
        //Throw an error if request could not be processed
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw RequestError.httpError
        }
        
        let report = try JSONDecoder().decode(ReportDetail.self, from: data)
        
        return report
        
    }


    
    
    func getReportsCount(urlString: String) async throws -> ReportsCount {
        
        
        // Check the URL
        guard let url = URL(string: "\(urlString)/pet-reports/count") else {
            throw RequestError.invalidURL
        }
        
        let(data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else { throw RequestError.httpError}
        
        let ReportsCount = try JSONDecoder().decode(ReportsCount.self, from: data)
        return ReportsCount
    }
    
    
func editReport(urlString: String, report: ReportDetail, token: String) async throws {
    
    //check the url
    guard let url = URL(string: "\(urlString)/pet-reports/\(report.id!)") else {
        throw RequestError.invalidURL
    }
    
    //Define the request
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "PATCH"
    
    let encoded = try JSONEncoder().encode(report)
    request.httpBody = encoded
    
    do {
        let(_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299) ~= 
            httpResponse.statusCode else {
                print("HTTP Error Status Code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                throw RequestError.httpError
        }
    } catch {
        throw error
    }
    
}
    

