//
//  User.swift
//  App
//
//  Created by Anilkumar kotur on 28/06/20.
//

import FluentSQLite
import Vapor

final class User: SQLiteModel {
    typealias Database = SQLiteDatabase
    
    var id: Int?
    var name: String
    var profilePic: String
    var emailID: String
    var phoneNumber: String
    
    init(id: Int? = nil,
         name: String,
         profilePic: String,
         emailID: String,
         phoneNumber: String) {
        
        self.id = id
        self.name = name
        self.profilePic = profilePic
        self.emailID = emailID
        self.phoneNumber = phoneNumber
    }
}

extension User {

    var notes: Children<User, Note> {
        return children(\.authorID)
    }
}

/// Allows `User` to be used as a dynamic migration.
extension User: Migration { }
/// Allows `User` to be encoded to and decoded from HTTP messages.
extension User: Content { }
/// Allows `User` to be used as a dynamic parameter in route definitions.
extension User: Parameter { }



