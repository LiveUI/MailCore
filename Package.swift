// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "MailCore",
    products: [
        .library(name: "MailCore", targets: ["MailCore"]),
        .library(name: "MailCoreTestTools", targets: ["MailCoreTestTools"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-alpha.3"),
//        .package(url: "https://github.com/twof/VaporMailgunService.git", from: "1.2.0"),
        //.package(url: "https://github.com/vapor-community/sendgrid-provider.git", from: "3.0.5"),
        .package(url: "https://github.com/IBM-Swift/Swift-SMTP.git", from: "5.1.0"),
        .package(url: "https://github.com/IBM-Swift/LoggerAPI.git", .upToNextMinor(from: "1.8.0"))
    ],
    targets: [
        .target(name: "MailCore", dependencies: [
            "Vapor",
//            "Mailgun",
//            "SendGrid",
            "SwiftSMTP"
            ]
        ),
        .target(name: "MailCoreTestTools", dependencies: [
            "Vapor",
            "MailCore"
            ]
        ),
        .testTarget(name: "MailCoreTests", dependencies: [
            "MailCore",
            "MailCoreTestTools"
            ]
        )
    ]
)
