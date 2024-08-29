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
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(atPath: localFolder, withIntermediateDirectories: true, attributes: nil)
            logger.info("folder created.")
        } catch {
            logger.info("folder found.")
            throw error
        }
    }

    public func getData() -> String {
        logger.info("getData \(repo) \(repoFile) \(localFolder)")
        return "getData \(repo)"
    }

    func runTask(executable: String, arguments: [String], completion: @escaping (String?, Error?) -> Void) {
        let process = Process()
            process.executableURL = URL(fileURLWithPath: executable)
            process.arguments = arguments

            let outputPipe = Pipe()
            process.standardOutput = outputPipe

            do {
                try process.run()
            } catch {
                completion(nil, error)
                    return
            }

        process.waitUntilExit()

            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: outputData, encoding: .utf8)
            completion(output, nil)
    }

    func runGitTask(arguments: [String], completion: @escaping (String?, Error?) -> Void) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "git")
        process.arguments = arguments

        let outputPipe = Pipe()
        process.standardOutput = outputPipe

        do {
        try process.run()
        } catch {
        completion(nil, error)
        return
        }

        process.waitUntilExit()

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: outputData, encoding: .utf8)
        completion(output, nil)
    }

    public func sync() {
        logger.info("Sync")
        
        let task = Process()
        task.currentDirectoryURL = URL(fileURLWithPath: localFolder)

        //print(task.currentDirectoryURL?.path)

        let outputPipe = Pipe()
        let errorPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardError = errorPipe

        task.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        task.arguments = ["init"]
        do {
            try task.run()
        } catch {
            logger.info("Sync error: \(error)")
        }
        
        //task.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        task.arguments = ["remote", "add", "origin", repo]
        do {
            try task.run()
        } catch {
            logger.info("Sync error: \(error)")
        }

        //task.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        task.arguments = ["fetch", "--all"]
        do {
            try task.run()
        } catch {
            logger.info("Sync error: \(error)")
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
