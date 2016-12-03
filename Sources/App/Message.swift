//
//  Message.swift
//  MCFBChat
//
//  Created by Gabriel Araujo on 01/12/16.
//
//

import Foundation
import Vapor
import HTTP

class Message {
    static func sendText(to:User, text:String) throws -> Status {
        print("Entered send message")
        print(to)
        do {
            let node = Node([
                "recipient" : try ["id":to.fbId].makeNode(),
                "message": try ["text":text].makeNode()
                ])
            
            return try Send.send(data: node)
        }catch let e {
            print(e)
            return .badRequest
        }
        
    }

    static func sendImage(to:User, imageUrl:String) throws -> Status {
        print("Entered send image message")
        print(to)
        do {
            let node = Node([
                "recipient" : try ["id":to.fbId].makeNode(),
                "message": try ["text": [
                    "attachment" : try [
                        "type" : "image",
                        "payload": try [
                                "url":imageUrl
                            ].makeNode()
                        ].makeNode()
                    ].makeNode()
                ].makeNode()
            ])
            
            return try Send.send(data: node)
        }catch let e {
            print(e)
            return .badRequest
        }
        
    }
}
