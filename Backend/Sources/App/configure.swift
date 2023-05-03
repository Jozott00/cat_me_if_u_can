import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // configure network manager
    let networkManager = NetworkManager()
    networkManager.configureRoutes(routes: app.routes)

    // configure game controller
    let gameController = GameController(networkManager: networkManager, tickIntervalMS: Constants.TICK_INTERVAL_MS)
    _ = LobbyController(game: gameController, networkManager: networkManager)

    try routes(app)
    app.logger.info("Configuartion done!")
}
