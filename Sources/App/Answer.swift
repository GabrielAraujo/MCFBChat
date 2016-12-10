//
//  Answer.swift
//  MCFBChat
//
//  Created by Gabriel Araujo on 02/12/16.
//
//

import Foundation

class Answer {
    
    static func process(objects:[Any], message:String) -> String? {
        var txt:String?
        
        let lang = self.identifyLanguage(message: message)
        guard lang != "none" else {
            
            return nil
        }
        
        if let answers = drop.config[lang,"answers"]?.array {
            for answer in answers {
                print(answer)
                if let type = answer.object?["type"]?.string {
                    if type == "greeting" {
                        if let responses = answer.object?["responses"]?.array {
                            if let value = responses[0].string {
                                txt = value
                            }
                        }
                    }
                }
            }
        }
        
        guard txt != nil else {
            return nil
        }
        
        return Answer.makeReferences(objects: objects, text: txt!)
    }
    
    fileprivate static func identifyLanguage(message:String) -> String {
        var txt:String = ""
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
