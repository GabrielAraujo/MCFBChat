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
        let dict = [
            "title" : try Node(node: title),
            "subtitle" : try Node(node: subtitle),
            "image_url" : try Node(node: imageUrl),
            "default_action" : try defaultAction?.makeNode(),
            "buttons" : try FBButton.makeNode(objs: buttons)
        ] as [String : Node?]
        let cleanedDict = dict.keys.array.flatMap { $0 }
//        let keysToRemove = dict.keys.array.filter { dict[$0]! == nil || (dict[$0]! as Node?) == Node.null }
//        for key in keysToRemove {
//            dict.removeValue(forKey: key)
//        }
        return try Node(node: cleanedDict)
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
