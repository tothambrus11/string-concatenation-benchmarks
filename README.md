# Swift String Benchmarking Suite

This project presents benchmarks for string concatenation approaches and the benefits of avoiding temporary allocations.

## Benchmarks

### 1. LazyMap + Joined

Uses functional programming with lazy evaluation:

- `arr.lazy.map { ... }` to transform elements
- `.joined(separator: "\n")` to concatenate
- String interpolation for formatting

```swift
let str = "BEGINNING \(arr.lazy.map { p in "    \(p) -> \(p * p)" }.joined(separator: "\n")) END"
```

### 2. Piecewise Manual Concatenation

Uses imperative programming with careful string building:

- Manual `for` loop iteration
- Piecewise concatenation with `+=` operator (each component added separately)
- `.description` for conversion to string
- Minimal temporary allocations by growing a single string storage

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

### 3. Manual Concatenation + String Interpolation

Uses imperative programming with string interpolation:

- Manual `for` loop iteration
- String interpolation within the loop for each line
- Single `+=` per iteration with interpolated values

```swift
var str = "BEGINNING "
for i in 0..<arr.count {
    let p = arr[i]
    str += "    \(p) -> \(p * p)"
    if i != arr.count - 1 {
        str += "\n"
    }
}
str += " END"
```

### 4. Manual Concatenation + Temporaries Without String Interpolation

Uses imperative programming with temporary string creation:

- Manual `for` loop iteration
- Creates temporary strings using `+` operator and `.description`
- Each line built as a temporary before concatenating to result

```swift
var str = "BEGINNING "
for i in 0..<arr.count {
    let p = arr[i]
    str += "    " + p.description + " -> " + (p * p).description
    if i != arr.count - 1 {
        str += "\n"
    }
}
str += " END"
```

### 5. Reduce with String Interpolation

Uses functional programming with reduce:

- `arr.lazy.reduce(into: "")` to accumulate result
- String interpolation for formatting each element
- Final wrapping with string interpolation
- NOTE: does add an extra `\n` at the end too, thus doing slightly different thing than `join`.

```swift
let reduced = arr.lazy.reduce(into: "") { partialResult, p in 
    partialResult += "    \(p) -> \(p * p)\n" 
}
let str = "BEGINNING \(reduced) END"
```

### 6. Reduce with Temporary Strings

Uses functional programming with reduce and temporary strings:

- `arr.lazy.reduce(into: "")` to accumulate result
- Creates temporary strings with `+` operator and `.description`
- Each element creates multiple temporary allocations
- NOTE: does add an extra `\n` at the end too, thus doing slightly different thing than `join`.

```swift
let reduced = arr.lazy.reduce(into: "") { partialResult, p in 
    partialResult += "    " + p.description + " -> " + (p * p).description + "\n" 
}
let str = "BEGINNING \(reduced) END"
```

## Metrics Collected

- Malloc (large, small, total)
- CPU time
- Wall clock time

## Results Summary


| Benchmark                                                       | Wall Clock Time (ms) | Small Malloc | Large Malloc | Total Malloc |
| --------------------------------------------------------------- | -------------------- | ------------ | ------------ | ------------ |
| LazyMap + Joined                                                | 271                  | 2000K        | 6            | 2000K        |
| Piecewise Manual Concatenation                                  | 198                  | 25           | 12           | 37           |
| Manual Concatenation + String Interpolation                     | 179                  | 1000K        | 12           | 1000K        |
| Manual Concatenation + Temporaries Without String Interpolation | 224                  | 1000K        | 12           | 1000K        |
| Reduce with string interpolation                                | 187                  | 1000K        | 13           | 1000K        |
| Reduce with temporary strings                                   | 263                  | 2000K        | 13           | 2000K        |

```

================
StringBenchmarks
================

LazyMap + Joined
╒══════════════════════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╕
│ Metric                   │        p0 │       p25 │       p50 │       p75 │       p90 │       p99 │      p100 │   Samples │
╞══════════════════════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╡
│ Malloc (large) *         │         6 │         6 │         6 │         6 │         6 │         6 │         6 │        37 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (small) (K) *     │      2000 │      2000 │      2000 │      2000 │      2000 │      2000 │      2000 │        37 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (total) (K) *     │      2000 │      2000 │      2000 │      2000 │      2000 │      2000 │      2000 │        37 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (total CPU) (ms) *  │       260 │       260 │       270 │       280 │       280 │       290 │       290 │        37 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (wall clock) (ms) * │       259 │       265 │       271 │       277 │       278 │       294 │       294 │        37 │
╘══════════════════════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╛

Manual Concatenation + String Interpolation
╒══════════════════════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╕
│ Metric                   │        p0 │       p25 │       p50 │       p75 │       p90 │       p99 │      p100 │   Samples │
╞══════════════════════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╡
│ Malloc (large) *         │        12 │        12 │        12 │        12 │        12 │        12 │        12 │        56 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (small) (K) *     │      1000 │      1000 │      1000 │      1000 │      1000 │      1000 │      1000 │        56 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (total) (K) *     │      1000 │      1000 │      1000 │      1000 │      1000 │      1000 │      1000 │        56 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (total CPU) (ms) *  │       160 │       170 │       180 │       180 │       190 │       210 │       210 │        56 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (wall clock) (ms) * │       169 │       177 │       179 │       181 │       186 │       208 │       208 │        56 │
╘══════════════════════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╛

Manual Concatenation + Temporaries Without string interpolation
╒══════════════════════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╕
│ Metric                   │        p0 │       p25 │       p50 │       p75 │       p90 │       p99 │      p100 │   Samples │
╞══════════════════════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╡
│ Malloc (large) *         │        12 │        12 │        12 │        12 │        12 │        12 │        12 │        45 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (small) (K) *     │      1000 │      1000 │      1000 │      1000 │      1000 │      1000 │      1000 │        45 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (total) (K) *     │      1000 │      1000 │      1000 │      1000 │      1000 │      1000 │      1000 │        45 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (total CPU) (ms) *  │       210 │       220 │       230 │       230 │       230 │       260 │       260 │        45 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (wall clock) (ms) * │       215 │       222 │       224 │       229 │       232 │       263 │       263 │        45 │
╘══════════════════════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╛

Piecewise Manual Concatenation
╒══════════════════════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╕
│ Metric                   │        p0 │       p25 │       p50 │       p75 │       p90 │       p99 │      p100 │   Samples │
╞══════════════════════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╡
│ Malloc (large) *         │        12 │        12 │        12 │        12 │        12 │        12 │        12 │        50 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (small) *         │        25 │        25 │        25 │        25 │        25 │        25 │        25 │        50 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (total) *         │        37 │        37 │        37 │        37 │        37 │        37 │        37 │        50 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (total CPU) (ms) *  │       180 │       190 │       200 │       210 │       210 │       240 │       240 │        50 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (wall clock) (ms) * │       194 │       196 │       198 │       201 │       206 │       240 │       240 │        50 │
╘══════════════════════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╛

Reduce with string interpolation
╒══════════════════════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╕
│ Metric                   │        p0 │       p25 │       p50 │       p75 │       p90 │       p99 │      p100 │   Samples │
╞══════════════════════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╡
│ Malloc (large) *         │        13 │        13 │        13 │        13 │        13 │        13 │        13 │        54 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (small) (K) *     │      1000 │      1000 │      1000 │      1000 │      1000 │      1000 │      1000 │        54 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (total) (K) *     │      1000 │      1000 │      1000 │      1000 │      1000 │      1000 │      1000 │        54 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (total CPU) (ms) *  │       170 │       180 │       190 │       190 │       200 │       200 │       200 │        54 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (wall clock) (ms) * │       181 │       185 │       187 │       190 │       195 │       202 │       202 │        54 │
╘══════════════════════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╧═══════════╛

Reduce with temporary strings
╒══════════════════════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╤═══════════╕
│ Metric                   │        p0 │       p25 │       p50 │       p75 │       p90 │       p99 │      p100 │   Samples │
╞══════════════════════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╪═══════════╡
│ Malloc (large) *         │        13 │        13 │        13 │        13 │        13 │        13 │        13 │        38 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (small) (K) *     │      2000 │      2000 │      2000 │      2000 │      2000 │      2000 │      2000 │        38 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Malloc (total) (K) *     │      2000 │      2000 │      2000 │      2000 │      2000 │      2000 │      2000 │        38 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (total CPU) (ms) *  │       250 │       260 │       260 │       270 │       280 │       290 │       290 │        38 │
├──────────────────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┤
│ Time (wall clock) (ms) * │       257 │       261 │       263 │       266 │       272 │       290 │       290 │        38 │
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
