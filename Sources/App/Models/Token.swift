//
//  Token.swift
//  App
//
//  Created by Anilkumar kotur on 16/07/20.
//

import FluentSQLite
import Vapor
import Authentication
import FluentSQLite
import Crypto

final class Token: SQLiteModel {
    typealias Database = SQLiteDatabase
    
    var id: Int?
    var token: String
    var userID: User.ID
    
    init(token: String,
         userID: User.ID) {
        
        self.token = token
        self.userID = userID
    }
    
    init(_ user: User) throws {
        let token = "" //TODO: Replace with OSRandom().data(count: 16).base64EncodingString() 
        self.token = token
        self.userID = try user.requireID()
    }

}

extension Token {
    var user: Parent<Token, User> {
        return parent(\.id)!  //TODD: Need to verify this
    }
}

/// Allows `Token` to be used as a dynamic migration.
extension Token: Migration { }

/// Allows `Token` to be encoded to and decoded from HTTP messages.
extension Token: Content { }

/// Allows `Token` to be used as a dynamic parameter in route definitions.
extension Token: Parameter { }
