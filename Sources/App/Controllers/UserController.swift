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
        userRouter.post("/", use: create)
        userRouter.get(User.parameter, "notes", use: showNotes)
        
        
        let basicAuthMiddleWare = User.basicAuthMiddleware(using: BCryptDigest())
        let authGroup = userRouter.grouped(basicAuthMiddleWare)
        authGroup.post("login", use: loginHandler)
        
        let tokenAuthMiddleWare = User.tokenAuthMiddleware()
        let tokenGroup = userRouter.grouped(tokenAuthMiddleWare)
        tokenGroup.get("notes", use: handleUserNotes)
    }
    
    func loginHandler(_ req: Request) throws -> Future<Token> {
        let user = try req.requireAuthenticated(User.self)
        let token = try Token(user)
        return token.save(on: req)
    }
    
    func handleUserNotes(_ req: Request) throws -> Future<[Note]> {
        let user = try req.requireAuthenticated(User.self)
        return try user.notes.query(on: req).all()
    }
    
    /// Returns a list of all `User`s.
    func index(_ req: Request) throws -> Future<[User.PublicUser]> {
        return User.PublicUser.query(on: req).all()
    }
    
    /// Saves a decoded `User` to the database.
    /* Resource:
        1. https://medium.com/swift2go/vapor-3-series-ii-authentication-ff17847a9659
        2. https://www.vaporforums.io/viewThread/45#:~:text=In%20Vapor%203%2C%20if%20you,Future%20. very good resource.
    */
    func create(_ req: Request) throws -> Future<User.PublicUser> {
        return try req.content.decode(User.self).map(to: User.PublicUser.self) { user in
            let hasher = try req.make(BCryptDigest.self)
            let hashedPassword = try hasher.hash(user.password)
            user.password = hashedPassword
            _ = user.create(on: req)
            let publicUser = User.PublicUser(user: user)
            return publicUser
        }        
    }
    
    func showNotes(_ req: Request) throws -> Future<[Note]> {
        return try req.parameters.next(User.self).flatMap(to: [Note].self, { user in
            return try user.notes.query(on: req).all()
        })
    }
}
