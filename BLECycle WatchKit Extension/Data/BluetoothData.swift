//
//  BluetoothData.swift
//  BLECycle WatchKit App
//
// https://stackoverflow.com/questions/66821181/how-to-break-down-hex-data-into-usable-data-from-ble-device-speed-and-cadence
//

import Foundation

extension Data {
    // Based on Martin R's work: https://stackoverflow.com/a/38024025/97337
    mutating func consume<T>(type _: T.Type) -> T? where T: ExpressibleByIntegerLiteral {
        let valueSize = MemoryLayout<T>.size
        guard count >= valueSize else { return nil }
        var value: T = 0
        _ = Swift.withUnsafeMutableBytes(of: &value) { copyBytes(to: $0) }
        removeFirst(valueSize)
        return value
    }
}

struct IndoorBikeData {
    let flags: UInt16?
    let speed: UInt16?
    let cadence: UInt16?
    let power: UInt16?

    init?(data: Data) {
        var data = data

        flags = data.consume(type: UInt16.self)
        speed = data.consume(type: UInt16.self)?.littleEndian
        cadence = data.consume(type: UInt16.self)?.littleEndian
        power = data.consume(type: UInt16.self)?.littleEndian
    }
}
