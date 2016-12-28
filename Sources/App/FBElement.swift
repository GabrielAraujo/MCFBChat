//
//  FBElement.swift
//  MCFBChat
//
//  Created by Gabriel Araujo on 13/12/16.
//
//

import Foundation
import Vapor

class FBElement {
    var title:String!
    var subtitle:String?
    var imageUrl:String?
    var defaultAction:FBButton?
    var buttons:[FBButton]?
    
    func makeNode() throws -> Node {
        return try Node(node: [
            "title" : title,
            "subtitle" : subtitle,
            "image_url" : imageUrl,
            "default_action" : try defaultAction?.makeNode(),
            "buttons" : try FBButton.makeNode(objs: buttons)
            ])
    }
    
    class func makeNode(objs:[FBElement]?) throws -> Node? {
        var dictArray:[Node] = []
        if let values = objs {
            for obj in values {
                try dictArray.append(obj.makeNode())
            }
            return try Node(node: dictArray)
        }else{
            return nil
        }
    }
}
