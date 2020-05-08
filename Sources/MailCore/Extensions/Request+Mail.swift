//
//  Request+Mail.swift
//  MailCore
//
//  Created by Ondrej Rafaj on 19/03/2018.
//

import Foundation
import Vapor


public struct MailProperty {
    
    /// Request reference
    let request: Request
    
    /// Send email
    public func send(_ message: Mailer.Message) throws -> EventLoopFuture<Mailer.Result> {
        let mailer = try request.make(MailerService.self)
        return try mailer.send(message, on: request)
    }
    
    /// Send email
    public func send(_ messages: [Mailer.Message]) throws -> EventLoopFuture<[(Mail, Mailer.Result)]> {
        let mailer = try request.make(MailerService.self)
        return try mailer.send(messages, on: request)
    }
    
    /// Send email
    public func send(from: String, to: String, subject: String, text: String) throws -> EventLoopFuture<Mailer.Result> {
        return try send(Mailer.Message(from: from, to: to, subject: subject, text: text))
    }
}

extension Request {
    
    /// Mail functionality accessor for request
    public var mail: MailProperty {
        return MailProperty(request: self)
    }
}
