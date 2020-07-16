//
//  User.swift
//  App
//
//  Created by Anilkumar kotur on 28/06/20.
//

import FluentSQLite
import Vapor
import Authentication

final class User: SQLiteModel {
    typealias Database = SQLiteDatabase
    
    var id: Int?
    var name: String
    var profilePic: String
    var emailID: String
    var phoneNumber: String
    
    var password: String
    
    init(id: Int? = nil,
         name: String,
         profilePic: String,
         emailID: String,
         phoneNumber: String,
         password: String) {
        
        self.id = id
        self.name = name
        self.profilePic = profilePic
        self.emailID = emailID
        self.phoneNumber = phoneNumber
        self.password = password
    }
    
    final public class PublicUser: Content {
        var id: Int?
        var name: String
        var profilePic: String
        var emailID: String
        var phoneNumber: String
        
        init(name: String,
             profilePic: String,
             emailID: String,
             phoneNumber: String) {
            self.name = name
            self.profilePic = profilePic
            self.emailID = emailID
            self.phoneNumber = phoneNumber
        }
        
        public init(user: User) {
            if let id = user.id  {
                self.id = id
            }            
            self.name = user.name
            self.profilePic = user.profilePic
            self.emailID = user.emailID
            self.phoneNumber = user.phoneNumber
        }
    }
}

extension User {

    var notes: Children<User, Note> {
        return children(\.authorID)
    }
}

extension User.PublicUser: SQLiteModel {
    static let entity = User.entity
}

extension User.PublicUser: Parameter { }

/// Allows `User` to be used as a dynamic migration.
extension User: Migration { }
/// Allows `User` to be encoded to and decoded from HTTP messages.
extension User: Content { }
/// Allows `User` to be used as a dynamic parameter in route definitions.
extension User: Parameter { }
extension User: BasicAuthenticatable {
    static var usernameKey: UsernameKey {
        return \User.name
    }
    
    static var passwordKey: PasswordKey {
        return \User.password
    }
}
