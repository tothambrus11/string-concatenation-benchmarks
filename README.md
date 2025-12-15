# Swift String Benchmarking Suite

This project presents benchmarks for string concatenation approaches and the benefits of avoiding temporary allocations.

## Benchmarks

### 1. LazyMap+Joined
Uses functional programming with lazy evaluation:
- `arr.lazy.map { ... }` to transform elements
- `.joined(separator: "\n")` to concatenate
- String interpolation for formatting

```swift
let str = "BEGINNING \(arr.lazy.map { p in "    \(p) -> \(p * p)" }.joined(separator: "\n")) END"
```

### 2. ManualConcatenation
Uses imperative programming with explicit loops:
- Manual `for` loop iteration
- String concatenation with `+=` operator, making sure we only grow the single string storage
- `.description` for conversion to string

```swift
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
```


## Metrics Collected
- Malloc (large, small, total)
- CPU time
- Wall clock time

## Results Summary

In this benchmark, manual concatenation is ~40% faster than LazyMap + joined approach:
- LazyMap+Joined: ~253ms (median wall clock)
- ManualConcatenation: ~180ms (median wall clock)
- The lazy approach allocated small memory 1999 K times vs manual concatenation only 25 times. However, it appears that this did not have a proportional impact, small allocations are relatively cheap.  
- In the end, the performance gap between the beuatiful and the manual version are significant.

```
LazyMap+Joined
╒══════════════════════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╕
│ Metric                   │        p0 │       p25 │       p50 │       p75 │       p90 │       p99 │      p100 │   Samples │
╞══════════════════════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╡
│ Malloc (large) *         │         6 │         6 │         6 │         6 │         6 │         6 │         6 │        39 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (small) (K) *     │      1999 │      1999 │      1999 │      1999 │      1999 │      1999 │      1999 │        39 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (total) (K) *     │      1999 │      1999 │      1999 │      1999 │      1999 │      1999 │      1999 │        39 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (total CPU) (ms) *  │       250 │       260 │       270 │       280 │       280 │       290 │       290 │        39 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (wall clock) (ms) * │       247 │       256 │       261 │       263 │       266 │       273 │       273 │        39 │
╘══════════════════════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╛

ManualConcatenation
╒══════════════════════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╕
│ Metric                   │        p0 │       p25 │       p50 │       p75 │       p90 │       p99 │      p100 │   Samples │
╞══════════════════════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╡
│ Malloc (large) *         │        11 │        11 │        11 │        11 │        11 │        11 │        11 │        56 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (small) *         │        25 │        25 │        25 │        25 │        25 │        25 │        25 │        56 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (total) *         │        36 │        36 │        36 │        36 │        36 │        36 │        36 │        56 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (total CPU) (ms) *  │       170 │       180 │       190 │       190 │       200 │       220 │       220 │        56 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (wall clock) (ms) * │       170 │       176 │       181 │       183 │       185 │       198 │       198 │        56 │
╘══════════════════════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╛
```

## Prerequisites

Install jemalloc development library:
```bash
# Ubuntu/Debian
sudo apt-get install libjemalloc-dev

# macOS
brew install jemalloc
```

## Usage

### Run all benchmarks:
```bash
swift package --disable-sandbox benchmark
```
