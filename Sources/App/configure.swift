import Vapor
import Leaf
import FluentMySQL

/// Called before your application initializes.
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    let leafProvider = LeafProvider()
    try services.register(leafProvider)
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

    try services.register(FluentMySQLProvider())

    let mysqlConfig = MySQLDatabaseConfig(
      hostname: "127.0.0.1",
      port: 3306,
      username: "root",
      password: "root",
      database: "mycooldb"
    )
    services.register(mysqlConfig)

    var migrations = MigrationConfig()
    migrations.add(model: Acronym.self, database: .mysql)
//    migrations.add(model: User.self, database: .mysql)
    services.register(migrations)
}
