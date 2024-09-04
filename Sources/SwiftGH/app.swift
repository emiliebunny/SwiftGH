import Logging
import ArgumentParser
import GitCLI
import SwiftTUI

let logger = Logger(label: "app")

@main
struct SwiftGH: ParsableCommand {
    @Option(help: "Specify path for .init file")
    public var inipath: String

    public func run() throws {
        //let ini = try! readINI(path: inipath)
        let ini = try! readINI(path: self.inipath)
        let gitCLI = try! GitCLI(ini: ini)
        //gitCLI.downloadFile()

        //gitCLI.uploadFile()

        logger.info("inifile=\(self.inipath)")
        logger.info("ini=\(ini)")

        Application(rootView: ContentView()).start()


    }
}

