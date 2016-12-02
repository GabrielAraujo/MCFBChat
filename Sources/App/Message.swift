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
    static func sendMessage(recipientId:String, text:String) {
        print("Entered send message")
        do {
            if let accessToken = drop.config["keys", "fb", "access"]?.string {
                let params = [
                    "access_token" : accessToken
                ]
                
                let headers = [
                    HeaderKey("Content-Type"):"application/json"
                ]
                
                let node = Node([
                    "recipient" : try ["id":recipientId].makeNode(),
                    "message": try ["text":text].makeNode()
                    ])
                
                let json = try JSON(node: node)
                let data = json.makeBody()
                
                let resp = try drop.client.post("https://graph.facebook.com/v2.6/me/messages", headers: headers, query: params, body: data)
                
                if resp.status == .ok {
                    print("Ok")
                }
            }else{
                print("Missing token")
                //Missing accessToken
            }
        }catch let e {
            print(e)
        }
        
    }
}
