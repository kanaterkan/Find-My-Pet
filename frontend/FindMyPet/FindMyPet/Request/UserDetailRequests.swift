//
//  UserDetailRequests.swift
//  FindMyPet
//
//  Created by Feyza Serin on 15.11.23.
//

import Foundation


enum RequestError: Error {
    case invalidURL
    case missingData
    case httpError
    case missingID
    case unauthorized
    case unexpectedStatusCode
    case unknown
    case internalErr
    case clientError(code: Int)
    case serverError(code: Int)
}

func postUser(urlString: String, userDetail: UserDetail) async throws -> String {
    
    //Check the URL
    guard let url = URL(string: "\(urlString)") else {
        throw RequestError.invalidURL
    }
    
    //Define the request
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    //Encode the data to post
    let encoded = try JSONEncoder().encode(userDetail)
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
            switch code {
            case 400: throw RequestError.missingData
            case 401: throw RequestError.unauthorized
            case 400...499: throw RequestError.unexpectedStatusCode
            case 500...510: throw RequestError.internalErr
            default: throw RequestError.unknown
            }
            //print("HTTP Error Status Code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
   
            //throw RequestError.httpError
        }
   
   let lu = LoginUser(email: userDetail.email, password: userDetail.password!)
    
    let urlString = "\(AppConfig.baseURL)/users/login"
    var token:String
    token = try await postLogin(urlString: urlString, loginUser: lu);
    print("PostuserRequest= ", token)
    return token
    
}



func deleteUser(urlString:String, userDetail: UserDetail, token:String) async throws {
    
    
    guard userDetail.id != nil else {
        throw RequestError.missingID
    }
    
    let aString = "\(urlString)/\(userDetail.id!)"
    print(aString)
    //Check the URL
    

    
    guard let url = URL(string: "\(urlString)/\(userDetail.id!)") else {
        throw RequestError.invalidURL
    }
    
    
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")  // Hier fügst du den Bearer Token hinzu
    request.httpMethod = "DELETE"

    let encoded = try? JSONEncoder().encode(userDetail)
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



func editUser(urlString: String, userDetail: UserDetail, token: String) async throws {
    
    // Check the URL
    guard let url = URL(string: "\(urlString)/users/\(userDetail.id!)") else {
        throw RequestError.invalidURL
    }
    
    // Define the request
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "PATCH" // Assuming you are using a PUT request for editing
    
    // Encode the updated user data
    let encoded = try JSONEncoder().encode(userDetail)
    request.httpBody = encoded
    
    // Do the request
    do {
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299) ~= httpResponse.statusCode else {
            print("HTTP Error Status Code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            throw RequestError.httpError
        }
    } catch {
        throw error
    }
}



//[Würde Array heißen]
func getUser(urlString:String, userDetail:UserDetail) async throws -> UserDetail {
    
    //Check the URL
    guard let url = URL(string: "\(urlString)/\(userDetail.id)") else {
        throw RequestError.invalidURL
    }
   
    //Do the request - no forced unwrap of url as it has been checked above
    let(data,response) = try await URLSession.shared.data(from: url)
    
    
    
    //Throw an error if request could not be processed
    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
        throw RequestError.httpError
    }
    
    let user = try JSONDecoder().decode(UserDetail.self, from: data)
    
    return user
    
}




func whoAmI(urlString: String, token: String) async throws -> UserDetail {
    // Check the URL
    guard let url = URL(string:urlString) else {
        throw RequestError.invalidURL
    }

    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    // Do the request - no forced unwrap of url as it has been checked above
    let (data, response) = try await URLSession.shared.data(for: request)

    // Throw an error if the request could not be processed
    guard let httpResponse = response as? HTTPURLResponse, (200...299) ~= httpResponse.statusCode else {
        let code = (response as? HTTPURLResponse)!.statusCode

        switch code {
        case 401: throw RequestError.unauthorized
        case 422: throw RequestError.unauthorized
        case 400...499: throw RequestError.unexpectedStatusCode
        case 500...510: throw RequestError.internalErr
        default: throw RequestError.unknown
        }
    }

    let userDetail = try JSONDecoder().decode(UserDetail.self, from: data)
    print("Userdetail: ", userDetail)
    return userDetail
}


struct TokenResponse: Decodable {
    let token: String
}

func postLogin(urlString: String, loginUser: LoginUser) async throws -> String {
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let encoded = try JSONEncoder().encode(loginUser)
    request.httpBody = encoded
    
    if let jsonString = String(data: encoded, encoding: .utf8) {
           print("Encoded JSON string: \(jsonString)")
       } else {
           print("Unable to convert encoded data to string.")
       }
    
    
    let (data, response) = try await URLSession.shared.data(for: request)
    print(data)
    guard let httpResponse = response as? HTTPURLResponse, (200...299) ~= httpResponse.statusCode else {
        let code = (response as? HTTPURLResponse)!.statusCode
        switch code {
            
        case 401: throw RequestError.unauthorized
        case 422: throw RequestError.unauthorized
        case 400...499: throw RequestError.unexpectedStatusCode
            
        case 500...510: throw RequestError.internalErr
        default: throw RequestError.unknown
        }
    }
    do {
           let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
           let token = tokenResponse.token
           print("LoginUserRequest= ",token)
           return token
       } catch {
           throw RequestError.unknown
       }
}



func getUsersCount(urlString: String) async throws -> UsersCount {
    
    guard let url = URL(string: "\(urlString)/users/count") else {
        throw RequestError.invalidURL
    }
    
    let(data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else { throw RequestError.httpError}
    
    let UsersCount = try JSONDecoder().decode(UsersCount.self, from: data)
    return UsersCount
}


func getUserPetReports(urlString: String, userID: Int) async throws -> [ReportDetail] {
    // Check the URL
    guard let url = URL(string: "\(urlString)/users/\(userID)/pet-reports") else {
        throw RequestError.invalidURL
    }

    do {
        // Do the request - no forced unwrap of url as it has been checked above
        let (data, response) = try await URLSession.shared.data(from: url)

        // Throw an error if the request could not be processed
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw RequestError.httpError
        }

        // Decode the response data into an array of ReportDetail
        let reports = try JSONDecoder().decode([ReportDetail].self, from: data)
        return reports
    } catch {
        throw error
    }
}

