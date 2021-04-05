//
//  Token.swift
//  App
//
//  Created by Anilkumar kotur on 16/07/20.
//

import FluentPostgresDriver
import Vapor


final class Token: PostgreSQLModel {
    typealias Database = PostgreSQLDatabase
    
    var id: Int?
    var token: String
    var userID: User.ID
    
    init(token: String, userID: User.ID) {
        self.token = token
        self.userID = userID
    }
    
    init(_ user: User) throws {
        if let token = try? CryptoRandom().generateData(count: 16).base64EncodedString() {
            self.token = token
        } else {
            self.token = UUID().uuidString
        }
        self.userID = try user.requireID()
    }
}

extension Token {
    var user: Parent<Token, User> {
        return parent(\.id)!  //TODD: Need to verify this
    }
}

extension Token: Authentication.Token {
    static var tokenKey: TokenKey {
        return \Token.token
    }
    
    static let userIDKey: UserIDKey = \Token.userID
    typealias UserType = User
}

//extension BearerAuthenticatable {
//    static let tokenkey: TokenKey = \Token.token
//}

/// Allows `Token` to be used as a dynamic migration.
extension Token: Migration { }

/// Allows `Token` to be encoded to and decoded from HTTP messages.
extension Token: Content { }

/// Allows `Token` to be used as a dynamic parameter in route definitions.
extension Token: Parameter { }
