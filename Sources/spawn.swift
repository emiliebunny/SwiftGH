import Foundation

func SpawnRun() {
    print("test SpawnRun")
    let task = Process()
    
    let outputPipe = Pipe()
    let errorPipe = Pipe()
    task.standardOutput = outputPipe
    task.standardError = errorPipe
    
    task.executableURL = URL(fileURLWithPath: "/usr/bin/git")
    let filename = "log"
    task.arguments = [filename]
    do {
        try task.run()
    } catch {
        print("Error \(error) !!")
    }

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(decoding: outputData, as: UTF8.self)        
    let error = String(decoding: errorData, as: UTF8.self)
    print(outputData)
    print(errorData)
    print(output)
    print(error)
}
