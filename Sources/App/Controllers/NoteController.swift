//
//  NoteController.swift
//  App
//
//  Created by Anilkumar kotur on 21/06/20.
//

import Vapor

/// Controls basic CRUD operations on `Note`s.
final class NoteController: RouteCollection {
    func boot(router: Router) throws {
        let noteRouter = router.grouped("notes")
        noteRouter.get("/", use: index)
        noteRouter.get(Note.parameter, use: show)
        noteRouter.post("/", use: create)
        noteRouter.delete(Note.parameter, use: delete)
        noteRouter.patch(Note.parameter, use: update)
    }
    
    /// Returns a list of all `Note`s.
    func index(_ req: Request) throws -> Future<[Note]> {
        return Note.query(on: req).all()
    }
    
    /// Returns a parameterized `Note`.
    func show(_ req: Request) throws ->  Future<Note> {
        return try req.parameters.next(Note.self)
    }

    /// Saves a decoded `Note` to the database.
    func create(_ req: Request) throws -> Future<Note> {
        return try req.content.decode(Note.self).flatMap { Note in
            return Note.save(on: req)
        }
    }

    /// Deletes a parameterized `Note`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        //TODO: return response message.
        return try req.parameters.next(Note.self).flatMap { Note in
            return Note.delete(on: req)
        }.transform(to: .ok)
    }
    
    /// modifys a parameterized `Note`.
    func update(_ req: Request) throws -> Future<Note> {
        return flatMap(to: Note.self, try req.parameters.next(Note.self), try req.content.decode(Note.self)) { note, updateedNote in
            
            note.title = updateedNote.title
            note.tag = updateedNote.tag
            note.summery = updateedNote.summery
            note.createdAt = updateedNote.createdAt
            note.body = updateedNote.body
            note.authorID = updateedNote.authorID
            
            return note.save(on: req)
        }
    }
    
    func showUser(req: Request) throws -> Future<User> {
        return try req.parameters.next(Note.self).flatMap(to: User.self, { note in
            return note.user.get(on: req)
        })
    }
}

/// 1. What is T?
/// 2. What is future 
