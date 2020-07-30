//
//  Note.swift
//  App
//
//  Created by Anilkumar kotur on 21/06/20.
//

import FluentSQLite
import Vapor

/// A single entry of a Note list.
final class Note: SQLiteModel {
    typealias Database = SQLiteDatabase
    
    var id: Int? /// The unique identifier for this `Note`.
    var title: String /// A title describing what this `Note` entails.
    var tag: String /// repersents the color tag of the note  :TODO need to change to color from string
    var createdAt: String /// reperents the date of creation of the note  : TODO: need to change to UNIX time stamp from string
    var summery: String /// reperents the little summer of the note
    var body: String /// reperents the whole note body
    var authorID: User.ID
    
    /// Creates a new `Note`.
    init(id: Int? = nil, title: String, tag: String, summery: String, createdAt: String, body: String, authorID: User.ID) {
        self.id = id
        self.title = title
        self.tag = tag
        self.createdAt = createdAt
        self.summery = summery
        self.body = body
        self.authorID = authorID
    }
}

struct NoteData: Content {
    var title: String /// A title describing what this `Note` entails.
    var tag: String /// repersents the color tag of the note  :TODO need to change to color from string
    var createdAt: String /// reperents the date of creation of the note  : TODO: need to change to UNIX time stamp from string
    var summery: String /// reperents the little summer of the note
    var body: String /// reperents the whole note body
}

extension Note {
    var user: Parent<Note, User> {
        return parent(\.authorID)
    }
}

/// Allows `Note` to be used as a dynamic migration.
extension Note: Migration { }

/// Allows `Note` to be encoded to and decoded from HTTP messages.
extension Note: Content { }

/// Allows `Note` to be used as a dynamic parameter in route definitions.
extension Note: Parameter { }

