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
        
        if cc != nil || bcc != nil {
            print("SendGrid client doesn't yet support CC or BCC")
        }

        let message = SendGridEmail(
            personalizations: [Personalization(to: [EmailAddress(email: to)])],
            from: EmailAddress(email: from),
            subject: subject,
            content: content)

        return message
    }
    
}
