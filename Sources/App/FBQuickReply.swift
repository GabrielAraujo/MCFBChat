//
//  FBQuickReply.swift
//  MCFBChat
//
//  Created by Gabriel Araujo on 12/12/16.
//
//

import Foundation
import Vapor

enum FBQuickReplyType : String {
    case text = "text"
    case image = "image"
    case location = "location"
}

class FBQuickReply {
    var type:FBQuickReplyType!
    var title:String?
    var payload:String?
    var imageUrl:String?

    class func makeNode(objs:[FBQuickReply]) throws -> Node {
        var dictArray:[Node] = []
        try objs.forEach({
            obj in
            switch obj.type! {
            case .text:
                let dict = try Node(node: ["content_type" : "text",
                            "title" : obj.title,
                            "payload" : obj.payload
                ])
                dictArray.append(dict)
                break
            case .image:
                let dict = try Node(node: ["content_type" : "text",
                            "title" : obj.title,
                            "payload" : obj.payload,
                            "image_url" : obj.imageUrl!
                ])
                dictArray.append(dict)
                break
            case .location:
                let dict = try ["content_type" : "location"].makeNode()
                dictArray.append(dict)
                break
            }
        })
        return try Node(node: dictArray)
    }
}
