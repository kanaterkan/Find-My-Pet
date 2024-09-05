//
//  UserDetail.swift
//  FindMyPet
//
//  Created by Feyza Serin on 15.11.23.
//

import Foundation

struct UserDetail: Codable, Hashable {
    var id: Int?
    var firstname: String
    var lastname: String
    var email: String
    var password: String?
    var phoneNumber: String
    var petReports: [ReportDetail]?
}
