import Vapor

func routes(_ app: Application) throws {
  // No rest api used right now

  app.get { req in
    return "For websocket connection use /connect"
  }

}
