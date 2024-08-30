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
        process.currentDirectoryURL = URL(fileURLWithPath: localFolder)
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

    func runGitDownloadTasks() {
        let git = "/usr/bin/git"
        let tasks = [
            (git, ["init"]),
            (git, ["remote", "add", "origin", repo]),
            (git, ["fetch", "--all"]),
            (git, ["checkout", "origin/main", "--", repoFile])
        ]
        let dispatchGroup = DispatchGroup()
        for task in tasks {
            dispatchGroup.enter()
            runTask(executable: task.0, arguments: task.1) { output, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let output = output {
                    print("Output: \(output)")
                }
                dispatchGroup.leave()
            }
            dispatchGroup.wait()
        }
    }
    
    public func downloadFile() {
        logger.info("downloadFile")
        runGitDownloadTasks()
    }

    public func uploadFile() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let currDate = formatter.string(from: date)

        logger.info("uploadFile \(currDate)")    

        let git = "/usr/bin/git"
        let tasks = [
            (git, ["add", repoFile]),
            (git, ["commit", "-m", currDate]),
            (git, ["push", "--set-upstream", "origin", "main", "--force"])
        ]
        let dispatchGroup = DispatchGroup()
        for task in tasks {
            dispatchGroup.enter()
            runTask(executable: task.0, arguments: task.1) { output, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let output = output {
                    print("Output: \(output)")
                }
                dispatchGroup.leave()
            }
            dispatchGroup.wait()
        }
    }

    func syncOLD() {
        logger.info("Sync")
        
        var task = Process()
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
        task.waitUntilExit()

        task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        task.arguments = ["remote", "add", "origin", repo]
        do {
            try task.run()
        } catch {
            logger.info("Sync error: \(error)")
        }
        task.waitUntilExit()

        task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        task.arguments = ["fetch", "--all"]
        do {
            try task.run()
        } catch {
            logger.info("Sync error: \(error)")
        }
        task.waitUntilExit()

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
