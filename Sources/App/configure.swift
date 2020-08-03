import FluentMySQL
import Vapor
import Leaf
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentMySQLProvider())
    try services.register(AuthenticationProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    let dicConfig = DirectoryConfig.detect()
    services.register(dicConfig)
//================================================================
    
    // Configure a MySQL database
    
    var databases = DatabasesConfig()
    /// ### https://stackoverflow.com/questions/54304666/mysql-vapor-3-unrecognized-basic-packet-full-auth-not-supported
    let mySQLDatabaseConfig = MySQLDatabaseConfig(
        hostname: "localhost",
        username: "anil",
        password: "kotur",
        database: "ournotes",
        transport: MySQLTransportConfig.unverifiedTLS
    )
    
    let mysqlDB = MySQLDatabase(config: mySQLDatabaseConfig)
    databases.add(database: mysqlDB, as: .mysql)
    services.register(databases)
//================================================================
    // Register the configured SQLite database to the database config.
    

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Note.self, database: .mysql)
    migrations.add(model: User.self, database: .mysql)
    migrations.add(model: Token.self, database: .mysql)
    services.register(migrations)
    User.PublicUser.defaultDatabase = .mysql
}
