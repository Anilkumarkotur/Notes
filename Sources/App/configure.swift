import FluentPostgreSQL
import Vapor
import Leaf
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())
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
    
    var databases = DatabasesConfig()
    
    var postgreSQLDatabase: PostgreSQLDatabase
    
    if env.isRelease {
        guard let dbURL = Environment.get("DATABASE_URL"), let prodConfig = PostgreSQLDatabaseConfig(url: dbURL) else {
            print("Unable to fetch the database url")
            return
        }        
        postgreSQLDatabase = PostgreSQLDatabase(config: prodConfig)
    } else {
        let postgresDbConfig = PostgreSQLDatabaseConfig(hostname: "localhost", username: "anilkumarkotur", database: "noteappIntegration")
        postgreSQLDatabase = PostgreSQLDatabase(config: postgresDbConfig)
    }
    
    databases.add(database: postgreSQLDatabase, as: .psql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Note.self, database: .psql)
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Token.self, database: .psql)
    services.register(migrations)
    User.PublicUser.defaultDatabase = .psql
}
