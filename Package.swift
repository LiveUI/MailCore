// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "MailCore",
    products: [
        .library(name: "MailCore", targets: ["MailCore"]),
        .library(name: "MailCoreTestTools", targets: ["MailCoreTestTools"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc.2"),
        .package(url: "https://github.com/twof/VaporMailgunService.git", from: "1.0.0"),
        .package(url: "https://github.com/rafiki270/sendgrid-provider.git", from: "3.0.3"),
        .package(url: "https://github.com/IBM-Swift/Swift-SMTP.git", from: "4.0.0"),
        .package(url: "https://github.com/LiveUI/VaporTestTools.git", .branch("master"))
    ],
    targets: [
        .target(name: "MailCore", dependencies: [
            "Vapor",
            "Mailgun",
            "SendGrid",
            "SwiftSMTP"
            ]
        ),
        .target(name: "MailCoreTestTools", dependencies: [
            "Vapor",
            "VaporTestTools",
            "MailCore"
            ]
        ),
        .testTarget(name: "MailCoreTests", dependencies: [
            "MailCore",
            "MailCoreTestTools",
            "VaporTestTools"
            ]
        )
    ]
)
