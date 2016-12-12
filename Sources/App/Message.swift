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
        do {
            let node = Node([
                "recipient" : try ["id":to.fbId].makeNode(),
                "message" : try ["attachment" : [
                    "type" : "image",
                    "payload": try [
                        "url":imageUrl
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
    
    static func sendVideo(to:User, videoUrl:String) throws -> Status {
        print("Entered send video message")
        do {
            let node = Node([
                "recipient" : try ["id":to.fbId].makeNode(),
                "message" : try ["attachment" : [
                    "type" : "video",
                    "payload": try [
                        "url":videoUrl
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
    
    static func sendAudio(to:User, audioUrl:String) throws -> Status {
        print("Entered send audio message")
        do {
            let node = Node([
                "recipient" : try ["id":to.fbId].makeNode(),
                "message" : try ["attachment" : [
                    "type" : "audio",
                    "payload": try [
                        "url":audioUrl
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
    
    static func sendFile(to:User, fileUrl:String) throws -> Status {
        print("Entered send file message")
        do {
            let node = Node([
                "recipient" : try ["id":to.fbId].makeNode(),
                "message" : try ["text" : [
                    "type" : "file",
                    "payload": try [
                        "url":fileUrl
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
    
    static func sendQuickReply(to:User, text:String, quickReplys:[FBQuickReply]) throws -> Status {
        print("Entered send quickReply message")
        do {
            let node = Node([
                "recipient" : try ["id":to.fbId].makeNode(),
                "message" : try [
                    "text" : text,
                    "quick_replies": try FBQuickReply.makeNode(objs: quickReplys)].makeNode()
                ])
            return try Send.send(data: node)
        }catch let e {
            print(e)
            return .badRequest
        }
    }
}
