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
        if json["object"]?.string == "page" {
            for entry in json["entry"]!.array! {
                if let msg = entry.object?["message"] {
                    let senderId = entry.object?["sender"]?.object?["id"]?.string //the facebook ID of the person sending you the message
                    let recipientId = entry.object?["recipient"]?.object?["id"]?.string //the recipient's ID, which should be your page's facebook ID
                    let text = msg.object?["text"]?.string //the message's text
                    
                    Message.sendMessage(recipientId: recipientId!, text: "Received!")
                    
                    return "ok"
                }else if let _ = entry.object?["delivery"] {
                    return "ok"
                }else if let _ = entry.object?["optin"] {
                    return "ok"
                }else if let _ = entry.object?["postback"] {
                    return "ok"
                }
            }
        }
    }else {
        return Response(status: .badRequest, body: "Missing JSON")
    }
    return Response(status: .badRequest, body: "Some error")
}

drop.run()
