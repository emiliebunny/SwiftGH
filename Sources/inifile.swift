import Foundation

func readINI(path: String = "") throws -> [String: String] {
    var INI: [String: String] = [:]
    var filename = path
    if filename.isEmpty {
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath

        filename = currentPath + "/config.ini"
    }
    
    do {
        let contents = try String(contentsOfFile: filename, encoding: .utf8)
        let lines = contents.split(separator:"\n")
        for line in lines {
            let li = line.split(separator:"=")
            if ["REPO", "FILE", "LOCALFOLDER"].contains(li[0]) {
                let iniValue = String(li[1]) 
                if !iniValue.isEmpty {
                    if iniValue.first != "\"" && iniValue.last != "\"" {
                        INI[String(li[0])] = iniValue
                    } else {
                        INI[String(li[0])] = String(iniValue.dropFirst().dropLast())
                    }
                }
            }
            
        }
        return INI
    } catch {
        throw error
    }
}
