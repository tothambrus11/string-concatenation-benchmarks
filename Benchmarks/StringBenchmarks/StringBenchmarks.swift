import Benchmark
import Foundation

@MainActor
let benchmarks = {
    let arr = (0..<1_000_000).map({ $0 })

    Benchmark(
        "LazyMap+Joined",
        configuration: .init(
            metrics: [
                .wallClock, .cpuTotal, .mallocCountTotal, .mallocCountSmall, .mallocCountLarge,
                .syscalls,
            ],
            warmupIterations: 1,
            scalingFactor: .one,
            maxDuration: .seconds(10),
            maxIterations: 1000
        )
    ) { benchmark in

        for _ in benchmark.scaledIterations {
            benchmark.startMeasurement()
            let str =
                "BEGINNING \(arr.lazy.map { p in "    \(p) -> \(p * p)" }.joined(separator: "\n")) END"
            blackHole(str.count)
            benchmark.stopMeasurement()
        }

    }

    Benchmark(
        "ManualConcatenation",
        configuration: .init(
            metrics: [
                .wallClock, .cpuTotal, .mallocCountTotal, .mallocCountSmall, .mallocCountLarge,
                .syscalls,
            ],
            warmupIterations: 1,
            scalingFactor: .one,
            maxDuration: .seconds(10),
            maxIterations: 1000
        )
    ) { benchmark in

        for _ in benchmark.scaledIterations {
            benchmark.startMeasurement()
            var str = "BEGINNING "
            for i in 0..<arr.count {
                let p = arr[i]
                str += "    "
                str += p.description
                str += " -> "
                str += (p * p).description
                if i != arr.count - 1 {
                    str += "\n"
                }
            }
            str += " END"
            blackHole(str.count)
            benchmark.stopMeasurement()
        }

    }
}
