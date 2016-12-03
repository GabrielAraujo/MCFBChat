//
//  User.swift
//  MCFBChat
//
//  Created by Gabriel Araujo on 03/12/16.
//
//

import Foundation
import Vapor
import HTTP

class User {
    static let url = "https://graph.facebook.com/v2.6/"
    static let fields = "first_name,last_name,profile_pic"
    
    var fbId:String!
    var firstName:String?
    var lastName:String?
    var picUrl:String?
    
    init(){
        
    }
    
    static func get(id:String) -> User? {
        let user = User()
        user.fbId = id
        
        let URL = User.url + user.fbId
        
        if let accessToken = drop.config["keys", "fb", "access"]?.string {
            
            let params = [
                "fields" : User.fields,
                "access_token" : accessToken
            ]
            
            let headers = [
                HeaderKey("Content-Type"):"application/json"
            ]
            
            do {
                let resp = try drop.client.get(URL, headers: headers, query: params)
                print(resp)
                if resp.status == .ok {
                    print("Status OK")
                    if let bytes = resp.body.bytes {
                        let respData = try JSON(bytes: bytes)
                        if let first_name = respData["first_name"]?.string {
                            user.firstName = first_name
                        }
                        if let last_name = respData["last_name"]?.string {
                            user.lastName = last_name
                        }
                        if let profile_pic = respData["profile_pic"]?.string {
                            user.picUrl = profile_pic
                        }
                        
                        return user
                    }else{
                        return nil
                    }
                }else{
                    print("Status failed")
                    return nil
                }
            }catch let e {
                print("Error \(e)")
                return nil
            }
        }else{
            print("Missing validation")
            return nil
        }
    }
}

enum UserRef : String {
    case fb_id = "@[fb_id]"
    case first_name = "@[first_name]"
    case last_name = "@[last_name]"
    case pic_url = "@[pic_url]"
    
    static func replace(user:User, text:String) -> String {
        var txt = text
        txt = text.replacingOccurrences(of: UserRef.fb_id.rawValue, with: user.fbId)
        if txt.contains(UserRef.first_name.rawValue) {
            if let firstName = user.firstName {
                txt = text.replacingOccurrences(of: UserRef.first_name.rawValue, with: firstName)
            }else{
                txt = text.replacingOccurrences(of: UserRef.first_name.rawValue, with: "Fulano")
            }
        }
        if txt.contains(UserRef.last_name.rawValue) {
            if let lastName = user.lastName {
                txt = text.replacingOccurrences(of: UserRef.last_name.rawValue, with: lastName)
            }else{
                txt = text.replacingOccurrences(of: UserRef.last_name.rawValue, with: "Silva")
            }
        }
        if txt.contains(UserRef.pic_url.rawValue) {
            if let pic_url = user.picUrl {
                txt = text.replacingOccurrences(of: UserRef.pic_url.rawValue, with: pic_url)
            }else{
                txt = text.replacingOccurrences(of: UserRef.pic_url.rawValue, with: "?")
            }
        }
        
        return txt
    }
}
