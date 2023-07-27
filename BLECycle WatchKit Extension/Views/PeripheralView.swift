//
//  PeripheralController.swift
//  BLECycle WatchKit App
//

import SwiftUI

struct PeripheralView: View {
    @EnvironmentObject var peripheralManager: PeripheralManager
    @EnvironmentObject var workoutManager: WorkoutManager
    var body: some View {
        ScrollView {
            Section(content: {
                VStack {
                    let keys: [String] = peripheralManager.foundPeripherals.map { $0.key }
                    ForEach(keys, id: \.self) {
                        key in Button(action: {
                            peripheralManager.selectedPeripheral = key
                        }) {
                            Text(key)
                        }
                    }
                }
            }, header: {
                if peripheralManager.connected {
                    NavigationLink("Go to workout!", destination: StartView()).tint(.green)
                }
            })
        }
        .navigationTitle("Choose a device")
        .onAppear(perform: {
            peripheralManager.addDistance = workoutManager.addDistance
        })
    }
}

struct PeripheralView_Previews: PreviewProvider {
    static var previews: some View {
        PeripheralView().environmentObject(PeripheralManager())
    }
}
