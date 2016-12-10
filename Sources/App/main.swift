import Vapor
import HTTP

let drop = Droplet()

drop.get("webhook") { req in
    //If does not work try with req.parameters
    if req.query?["hub.mode"]?.string == "subscribe" {
        if let challange = req.query?["hub.challenge"] {
            if let verifyToken = drop.config["keys", "fb", "validation"]?.string {
                if req.query?["hub.verify_token"]?.string == verifyToken {
                    return req.query!["hub.challenge"]!.string!
                }else{
                    return Response(status: .forbidden, body: "Verification token mismatch")
                }
            }else{
                return Response(status: .forbidden, body: "Missing verification code")
            }
        }else{
            return Response(status: .badRequest, body: "Not challenge")
        }
    }
    return "Hello FB Chat App!"
}

drop.post("webhook") { req in
    print(req)
    if let json = req.json {
        print(json)
        if json["object"]?.string == "page" {
            for entry in json["entry"]!.array! {
                for msgEvent in entry.object!["messaging"]!.array! {
                    if let _ = msgEvent.object?["message"] {
                        let senderId = msgEvent.object?["sender"]?.object?["id"]?.string //the facebook ID of the person sending you the message
                        let recipientId = msgEvent.object?["recipient"]?.object?["id"]?.string //the recipient's ID, which should be your page's facebook ID
                        let text = msgEvent.object?["message"]?.object?["text"]?.string //the message's text
                        
                        do {
                            let sender = User.get(id: senderId!)
                            let bot = Bot(referAs:"a", firstName:"Mayara")
                            
                            if sender != nil {
                                
                                guard let text = Answer.process(objects:[sender!, bot], message:text!) else {
                                    return Response(status: .ok)
                                }
                                
                                let status = try Message.sendText(to: sender!, text: text)
                                
                                return Response(status: status)
                            }else{
                                return Response(status: .badRequest)
                            }
                        }catch let e {
                            return Response(status: .badRequest, body: "Error sendind message")
                        }
                    }else if let _ = msgEvent.object?["delivery"] {
                        return "ok"
                    }else if let _ = msgEvent.object?["optin"] {
                        return "ok"
                    }else if let _ = msgEvent.object?["postback"] {
                        let senderId = msgEvent.object?["sender"]?.object?["id"]?.string
                        let recipientId = msgEvent.object?["recipient"]?.object?["id"]?.string
                        let timeOfPostback = msgEvent.object?["timestamp"]?.string
                        
                        let payload = msgEvent.object?["postback"]?.object?["payload"]?.string
                        
                        print("Received postback for user \(senderId) and page \(recipientId) with payload \(payload) at \(timeOfPostback)")
                        
                        let sender = User.get(id: senderId!)
                        
                        return try Response(status: Message.sendText(to: sender!, text: "Postback Received!"))
                    }
                }
            }
        }
    }else {
        return Response(status: .badRequest, body: "Missing JSON")
    }
    return Response(status: .badRequest, body: "Some error")
}

drop.run()
