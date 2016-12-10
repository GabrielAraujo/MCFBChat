//
//  Bot.swift
//  MCFBChat
//
//  Created by Gabriel Araujo on 10/12/16.
//
//

import Foundation
import Vapor

class Bot {
    var referAs:String?
    var firstName:String?
    
    init(referAs:String, firstName:String) {
        self.referAs = referAs
        self.firstName = firstName
    }
}

enum BotRef : String {
    case refer_as = "@[BOT.refer_as]"
    case first_name = "@[BOT.first_name]"
    
    static func replace(bot:Bot, text:String) -> String {
        var txt = text
        while txt.contains(BotRef.refer_as.rawValue) || txt.contains(BotRef.first_name.rawValue) {
            if let referAs = bot.referAs {
                txt = txt.replacingOccurrences(of: BotRef.refer_as.rawValue, with: referAs)
            }else{
                txt = txt.replacingOccurrences(of: BotRef.refer_as.rawValue, with: "")
            }
            
            if let firstName = bot.firstName {
                txt = txt.replacingOccurrences(of: BotRef.first_name.rawValue, with: firstName)
            }else{
                txt = txt.replacingOccurrences(of: BotRef.first_name.rawValue, with: "")
            }
        }
        
        return txt
    }
}
