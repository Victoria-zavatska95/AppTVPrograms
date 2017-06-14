print("Hello, world!")
let package = Package(
    name: "TestAppTVPrograms",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/rymcol/SwiftCron.git", majorVersion: 0)
    ]
)
