//
//  PeripheralManager.swift
//  BLECycle WatchKit App
//

import CoreBluetooth
import Foundation

class PeripheralManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var foundPeripherals: [String: CBPeripheral] = [:]
    var previousDist = 0
    var addDistance: ((Double) -> Void)?
    @Published var connected = false

    var selectedPeripheral: String? {
        didSet {
            guard let selectedPeripheral = selectedPeripheral else { return }
            if let peripheral = foundPeripherals[selectedPeripheral] {
                self.centralManager.connect(peripheral)
                self.centralManager.stopScan()
                peripheral.delegate = self
            }
        }
    }

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        central.scanForPeripherals(withServices: nil)
    }

    func centralManager(_: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData _: [String: Any], rssi _: NSNumber) {
        if let name = peripheral.name {
            if let _ = foundPeripherals.index(forKey: name) {
                return
            }
            foundPeripherals[name] = peripheral
            objectWillChange.send()
        }
    }

    func centralManager(_: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connected = true
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices _: Error?) {
        for service in peripheral.services ?? [] {
            if service.uuid == CBUUID(string: "0x1816") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error _: Error?) {
        for characteristics in service.characteristics ?? [] {
            print(characteristics.uuid)
            if characteristics.uuid == CBUUID(string: "0x2a5b") {
                peripheral.readValue(for: characteristics)
                peripheral.setNotifyValue(true, for: characteristics)
            }
        }
    }

    func peripheral(_: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error _: Error?) {
        if let value = characteristic.value {
            let cscData = CSCData(data: value)
            if let revs = cscData?.wheelRevolutions?.revolutions {
                var dist = revs * 2
                if let cranks = cscData?.crankRevolutions?.revolutions {
                    dist = (revs * 3) - (cranks * 4)
                }
                if let addDistance = addDistance {
                    addDistance(Double(dist - previousDist))
                    previousDist = dist
                }
                // 293 revs 121 cranks .31 km
                // 158 revs 34 cranks .32 km
                // 160 revs 47 cranks .32
            }
        }
    }
}
