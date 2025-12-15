// Benchmark: Manual String Concatenation with Loop
import Foundation

let arr = (0..<1000000).map({$0})

var res = Int(CommandLine.arguments.count)
var durationSum: Int128 = 0

for _ in 0..<10 { 
    let clock = ContinuousClock()
    durationSum += clock.measure{
        var str = "Struct "
        for i in 0..<arr.count {
            let p = arr[i]
            str += "    " 
            str += res.description
            str += " -> "
            str += (p * p).description
            str += "\n"
        }
        str += " world"
        // print(str)
        res += str.count
    }.attoseconds
}

print(res)
print(Float(durationSum) / 10 * 10e-18)
