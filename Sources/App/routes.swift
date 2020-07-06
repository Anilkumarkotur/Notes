import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    // Example of configuring a controller
    let noteController = NoteController()
    try router.register(collection: noteController)
    router.get("notes", use: noteController.index)
    router.post("notes", use: noteController.create)

    
    let userController = UserController()
    try router.register(collection: userController)
    router.get("users", use: userController.index)
    router.post("users", use: userController.create)

}
