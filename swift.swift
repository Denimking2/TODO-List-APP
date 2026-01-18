import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.todo/native",
                                              binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "addTodo":
                if let args = call.arguments as? [String: Any],
                   let title = args["title"] as? String,
                   let timestamp = args["timestamp"] as? Int64 {
                    // Swift processing
                    let response = "Swift: Todo '\(title)' saved at \(timestamp)"
                    result(response)
                } else {
                    result(FlutterError(code: "INVALID_ARGS",
                                        message: "Invalid arguments",
                                        details: nil))
                }
                
            case "processWithPython":
                // Call Python through system process
                DispatchQueue.global(qos: .background).async {
                    let pythonResult = self?.callPythonScript() ?? "No result"
                    DispatchQueue.main.async {
                        result("Python via Swift: \(pythonResult)")
                    }
                }
                
            case "calculateWithCpp":
                // Call C++ through bridging
                DispatchQueue.global(qos: .background).async {
                    let numbers: [Double] = [1, 2, 3, 4, 5]
                    let cppResult = calculateWithCpp(numbers)
                    DispatchQueue.main.async {
                        result("C++ via Swift: Result = \(cppResult)")
                    }
                }
                
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func callPythonScript() -> String {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/python3")
        task.arguments = ["/path/to/python_script.py"]
        
        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: outputData, encoding: .utf8) ?? "No output"
            return output
        } catch {
            return "Error: \(error.localizedDescription)"
        }
    }
}

// C++ bridging (in separate files)
// C++ function declaration
@_cdecl("calculateWithCpp")
func calculateWithCpp(_ numbers: UnsafePointer<Double>, _ count: Int) -> Double {
    var sum: Double = 0
    for i in 0..<count {
        sum += numbers[i]
    }
    return sum
}