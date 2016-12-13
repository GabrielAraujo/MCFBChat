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
    
    static let bot = Bot(referAs:"a", firstName:"Mayara")
    
    static func process(sender:User, message:String) throws -> Status {
        let lang = try self.identifyLanguage(sender: sender, message: message)
        guard lang != "none" else {
             return .ok
        }
        
        let pasts = try Past.all()
        let past = pasts.filter({ $0.userId == sender.fbId }).first
        
        if let answers = drop.config[lang,"answers"]?.array {
            for answer in answers {
                let identifier = answer.object?["identifier"]?.string
                if let type = answer.object?["type"]?.string {
                    //Greeting message
                    switch type {
                    case "greeting":
                        if let texts = answer.object?["texts"]?.array {
                            for text in texts {
                                if let t = text.string {
                                    if message.lowercased().getLevenshtein(t) < 3 {
                                        if let actions = answer.object?["actions"]?.object {
                                            try self.proccessActions(sender: sender, identifier: identifier!, data: actions, past: past)
                                        }else{
                                            //No action defined
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
                                            try self.proccessActions(sender: sender, identifier: identifier!, data: actions, past: past)
                                        }else{
                                            //No action defined
                                        }
                                        return .ok
                                    }
                                }
                            }
                        }
                    case "afirmation":
                        if let texts = answer.object?["texts"]?.array {
                            for text in texts {
                                if let t = text.string {
                                    if message.lowercased().getLevenshtein(t) < 3 {
                                        if let previous = answer.object?["previous"]?.string {
                                            if previous != past?.previous {
                                                break
                                            }
                                        }
                                        if let actions = answer.object?["actions"]?.object {
                                            try self.proccessActions(sender: sender, identifier: identifier!, data: actions, past: past)
                                        }else{
                                            //No action defined
                                        }
                                        return .ok
                                    }
                                }
                            }
                        }
                        break
                    default:
                        if let actions = drop.config[lang, "not_defined", "actions"]?.object {
                            try self.proccessActions(sender: sender, identifier: identifier!, data: actions, past: past)
                        }
                        return .ok
                    }
                }
            }
        }
        
        return .ok
    }
    
    static fileprivate func proccessActions(sender:User, identifier:String, data:[String:Polymorphic], past:Past?) throws  {
        var past = past
        var txt:String?
        if let reply = data["reply"]?.string {
            txt = Answer.makeReferences(objects: [sender, bot], text: reply)
            
            if let text = txt {
                let status = try Message.sendText(to: sender, text: text)
                if status == .ok {
                    past?.previous = identifier
                    try past?.save()
                }
            }
        }
        if let send_image = data["send_image"]?.string {
            let _ = try Message.sendImage(to: sender, imageUrl: send_image)
        }
        if let send_audio = data["send_audio"]?.string {
            let _ = try Message.sendAudio(to: sender, audioUrl: send_audio)
        }
        if let send_file = data["send_file"]?.string {
            let _ = try Message.sendFile(to: sender, fileUrl: send_file)
        }
        if let send_video = data["send_video"]?.string {
            let _ = try Message.sendVideo(to: sender, videoUrl: send_video)
        }
        if let quick_reply = data["quick_reply"]?.object {
            if let text = quick_reply["text"]?.string {
                if let options = quick_reply["options"]?.array {
                    var arrayFBQuickReply:[FBQuickReply] = []
                    var objFBQuickReply:FBQuickReply!
                    for option in options {
                        objFBQuickReply = FBQuickReply()
                        if let type = option.object?["content_type"]?.string {
                            objFBQuickReply.type = FBQuickReplyType(rawValue: type)
                        }
                        if let title = option.object?["title"]?.string {
                            objFBQuickReply.title = title
                        }
                        if let payload = option.object?["payload"]?.string {
                            objFBQuickReply.payload = payload
                        }
                        if let imageUrl = option.object?["image_url"]?.string {
                            objFBQuickReply.imageUrl = imageUrl
                        }
                        arrayFBQuickReply.append(objFBQuickReply)
                    }
                    let status = try Message.sendQuickReply(to: sender, text: text, quickReplys: arrayFBQuickReply)
                    if status == .ok {
                        past?.previous = identifier
                        try past?.save()
                    }
                }
            }
        }
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
