import Application
import HeliumLogger
import LoggerAPI

HeliumLogger.use()

do {
    let app = try App()
    try app.run()
} catch let error {
    Log.error(error.localizedDescription)
}
