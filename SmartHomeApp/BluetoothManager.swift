//
//  BluetoothManager.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 30/4/25.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    @Published var discoveredPeripherals: [CBPeripheral] = [] // Array to hold discovered Bluetooth devices
    private var centralManager: CBCentralManager!

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScanning() {
        guard centralManager.state == .poweredOn else {
            print("Bluetooth is not powered on.")
            return
        }
        discoveredPeripherals.removeAll() // Clear previous discoveries to avoid duplicates
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
            print("Bluetooth is powered on.")
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
        // Check if the peripheral name is nil or empty, ignore it if so
        guard let peripheralName = peripheral.name, !peripheralName.isEmpty else {
            print("Ignored unknown device")
            return // Skip unknown devices
        }

        print("Discovered \(peripheral.name ?? "Unknown device") at \(RSSI)")

        // Add the discovered peripheral to the list if it's known
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
        }
    }

    func connect(to peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
        print("Connecting to \(peripheral.name ?? "unknown peripheral")...")
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "unknown peripheral")")
        // Optionally discover services or characteristics
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "unknown peripheral")")
    }
}
