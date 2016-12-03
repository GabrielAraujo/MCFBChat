//
//  Answer.swift
//  MCFBChat
//
//  Created by Gabriel Araujo on 02/12/16.
//
//

import Foundation

class Answer {
    
    static let greetings = [
        "olá","ola","oi","eai"
    ]
    
    static func process(sender:User, message:String) -> String {
        var txt:String
        if self.isGreeting(message: message) {
            txt = "Olá \(UserRef.first_name.rawValue), tudo bem com você?"
        }else{
            txt = "Desculpe \(UserRef.first_name.rawValue), não consegui te entender! =("
        }
        return Answer.makeReferences(objects: [sender], text: txt)
    }
    
    fileprivate static func isGreeting(message:String) -> Bool {
        return self.greetings.contains(message.lowercased())
    }
    
    fileprivate static func makeReferences(objects:[Any], text:String) -> String {
        var txt = text
        for obj in objects {
            if obj is User {
                txt = UserRef.replace(user: obj as! User, text: txt)
            }
        }
        return txt
    }
}
