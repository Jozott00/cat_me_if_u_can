import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // server configs
    app.http.server.configuration.hostname = "0.0.0.0" 

    // configure network manager
    let networkManager = NetworkManager()
    networkManager.configureRoutes(routes: app.routes)

    // configure game controller
    let gameController = GameController(networkManager: networkManager)

    Task {
        await gameController.startGame()
    }

    app.logger.info("Configuartion done!")
}
