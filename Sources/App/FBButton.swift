//
//  FBButtonTemplate.swift
//  MCFBChat
//
//  Created by Gabriel Araujo on 13/12/16.
//
//

import Foundation
import Vapor

enum FBButtonType : String {
    case webUrl = "web_url"
    case postback = "postback"
    case phoneNumber = "phone_number"
    case share = "element_share"
    case buy = "payment"
}

class FBButton {
    var type:FBButtonType!
    
    func makeNode() throws -> Node {
        return try Node(node: ["type" : type.rawValue])
    }
    
    class func makeNode(objs:[FBButton]) throws -> Node {
        var dictArray:[Node] = []
        for obj in objs {
            try dictArray.append(obj.makeNode())
        }
        return try Node(node: dictArray)
    }
}

class FBButtonUrl : FBButton {
    enum HeightRatio : String {
        case compact = "compact"
        case tall = "tall"
        case full = "full"
    }
    
    var title:String?
    var url:String?
    var heightRatio:HeightRatio?
    //var messenger_extensions
    //var fallback_url
    
    override func makeNode() throws -> Node {
        return try Node(node: ["type" : type.rawValue,
                               "title" : title!,
                               "url" : url!,
                               "webview_height_ratio" : heightRatio!.rawValue])
    }
}

class FBButtonPostback : FBButton {
    var title:String?
    var payload:String?
    
    override func makeNode() throws -> Node {
        return try Node(node: ["type" : type.rawValue,
                               "title" : title!,
                               "payload" : payload!])
    }
}

class FBButtonCall : FBButton {
    var title:String?
    var payload:String? //Must contain + Country code + area code + number
    
    override func makeNode() throws -> Node {
        return try Node(node: ["type" : type.rawValue,
                               "title" : title!,
                               "payload" : payload!])
    }
}

class FBButtonShare : FBButton {}

class FBButtonBuy : FBButton {
    var title:String?
    var payload:String?
    //... TBC
}


