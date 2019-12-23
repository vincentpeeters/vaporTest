import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    //    let userController = UserController()
    //    router.get("users", use: userController.list)
    //    router.post("users", use: userController.create)
    
    router.get("test") { (req) -> String in
        "test"
    }
    
    router.post("api", "acronyms") { (req) -> Future<Acronym> in
        try req.content.decode(Acronym.self)
            .flatMap(to: Acronym.self, { (acronym)  in
                acronym.save(on: req)
            })
    }
    
}
