/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 The start view.
 */

import HealthKit
import SwiftUI

struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var workoutTypes: [HKWorkoutActivityType] = [.cycling]

    var body: some View {
        NavigationStack {
            List(workoutTypes) { workoutType in
                NavigationLink("Start", destination: SessionPagingView(),
                               tag: workoutType, selection: $workoutManager.selectedWorkout)
            }
        }
        .listStyle(.carousel)
        .navigationBarTitle("Workout")
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView().environmentObject(WorkoutManager())
    }
}

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }
}
