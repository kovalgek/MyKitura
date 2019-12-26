import Kitura
import Dispatch

public class App
{
    let router = Router()
    let workerQueue = DispatchQueue(label: "worker")

    
    public init() throws
    {
        
    }
    
    func postInit() throws
    {
        initializeCodableRoutes(app: self)
    }
    
    public func run() throws
    {
        try postInit()
        Kitura.addHTTPServer(onPort: 8080, with: router)
        Kitura.run()
    }
    
    func execute(_ block: (() -> Void)) {
        workerQueue.sync {
            block()
        }
    }
}
