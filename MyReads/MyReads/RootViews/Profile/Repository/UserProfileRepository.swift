//
//  UserProfileRepository.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 23/7/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserProfileRepository {
    private let datasource: UserProfileDatasource
    
    init(datasource: UserProfileDatasource = UserProfileDatasource()) {
        self.datasource = datasource
    }
    
    func createBDUser(auth: User) async throws {
        try await datasource.createBDUser(auth: auth)
    }
    
    func getBSUser(userId: String) async throws -> User? {
        try await datasource.getBSUser(userId: userId)
    }
    
    func updateUser(auth: User) async throws {
        try await datasource.updateUser(auth: auth)
    }
}
