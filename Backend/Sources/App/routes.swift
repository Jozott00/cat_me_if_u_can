import Vapor

func routes(_ app: Application) throws {
    app.get { _ in
        "It works!"
    }

    app.get("hello") { _ -> String in
        "Hello, world!"
    }

    let commController = CommunicationController()
    // test github branch lock
    app.webSocket("ws", onUpgrade: { _, ws in
        commController.newConnection(ws: ws)
    })
}
