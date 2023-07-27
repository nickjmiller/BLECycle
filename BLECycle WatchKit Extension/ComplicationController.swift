/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 Description about what the file includes goes here.
 */

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "BLECycle", supportedFamilies: CLKComplicationFamily.allCases),
            // Multiple complication support can be added here with more descriptors
        ]

        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }

    func handleSharedComplicationDescriptors(_: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    func getTimelineEndDate(for _: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }

    func getPrivacyBehavior(for _: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    func getCurrentTimelineEntry(for _: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        handler(nil)
    }

    func getTimelineEntries(for _: CLKComplication, after _: Date, limit _: Int,
                            withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void)
    {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }

    func getLocalizableSampleTemplate(for _: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}
