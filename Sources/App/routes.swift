import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    //    let userController = UserController()
    //    router.get("users", use: userController.list)
    //    router.post("users", use: userController.create)
    
    router.get("") { (req) -> String in
        "Well hello there!"
    }
    
    router.post("api", "acronyms") { (req) -> Future<Acronym> in
        try req.content.decode(Acronym.self)
            .flatMap(to: Acronym.self, { (acronym)  in
                acronym.save(on: req)
            })
    }
    
    router.get("api", "acronyms") { req in
        Acronym.query(on: req).all()
    }
    
    router.get("api", "acronyms", Acronym.parameter) { req in
        return try req.parameters.next(Acronym.self)
    }
    
    
    router.put("api", "acronyms", Acronym.parameter) { req in
        return try flatMap(to: Acronym.self,
                           req.parameters.next(Acronym.self),
                           req.content.decode(Acronym.self)) { acronym, updatedAcronym in
                            
                            acronym.short = updatedAcronym.short
                            acronym.long = updatedAcronym.long
                            
                            return acronym.save(on: req)
                            
        }
    }
    
    router.delete("api","acronyms", Acronym.parameter) { req in
        try req.parameters.next(Acronym.self)
            .delete(on: req)
            .transform(to: HTTPStatus.noContent)
    }
    
    router.get("api", "acronyms", "search") { req -> Future<[Acronym]> in
        guard
            let searchTerm = req.query[String.self, at: "term"] else { throw Abort(.badRequest)
        }
        return Acronym.query(on: req)
            .filter(.make(\.short, ._equal, [searchTerm]))
            .all()
    }
    
    router.get("api", "acronyms", "first") { req -> Future<Acronym> in
        return Acronym.query(on: req)
            .first()
            .map(to: Acronym.self) { acronym in
                guard let acronym = acronym else {
                    throw Abort(.notFound) }
                return acronym
        }
    }
    
    router.get("api", "acronyms", "sorted") { req -> Future<[Acronym]> in
        return Acronym.query(on: req)
            .sort(\.short, .ascending)
            .all()
    }
}


