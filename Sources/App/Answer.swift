//
//  Answer.swift
//  MCFBChat
//
//  Created by Gabriel Araujo on 02/12/16.
//
//

import Foundation
import Vapor
import HTTP

class Answer {
    
    static func process(sender:User, message:String) throws -> Status {
        var txt:String?
        
        let lang = try self.identifyLanguage(sender: sender, message: message)
        guard lang != "none" else {
             return .ok
        }
        
        let pasts = try Past.all()
        var past = pasts.filter({ $0.userId == sender.fbId }).first
        
        let bot = Bot(referAs:"a", firstName:"Mayara")
        
        if let answers = drop.config[lang,"answers"]?.array {
            for answer in answers {
                print(answer)
                if let type = answer.object?["type"]?.string {
                    //Greeting message
                    switch type {
                    case "greeting":
                        if let texts = answer.object?["texts"]?.array {
                            for text in texts {
                                if let t = text.string {
                                    if message.lowercased().getLevenshtein(t) < 3 {
                                        if let response = answer.object?["response"]?.string {
                                            
                                            txt = Answer.makeReferences(objects: [sender, bot], text: response)
                                            
                                            if let text = txt {
                                                let status = try Message.sendText(to: sender, text: text)
                                                if status == .ok {
                                                    //Store response
                                                    if let identifier = answer.object?["identifier"]?.string {
                                                        past?.previous = identifier
                                                        try past?.save()
                                                    }
                                                }
                                            }
                                        }
                                        return .ok
                                    }
                                }
                            }
                        }
                    case "question":
                        if let texts = answer.object?["texts"]?.array {
                            for text in texts {
                                if let t = text.string {
                                    if message.lowercased().getLevenshtein(t) < 6 {
                                        if let previous = answer.object?["previous"]?.string {
                                            if previous != past?.previous {
                                                break
                                            }
                                        }
                                        if let actions = answer.object?["actions"]?.object {
                                            if let reply = actions["reply"]?.string {
                                                txt = Answer.makeReferences(objects: [sender, bot], text: reply)
                                                
                                                if let text = txt {
                                                    let status = try Message.sendText(to: sender, text: text)
                                                    if status == .ok {
                                                        if status == .ok {
                                                            //Store response
                                                            if let identifier = answer.object?["identifier"]?.string {
                                                                past?.previous = identifier
                                                                try past?.save()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            if let send_image = actions["send_image"]?.string {
                                                let _ = try Message.sendImage(to: sender, imageUrl: send_image)
                                            }
                                        }else{
                                            //No action defined
                                        }
                                        return .ok
                                    }
                                }
                            }
                        }
                    default:
                        if let responses = drop.config[lang, "not_defined", "responses"]?.array {
                            if let value = responses[0].string {
                                txt = Answer.makeReferences(objects: [sender, bot], text: value)
                                
                                if let text = txt {
                                    let status = try Message.sendText(to: sender, text: text)
                                    if status == .ok {
                                        //Store response
                                        if let identifier = answer.object?["identifier"]?.string {
                                            past?.previous = identifier
                                            try past?.save()
                                        }
                                    }
                                }
                            }
                        }
                        return .ok
                    }
                }
            }
        }
        
        return .ok
    }
    
    fileprivate static func identifyLanguage(sender:User, message:String) throws -> String {
        var txt:String = ""
        
        let pasts = try Past.all()
        let past = pasts.filter({ $0.userId == sender.fbId }).first
        if past != nil {
            if let lang = past?.language {
                return lang
            }
        }
        
        if let languages = drop.config["greetings", "languages"]?.array {
            for lang in languages {
                if let greetings = lang.object?["greetings"]?.array {
                    for greet in greetings {
                        if let valueGreet = greet.string {
                            if message.lowercased().getLevenshtein(valueGreet) < 2 {
                                if let language = lang.object?["lang"]?.string {
                                    txt = language
                                }else{
                                    break
                                }
                            }
                        }else{
                            break
                        }
                    }
                }else{
                    txt = "none"
                }
            }
        }else{
            txt = "none"
        }
        
        if txt == "" {
            return "none"
        }
        
        var newPast = Past(language: txt, userId: sender.fbId)
        try newPast.save()
        
        return txt
    }
    
    fileprivate static func makeReferences(objects:[Any], text:String) -> String {
        var txt = text
        for obj in objects {
            if obj is User {
                txt = UserRef.replace(user: obj as! User, text: txt)
            }
            if obj is Bot {
                txt = BotRef.replace(bot: obj as! Bot, text: txt)
            }
        }
        return txt
    }
}
