@testable import MailCore


extension MailProperty {
    
    public var mock: MailerMock {
        let mailer = try! request.make(MailerService.self)
        return mailer as! MailerMock
    }
    
}
