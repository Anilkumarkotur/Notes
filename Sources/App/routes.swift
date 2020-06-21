import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    // Example of configuring a controller
    let noteController = NoteController()
    try router.register(collection: noteController)
    router.get("notes", use: noteController.index)
    router.post("notes", use: noteController.create)
    router.delete("notes", Note.parameter, use: noteController.delete)
}
