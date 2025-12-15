// Benchmark: Lazy Map with String Interpolation and Joined
import Foundation

let arr = (0..<1000000).map({$0})

var res = Int(CommandLine.arguments.count)
var durationSum: Int128 = 0

for _ in 0..<10 {
    let clock = ContinuousClock()
    durationSum += clock.measure{
        let str = "Struct \(arr.lazy.map { p in "    \(res) -> \(p * p)" }.joined(separator: "\n"))\n world"
        // print(str)
        res += str.count
    }.attoseconds
}

print(res)
print(Float(durationSum) / 10 * 10e-18)
