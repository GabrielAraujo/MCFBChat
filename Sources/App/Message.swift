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
    static func sendMessage(to:String, text:String) throws -> Status {
        print("Entered send message")
        print(to)
        do {
            if let accessToken = drop.config["keys", "fb", "access"]?.string {
                let params = [
                    "access_token" : accessToken
                ]
                
                let headers = [
                    HeaderKey("Content-Type"):"application/json"
                ]
                
                let node = Node([
                    "recipient" : try ["id":to].makeNode(),
                    "message": try ["text":text].makeNode()
                    ])
                
                let json = try JSON(node: node)
                let data = json.makeBody()
                
                
                print("Before sending message")
                let resp = try drop.client.post("https://graph.facebook.com/v2.6/me/messages", headers: headers, query: params, body: data)
                
                print(resp)
                return resp.status
            }else{
                print("Missing token")
                return .badRequest
            }
        }catch let e {
            print(e)
            return .badRequest
        }
        
    }
}
