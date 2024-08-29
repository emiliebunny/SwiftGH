import Logging
import Foundation

let logger = Logger(label: "GitCLI")

public struct GitCLI {
    let repo: String
    let repoFile: String
    let localFolder: String

    public init(ini: [String:String]) throws {
        if let iniRepo = ini["REPO"] {
            repo = iniRepo
        } else {
            throw GitCLIError.InvalidRepository
        }
        if let iniRepoFile = ini["REPOFILE"] {
            repoFile = iniRepoFile
        } else {
            throw GitCLIError.InvalidRepoFile
        }
        if let iniLocalFolder = ini["LOCALFOLDER"] {
            localFolder = iniLocalFolder
        } else {
            throw GitCLIError.InvalidLocalFolder
        }
    }

    public func getData() -> String {
        logger.info("getData \(repo) \(repoFile) \(localFolder)")
        return "getData \(repo)"
    }

    public func Sync() {
        logger.info("Sync")
        
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
}
