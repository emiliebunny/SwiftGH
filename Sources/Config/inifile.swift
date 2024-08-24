import Foundation

func readINI() {
    // let fileManager = FileManager.default
    // let path = fileManager.currentDirectoryPath
    // print(path)
    let filename = "swiftgh.ini"
    do {
        let contents = try String(contentsOfFile: filename, encoding: .utf8)
        let lines = contents.split(separator:"\n")
        for line in lines {
            let li = line.split(separator:"=")
            print(li[0], li[1])
        }
    } catch {
        print(error)
    }

}
