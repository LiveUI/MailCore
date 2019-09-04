![LiveUI MailCore](https://github.com/LiveUI/MailCore/raw/master/Other/logo.png)

##

[![Slack](https://img.shields.io/badge/join-slack-745EAF.svg?style=flat)](http://bit.ly/2B0dEyt)
[![Jenkins](https://ci.liveui.io/job/LiveUI/job/MailCore/job/master/badge/icon)](https://ci.liveui.io/job/LiveUI/job/MailCore/)
[![Platforms](https://img.shields.io/badge/platforms-macOS%2010.13%20|%20Ubuntu%2016.04%20LTS-ff0000.svg?style=flat)](https://github.com/LiveUI/Boost)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![Swift 4](https://img.shields.io/badge/swift-4.0-orange.svg?style=flat)](http://swift.org)
[![Vapor 3](https://img.shields.io/badge/vapor-3.0-blue.svg?style=flat)](https://vapor.codes)


Mailing wrapper for multiple mailing services like Mailgun, SendGrid or SMTP

# Features

- [x] Mailgun
- [x] SendGrid
- [x] SMTP
- [ ] Attachments
- [ ] Multiple emails sent at the same time
- [x] Multiple recipint, CC & BCC fields

# Install

Just add following line package to your `Package.swift` file.

```swift
.package(url: "https://github.com/LiveUI/MailCore.git", .branch("master"))
```

# Usage

Usage is really simple mkey!

## 1/3) Configure

First create your client configuration:

#### Mailgun

```swift
let config = Mailer.Config.mailgun(key: "{mailgunApi}", domain: "{mailgunDomain}", region: "{mailgunRegion}")
```

#### SendGrid

```swift
let config = Mailer.Config.sendGrid(key: "{sendGridApiKey}")
```

#### SMTP

Use the `SMTP` struct as a handle to your SMTP server:

```swift
let smtp = SMTP(hostname: "smtp.gmail.com",     // SMTP server address
                   email: "user@gmail.com",     // username to login
                password: "password")           // password to login
                
let config = Mailer.Config.smtp(smtp)
```

#### SMTP using TLS

All parameters of `SMTP` struct:

```swift
let smtp = SMTP(hostname: String,
                   email: String,
                password: String,
                    port: Int32 = 465,
                  useTLS: Bool = true,
        tlsConfiguration: TLSConfiguration? = nil,
             authMethods: [AuthMethod] = [],
             accessToken: String? = nil,
              domainName: String = "localhost",
                 timeout: UInt = 10)
                 
let config = Mailer.Config.smtp(smtp)
```

## 2/3) Register service

Register and configure the service in your apps `configure` method.

```swift
Mailer(config: config, registerOn: &services)
```

`Mailer.Config` is an `enum` and you can choose from any integrated services to be used

## 3/3) Send an email

```swift
let mail = Mailer.Message(from: "admin@liveui.io", to: "bobby.ewing@southfork.com", subject: "Oil spill", text: "Oooops I did it again", html: "<p>Oooops I did it again</p>")
return try req.mail.send(mail).flatMap(to: Response.self) { mailResult in
    print(mailResult)
    // ... Return your response for example
}
```

# Testing

Mailcore provides a  `MailCoreTestTools` framework which you can import into your tests to get `MailerMock`.

To register, and potentially override any existing "real" Mailer service, just initialize `MailerMock` with your services.

```swift
// Register
MailerMock(services: &services)

// Retrieve in your tests
let mailer = try! req.make(MailerService.self) as! MailerMock
```

`MailerMock` will store the last used result as well as the received message and request. Structure of the moct can be seen below:

```swift
public class MailerMock: MailerService {

    public var result: Mailer.Result = .success
    public var receivedMessage: Mailer.Message?
    public var receivedRequest: Request?

    // MARK: Initialization

    @discardableResult public init(services: inout Services) {
        services.remove(type: Mailer.self)
        services.register(self, as: MailerService.self)
    }

    // MARK: Public interface

    public func send(_ message: Mailer.Message, on req: Request) throws -> Future<Mailer.Result> {
        receivedMessage = message
        receivedRequest = req
        return req.eventLoop.newSucceededFuture(result: result)
    }

    public func clear() {
        result = .success
        receivedMessage = nil
        receivedRequest = nil
    }

}
```

# Support

Join our [Slack](http://bit.ly/2B0dEyt), channel <b>#help-boost</b> to ... well, get help :) 

# Enterprise AppStore

Core package for <b>[Einstore](http://www.einstore.io)</b>, a completely open source enterprise AppStore written in Swift!
- Website: http://www.einstore.io
- Github: https://github.com/Einstore/Einstore

# Other core packages

* [EinstoreCore](https://github.com/Einstore/EinstoreCore/) - AppStore core module
* [ApiCore](https://github.com/LiveUI/ApiCore/) - Base user & team management including forgotten passwords, etc ...

# Implemented thirdparty providers

* <b>Mailgun</b> - https://github.com/twof/VaporMailgunService
* <b>SendGrig</b> - https://github.com/vapor-community/sendgrid-provider
* <b>SMTP</b> - https://github.com/IBM-Swift/Swift-SMTP

# Code contributions

We love PR’s, we can’t get enough of them ... so if you have an interesting improvement, bug-fix or a new feature please don’t hesitate to get in touch. If you are not sure about something before you start the development you can always contact our dev and product team through our Slack.

# Author

Ondrej Rafaj (@rafiki270 on [Github](https://github.com/rafiki270), [Twitter](https://twitter.com/rafiki270), [LiveUI Slack](http://bit.ly/2B0dEyt) and [Vapor Slack](https://vapor.team/))

# License

MIT license, please see LICENSE file for more details.

