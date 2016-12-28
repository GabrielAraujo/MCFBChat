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
        return try Node(node: [
            "template_type" : type.rawValue,
            "text" : text,
            "buttons" : try FBButton.makeNode(objs: buttons),
            "top_element_style" : topElementStyle,
            "elements" : try FBElement.makeNode(objs: elements),
            "buttons" : try FBButton.makeNode(objs: bellowButtons)
            ])
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
