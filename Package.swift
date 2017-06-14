import PackageDescription

let package = Package(
    name: "TestAppTVPrograms",
    dependencies: [
    .Package(url: "https://github.com/rymcol/SwiftCron.git", majorVersion: 0)
    ]
)
