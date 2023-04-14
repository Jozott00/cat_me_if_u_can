import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // configure game controller
    let gameControler = GameController()

    // configure network manager
    let networkManager = NetworkManager()
    networkManager.delegate = gameControler
    networkManager.configureRoutes(routes: app.routes)

    app.logger.info("Configuartion done!")
}
