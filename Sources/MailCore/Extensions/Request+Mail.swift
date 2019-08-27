import Vapor


public struct MailProperty {
    
    /// Container reference
    let c: Container
    
    /// Send email
    public func send(_ message: Mailer.Message) throws -> EventLoopFuture<Mailer.Result> {
        let mailer = try c.make(MailerService.self)
        return try mailer.send(message, on: c)
    }
    
    /// Send email
    public func send(from: String, to: String, subject: String, text: String) throws -> EventLoopFuture<Mailer.Result> {
        return try send(Mailer.Message(from: from, to: to, subject: subject, text: text))
    }
    
}


extension Container {
    
    /// Mail functionality accessor for container
    public var mail: MailProperty {
        return MailProperty(c: self)
    }
    
}
