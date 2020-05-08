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
    func send(_ messages: [Mailer.Message], on req: Request) throws -> Future<[(Mail, Mailer.Result)]>
}


/// Mailer class
public class Mailer: MailerService {
    
    /// Basic message
    public struct Message {
        public let from: String
        public let to: String
        public let cc: [String]?
        public let bcc: [String]?
        public let subject: String
        public let text: String
        public let html: String?
        
        /// Message init
        public init(from: String, to: String, cc: [String]? = nil, bcc: [String]? = nil, subject: String, text: String, html: String? = nil) {
            self.from = from
            self.to = to
            self.cc = cc
            self.bcc = bcc
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
        case mailgun(key: String, domain: String, region: Mailgun.Region)
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
        case .mailgun(let key, let domain, let region):
            services.register(Mailgun(apiKey: key, domain: domain, region: region), as: Mailgun.self)
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
        case .mailgun:
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
    
    /// Send multiple messages using a provider defined in `config: Config`
    public func send(_ messages: [Message], on req: Request) throws -> Future<[(Mail, Mailer.Result)]> {
        switch config {
        case .mailgun:
            throw Abort(.notImplemented, reason: "Sending mass email using Mailgun is not currently supported.")
        case .sendGrid(_):
            throw Abort(.notImplemented, reason: "Sending mass email using SendGrid is not currently supported.")
        case .smtp(let smtp):
            let promise = req.eventLoop.newPromise([(Mail, Mailer.Result)].self)
            smtp.send(messages.map { $0.asSmtpMail() }, progress: nil) { mails, errors in
                let errors = errors.map { ($0.0, Mailer.Result.failure(error: $0.1)) }
                let successes = mails.map { ($0, Mailer.Result.success) }
                promise.succeed(result: errors + successes)
            }
            return promise.futureResult
        default:
            throw Abort(.serviceUnavailable, reason: "Mails could not be sent: you need to configure your mail service.")
        }
    }
}
