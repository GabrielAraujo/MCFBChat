//
//  FBTemplate.swift
//  MCFBChat
//
//  Created by Gabriel Araujo on 20/12/16.
//
//

import Foundation
import Vapor

enum FBTemplateType : String {
    case button = "button"
    case generic = "generic"
    case list = "list"
}

class FBTemplate {
    var type:FBTemplateType!
    var text:String?
    var buttons:[FBButton]?
    var topElementStyle:String?
    var elements:[FBElement]?
    var bellowButtons:[FBButton]?

    func makeNode() throws -> Node {
        var buttons:[FBButton]!
        if self.buttons != nil {
            buttons = self.buttons
        }else{
            buttons = self.bellowButtons
        }
        var dict = [
            "template_type" : try Node(node: type.rawValue),
            "text" : try Node(node: text),
            "buttons" : try FBButton.makeNode(objs: buttons),
            "top_element_style" : try Node(node: topElementStyle),
            "elements" : try FBElement.makeNode(objs: elements)
        ] as [String : Node?]
        let keysToRemove = dict.keys.array.filter { dict[$0]! == nil || (dict[$0]! as Node?) == Node.null }
        for key in keysToRemove {
            dict.removeValue(forKey: key)
        }
        return try Node(node: dict)
    }
    
    class func makeNode(objs:[FBTemplate]?) throws -> Node? {
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

//class FBTemplateButton : FBTemplate {
//    var text:String!
//    var buttons:[FBButton]! //Limit 3 buttons
//}
//
//class FBTemplateGeneric : FBTemplate {
//    var elements:[FBElement]!
//}
//
//class FBTemplateList : FBTemplate {
//    var topElementStyle:String?
//    var elements:[FBElement]!
//    var buttons:[FBButtons]? //Only one button
//}
