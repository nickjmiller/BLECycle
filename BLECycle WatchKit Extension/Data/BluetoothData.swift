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

struct CSCData {
    var wheelRevolutions: RevolutionData?
    var crankRevolutions: RevolutionData?

    init?(data: Data) {
        var data = data // Make mutable so we can consume it

        // First pull off the flags
        guard let flags = Flags(consuming: &data) else { return nil }

        // If wheel revolution is present, decode it
        if flags.contains(.wheelRevolutionPresent) {
            guard let value = RevolutionData(consuming: &data, countType: UInt32.self) else {
                return nil
            }
            wheelRevolutions = value
        }

        // If crank revolution is present, decode it
        if flags.contains(.wheelRevolutionPresent) {
            guard let value = RevolutionData(consuming: &data, countType: UInt16.self) else {
                return nil
            }
            crankRevolutions = value
        }
    }
}

struct Flags: OptionSet {
    let rawValue: UInt8

    static let wheelRevolutionPresent = Flags(rawValue: 1 << 0)
    static let crankRevolutionPresent = Flags(rawValue: 1 << 1)
}

extension Flags {
    init?(consuming data: inout Data) {
        guard let byte = data.consume(type: UInt8.self) else { return nil }
        self.init(rawValue: byte)
    }
}

struct RevolutionData {
    var revolutions: Int
    var eventTime: TimeInterval

    init?<RevolutionCount>(consuming data: inout Data, countType _: RevolutionCount.Type)
        where RevolutionCount: FixedWidthInteger
    {
        guard let count = data.consume(type: RevolutionCount.self)?.littleEndian,
              let time = data.consume(type: UInt16.self)?.littleEndian
        else {
            return nil
        }

        revolutions = Int(clamping: count)
        eventTime = TimeInterval(time) / 1024.0 // Unit is 1/1024 second
    }
}
