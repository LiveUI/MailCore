![Vapor 3 test tools](https://github.com/LiveUI/MailCore/raw/master/Other/logo.png)

##

[![Slack](https://img.shields.io/badge/join-slack-745EAF.svg?style=flat)](http://bit.ly/2B0dEyt)
[![Jenkins](https://ci.liveui.io/job/LiveUI/job/MailCore/job/master/badge/icon)](https://ci.liveui.io/job/LiveUI/job/MailCore/)
[![Platforms](https://img.shields.io/badge/platforms-macOS%2010.13%20|%20Ubuntu%2016.04%20LTS-ff0000.svg?style=flat)](https://github.com/LiveUI/Boost)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![Swift 4](https://img.shields.io/badge/swift-4.0-orange.svg?style=flat)](http://swift.org)
[![Vapor 3](https://img.shields.io/badge/vapor-3.0-blue.svg?style=flat)](https://vapor.codes)


Mailing wrapper for multiple mailing services like MailGun, SendGrig or SMTP

## Features

- [x] MailGun
- [x] SendGrid
- [ ] SMTP

## Install

Just add following line package to your `Package.swift` file.

```swift
.package(url: "https://github.com/LiveUI/MailCore.git", .branch("master"))
```

## Use

Usage is really simple. First register the service in your apps `configure` method:

```swift
// Mailgun
let config = Mailer.Config.mailgun(key: "{mailGunApi}", domain: "{mailGunDomain}")

// or SendGrid
let config = Mailer.Config.sendGrid(key: "{sendGridApiKey}")

// Register and configure the service
Mailer(config: config, registerOn: &services)
```

`Mailer.Config` is an `enum` and you can choose from any integrated services to be used

And send an email:

```swift
let mail = Mailer.Message(from: "admin@liveui.io", to: "bobby.ewing@southfork.com", subject: "Oil spill", text: "Oooops I did it again", html: "<p>Oooops I did it again</p>")
return try req.mail.send(mail).flatMap(to: Response.self) { mailResult in
    print(mailResult)
    // ... Return your response for example
}
```

## Support

Join our [Slack](http://bit.ly/2B0dEyt), channel <b>#help-boost</b> to ... well, get help :) 

## Boost AppStore

Core package for <b>[Boost](http://www.boostappstore.com)</b>, a completely open source enterprise AppStore written in Swift!
- Website: http://www.boostappstore.com
- Github: https://github.com/LiveUI/Boost

## Other core packages

* [BoostCore](https://github.com/LiveUI/BoostCore/) - AppStore core module
* [ApiCore](https://github.com/LiveUI/ApiCore/) - Base user & team management including forgotten passwords, etc ...
* [DBCore](https://github.com/LiveUI/DbCore/) - Set of tools for work with PostgreSQL database
* [VaporTestTools](https://github.com/LiveUI/VaporTestTools) - Test tools and helpers for Vapor 3

## Code contributions

We love PR’s, we can’t get enough of them ... so if you have an interesting improvement, bug-fix or a new feature please don’t hesitate to get in touch. If you are not sure about something before you start the development you can always contact our dev and product team through our Slack.

## Author

Ondrej Rafaj (@rafiki270 on [Github](https://github.com/rafiki270), [Twitter](https://twitter.com/rafiki270), [LiveUI Slack](http://bit.ly/2B0dEyt) and [Vapor Slack](https://vapor.team/))

## License

MIT license, please see LICENSE file for more details.

