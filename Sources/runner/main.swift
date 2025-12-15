// Benchmark Runner
import Foundation

print("===== String Benchmarking Suite =====\n")

func runBenchmark(name: String, executable: String) {
    print("Running: \(name)")
    print("---")
    
    let task = Process()
    task.executableURL = URL(fileURLWithPath: ".build/release/\(executable)")
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    
    do {
        try task.run()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            print(output)
        }
    } catch {
        print("Error running \(name): \(error)")
    }
    
    print()
}

print("Build the benchmarks first with:")
print("  swift build -c release\n")
print("Then run individual benchmarks:\n")

runBenchmark(name: "Lazy Map + Joined", executable: "benchmark-lazy-map")
runBenchmark(name: "Manual Concatenation", executable: "benchmark-manual-concat")

print("===== Benchmark Complete =====")
