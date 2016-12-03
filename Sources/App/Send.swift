//
//  Send.swift
//  MCFBChat
//
//  Created by Gabriel Araujo on 02/12/16.
//
//

import Foundation
import Vapor
import HTTP

class Send {
    class func send(data:Node) throws -> Status {
        do {
            if let accessToken = drop.config["keys", "fb", "access"]?.string {
                let params = [
                    "access_token" : accessToken
                ]
                
                let headers = [
                    HeaderKey("Content-Type"):"application/json"
                ]
                
                let json = try JSON(node: data)
                let data = json.makeBody()
                
                
                print("Before sending")
                let resp = try drop.client.post("https://graph.facebook.com/v2.8/me/messages", headers: headers, query: params, body: data)
                
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
