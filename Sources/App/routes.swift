import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // Basic "It works" example
    router.get("notes") { req -> Response in
        struct Note: Content {
            let title: String
            let descripation: String
            let tag: Int
            let body: String
        }
        
        let response = Response(using: req)
        try response.content.encode(Note(title: "First", descripation: "Is small", tag: 1, body: "Not for now"))
        
        return response
    }
    
    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
