//
//  Boost.swift
//  MailCore
//
//  Created by Ondrej Rafaj on 19/3/2018.
//

import Foundation
import Vapor
import Mailgun
import SendGrid
@_exported import SwiftSMTP


/// Emailing service
public protocol MailerService: Service {
    func send(_ message: Mailer.Message, on req: Request) throws -> Future<Mailer.Result>
}


/// Mailer class
public class Mailer: MailerService {
    
    /// Basic message
    public struct Message {
        public let from: String
        public let to: String
        public let subject: String
        public let text: String
        public let html: String?
        
        /// Message init
        public init(from: String, to: String, subject: String, text: String, html: String? = nil) {
            self.from = from
            self.to = to
            self.subject = subject
            self.text = text
            self.html = html
        }
    }
    
    /// Result returned by the services
    public enum Result {
        case serviceNotConfigured
        case success
        case failure(error: Error)
    }
    
    /// Service configuration
    public enum Config {
        case none
        case mailgun(key: String, domain: String)
        case sendGrid(key: String)
        case smtp(SMTP)
    }
    
    /// Current email service configuration
    var config: Config
    
    
    // MARK: Initialization
    
    /// Mailer initialization. MailerService get's registered to the services at this point, there is no need to do that manually!
    @discardableResult public init(config: Config, registerOn services: inout Services) throws {
        self.config = config
        
        switch config {
        case .mailgun(let key, let domain):
            services.register(Mailgun(apiKey: key, domain: domain), as: Mailgun.self)
        case .sendGrid(key: let key):
            let config = SendGridConfig(apiKey: key)
            services.register(config)
            try services.register(SendGridProvider())
        default:
            break
        }
        
        services.register(self, as: MailerService.self)
    }
    
    // MARK: Public interface
    
    /// Send a message using a provider defined in `config: Config`
    public func send(_ message: Message, on req: Request) throws -> Future<Mailer.Result> {
        switch config {
        case .mailgun(_, _):
            let mailgunClient = try req.make(Mailgun.self)
            return try mailgunClient.send(message.asMailgunContent(), on: req).map(to: Mailer.Result.self) { _ in
                return Mailer.Result.success
                }.catchMap({ error in
                    return Mailer.Result.failure(error: error)
                }
            )
        case .sendGrid(_):
            let email = message.asSendGridContent()
            let sendGridClient = try req.make(SendGridClient.self)
            return try sendGridClient.send([email], on: req.eventLoop).map(to: Mailer.Result.self) { _ in
                return Mailer.Result.success
                }.catchMap({ error in
                    return Mailer.Result.failure(error: error)
                }
            )
        case .smtp(let smtp):
            let promise = req.eventLoop.newPromise(Mailer.Result.self)
            smtp.send(message.asSmtpMail()) { error in
                if let error = error {
                    promise.succeed(result: Mailer.Result.failure(error: error))
                } else {
                    promise.succeed(result: Mailer.Result.success)
                }
            }
            return promise.futureResult
        default:
            return req.eventLoop.newSucceededFuture(result: Mailer.Result.serviceNotConfigured)
        }
    }
    
}
