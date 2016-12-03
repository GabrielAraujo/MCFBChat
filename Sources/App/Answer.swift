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
    
    static func process(sender:String, message:String) -> String {
        if self.isGreeting(message: message) {
            return "Olá {{user_first_name}}, tudo bem com você?"
        }else{
            return "Desculpe, não consegui te entender! =("
        }
    }
    
    fileprivate static func isGreeting(message:String) -> Bool {
        return self.greetings.contains(message.lowercased())
    }
    
}
