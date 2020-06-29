//
//  UserController.swift
//  App
//
//  Created by Anilkumar kotur on 28/06/20.
//

import Vapor

/// Controls basic CRUD operations on `User`s.
final class UserController: RouteCollection {
    func boot(router: Router) throws {
        let userRouter = router.grouped("users")
        userRouter.get("/", use: index)
        userRouter.get(User.parameter, use: show)
        userRouter.post("/", use: create)
        userRouter.get(User.parameter, "notes", use: showNotes)
        //user/:id/notes
    }
    
    /// Returns a list of all `User`s.
    func index(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    /// Returns a parameterized `User`.
    func show(_ req: Request) throws ->  Future<User> {
        return try req.parameters.next(User.self)
    }

    /// Saves a decoded `User` to the database.
    func create(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { User in
            return User.save(on: req)
        }
    }
    
    func showNotes(_ req: Request) throws -> Future<[Note]> {
        return try req.parameters.next(User.self).flatMap(to: [Note].self, { user in
            return try user.notes.query(on: req).all()
        })
    }
}

