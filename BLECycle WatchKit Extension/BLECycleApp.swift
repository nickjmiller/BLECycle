/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The entry point into the app.
*/

import SwiftUI

@main
struct BLECycleApp: App {
    @StateObject private var workoutManager = WorkoutManager()
    @StateObject private var peripheralManager = PeripheralManager()

    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationStack {
                PeripheralView()
            }
            .sheet(isPresented: $workoutManager.showingSummaryView) {
                SummaryView()
            }
            .environmentObject(workoutManager)
            .environmentObject(peripheralManager)
        }
    }
}
