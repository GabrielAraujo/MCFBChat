//
//  Past.swift
//  MCFBChat
//
//  Created by Gabriel Araujo on 10/12/16.
//
//
import Vapor
import Fluent
import Foundation

final class Past: Model {
    var id: Node?
    var userId:String?
    var language: String?
    var previous:String?
    
    // used by fluent internally
    var exists: Bool = false
    
    init(language: String, userId:String) {
        self.id = UUID().uuidString.makeNode()
        self.language = language
        self.userId = userId
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        language = try node.extract("language")
        userId = try node.extract("userId")
        previous = try node.extract("previous")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "language": language,
            "userId" : userId,
            "previous" : previous
            ])
    }
}

extension Past {
    /**
     This will automatically fetch from database, using example here to load
     automatically for example. Remove on real models.
     */
}

extension Past: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("pasts") { pasts in
            pasts.id()
            pasts.string("language")
            pasts.string("userId")
            pasts.string("previous")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("pasts")
    }
}

