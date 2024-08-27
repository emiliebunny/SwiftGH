import ArgumentParser
import GitCLI

@main
struct SwiftGH: ParsableCommand {
    @Option(help: "Specify path for .init file")
    public var inipath: String

    public func run() throws {
        //let ini = try! readINI(path: inipath)
        let ini = try! readINI(path: self.inipath)
        let gitCLI = try! GitCLI(ini: ini)
        let data = gitCLI.getData()
        print (data)
    }
}
