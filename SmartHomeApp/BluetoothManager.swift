//
//  BluetoothManager.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 30/4/25.
//

import Foundation
import CoreBluetooth
import Combine

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    @Published var discoveredPeripherals: [CBPeripheral] = [] // Published property to notify views of changes
    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScanning() {
        guard centralManager.state == .poweredOn else {
            print("Bluetooth is not powered on.")
            return
        }
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        print("Scanning for devices...")
    }

    func stopScanning() {
        centralManager.stopScan()
        print("Stopped scanning.")
    }

    // CBCentralManagerDelegate methods
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            startScanning() // Start scanning if Bluetooth is powered
        case .poweredOff:
            print("Bluetooth is powered off.")
            stopScanning()
        case .resetting:
            print("Bluetooth is resetting.")
        case .unauthorized:
            print("Bluetooth is not authorized.")
        case .unsupported:
            print("Bluetooth is not supported on this device.")
        case .unknown:
            print("Bluetooth state is unknown.")
        @unknown default:
            print("A previously unknown state occurred.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name ?? "Unknown device") at \(RSSI)")

        // Check if peripheral is already discovered
        guard !discoveredPeripherals.contains(peripheral) else { return }
        discoveredPeripherals.append(peripheral)
    }

    func connect(to peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
        print("Connecting to \(peripheral.name ?? "unknown peripheral")...")
        connectedPeripheral = peripheral
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "unknown peripheral")")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "unknown peripheral")")
        connectedPeripheral = nil
    }
}
