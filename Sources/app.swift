import ArgumentParser
//import Backtrace

//Backtrace.install()

// SpawnRun()

@main
struct SwiftGH: ParsableCommand {
    @Option(help: "Specify path for .init file")
    public var inipath: String

    public func run() throws {
        let ini = try! readINI(path: inipath)
        print(ini)
    }
}
