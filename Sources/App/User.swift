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
    case fb_id = "@[USER.fb_id]"
    case first_name = "@[USER.first_name]"
    case last_name = "@[USER.last_name]"
    case pic_url = "@[USER.pic_url]"
    
    static func replace(user:User, text:String) -> String {
        var txt = text
        while txt.contains(UserRef.fb_id.rawValue) || txt.contains(UserRef.first_name.rawValue) || txt.contains(UserRef.last_name.rawValue) || txt.contains(UserRef.pic_url.rawValue) {
            txt = txt.replacingOccurrences(of: UserRef.fb_id.rawValue, with: user.fbId)
            if let firstName = user.firstName {
                txt = txt.replacingOccurrences(of: UserRef.first_name.rawValue, with: firstName)
            }else{
                txt = txt.replacingOccurrences(of: UserRef.first_name.rawValue, with: "")
            }
            if let lastName = user.lastName {
                txt = txt.replacingOccurrences(of: UserRef.last_name.rawValue, with: lastName)
            }else{
                txt = txt.replacingOccurrences(of: UserRef.last_name.rawValue, with: "")
            }
            if let pic_url = user.picUrl {
                txt = txt.replacingOccurrences(of: UserRef.pic_url.rawValue, with: pic_url)
            }else{
                txt = txt.replacingOccurrences(of: UserRef.pic_url.rawValue, with: "")
            }
        }
        
        return txt
    }
}
