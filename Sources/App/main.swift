import Vapor
import HTTP

let drop = Droplet()

drop.get("webhook") { req in
    //If does not work try with req.parameters
    if req.query?["hub.mode"]?.string == "subscribe" {
        if let challange = req.query?["hub.challenge"] {
            if let verifyToken = drop.config["key", "FB", "validation"]?.string {
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
    if let json = req.json {
        if json["object"]?.string == "page" {
            for entry in json["entry"]!.array! {
                for msgEvent in entry.object!["messaging"]!.array! {
                    if let _ = msgEvent.object?["message"] {
                        let senderId = msgEvent.object?["sender"]?.object?["id"]?.string //the facebook ID of the person sending you the message
                        let recipientId = msgEvent.object?["recipient"]?.object?["id"]?.string //the recipient's ID, which should be your page's facebook ID
                        let text = msgEvent.object?["message"]?.object?["text"]?.string //the message's text
                        
                        Message.sendMessage(recipientId: recipientId!, text: "Received!")
                        
                        return "ok"
                    }else if let _ = msgEvent.object?["delivery"] {
                        return "ok"
                    }else if let _ = msgEvent.object?["optin"] {
                        return "ok"
                    }else if let _ = msgEvent.object?["postback"] {
                        return "ok"
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