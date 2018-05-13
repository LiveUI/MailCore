//
//  Message+SendGrid.swift
//  MailCore
//
//  Created by Ondrej Rafaj on 11/04/2018.
//

import Foundation
import Vapor
import SendGrid


extension Mailer.Message {
    
    /// Message as a SendGrid content
    func asSendGridContent() -> SendGridEmail {
        var content = [
            [
                "type": "text/plain",
                "value": text
            ]
        ]
        if let html = html {
            content.append(
                [
                    "type": "text/html",
                    "value": html
                ]
            )
        }
        let message = SendGridEmail(from: EmailAddress(email: from), replyTo: EmailAddress(email: to), subject: subject, content: content)
        return message
    }
    
}
