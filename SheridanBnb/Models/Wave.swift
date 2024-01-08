import Foundation
import SwiftUI

struct Wave: Shape {

    var phase: Double
    var strength: Double //how high the wave gets
    var frequency: Double

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()

        // calculate some important values up front
        let width = Double(rect.maxX)
        let height = Double(rect.maxY)
        _ = width / 2
        let midHeight = height / 2

        // split our total width up based on the frequency
        let wavelength = width / frequency

        // start at the left center
        path.move(to: CGPoint(x: 0, y: midHeight))

        // now count across individual horizontal points one by one
        for x in stride(from: 0, through: width + 10, by: 10) {
            // find our current position relative to the wavelength
            let relativeX = x / wavelength

            // calculate the sine of that position
            let sine = sin(relativeX + phase)

            // multiply that sine by our strength to determine final offset, then move it down to the middle of our view
            let y = strength * sine + midHeight

            // add a line to here
            path.addLine(to: CGPoint(x: x, y: y))
        }
        return Path(path.cgPath)
    }
}
