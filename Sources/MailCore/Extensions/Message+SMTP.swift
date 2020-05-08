//
//  Message+SMTP.swift
//  MailCore
//
//  Created by Ondrej Rafaj on 11/04/2018.
//

import Foundation
import Vapor
import SwiftSMTP


extension Mailer.Message {
    
    /// Message as an SMTP email
    func asSmtpMail() -> Mail {
        let fromUser = Mail.User(email: from)
        
        let toUser = Mail.User(email: to)
        let ccUsers = (cc ?? []).map({ Mail.User(email: $0) })
        let bccUsers = (bcc ?? []).map({ Mail.User(email: $0) })
        
        var attachments: [Attachment] = self.attachments ?? []
        if let html = html {
            attachments.append(Attachment(htmlContent: html))
        }
        
        let mail = Mail(from: fromUser, to: [toUser], cc: ccUsers, bcc: bccUsers, subject: subject, text: text, attachments: attachments)
        return mail
    }
}
