import UIKit

class RadialGradientWithDotImageView: UIImageView {
    static var spectrumColours = [UIColor]()

    static func getColorForAngle(angleDEG: Int) -> UIColor {
        if checkIfAngleIsInColorRange(angleDEG: angleDEG) {
            if checkIfAngleIsWithinFirstPercentage(angle: angleDEG, percentage: 10) {
                return UIColor.minimumDonutLowColor()
            } else {
                return spectrumColours[angleDEG]
            }
        } else {
            return UIColor.minimumDonutLowColor()
        }
    }

    static func checkIfAngleIsInColorRange(angleDEG: Int) -> Bool {
        guard angleDEG < spectrumColours.count && angleDEG >= 0 else {
            return false
        }

        return true
    }

    static func checkIfAngleIsWithinFirstPercentage(angle: Int, percentage: Int) -> Bool {
        let validSpan = Int(CGFloat(spectrumColours.count) * CGFloat(percentage)/100.0)
        return (angle >= 0 && angle <= validSpan)
    }

    static func getCircularGradientImage(
        gradientColors: [GradientComponents],
        size: CGSize,
        numberOfColors: Int
    ) -> UIImage? {
        spectrumColours.removeAll()

        if size.width == 0 || size.height == 0 {
            return nil
        }

        if gradientColors.count < 2 {
            return nil
        }

        let dimension: CGFloat = size.width
        let radius = min(dimension, dimension)/2

        var fR: CGFloat = 0.0 //fromRed, fromGreen etc
        var fG: CGFloat = 0.0 //fromRed, fromGreen etc
        var fB: CGFloat = 0.0 //fromRed, fromGreen etc

        var tR: CGFloat = 0.0 //toRed, toGreen etc
        var tG: CGFloat = 0.0 //toRed, toGreen etc
        var tB: CGFloat = 0.0 //toRed, toGreen etc

        var dR: CGFloat = 0.0
        var dG: CGFloat = 0.0
        var dB: CGFloat = 0.0

        var currentStep = 0
        var nextGradientDegree = 0
        var currDegree = 0
        var currGradient: GradientComponents!
        var nextGradient: GradientComponents!

        for colorIndex in 0 ..< numberOfColors {
            if nextGradientDegree == colorIndex {
                currGradient  = gradientColors[currentStep]
                currentStep += 1
                if gradientColors.count > currentStep {
                    nextGradient  = gradientColors[currentStep]
                    nextGradientDegree += Int(CGFloat(numberOfColors) * nextGradient.percentage / 100.0)
                } else {
                    nextGradientDegree = numberOfColors
                }

                currGradient.color.getRed(&fR, green: &fG, blue: &fB, alpha: nil)
                nextGradient.color.getRed(&tR, green: &tG, blue: &tB, alpha: nil)

                let dDegrees = Int(CGFloat(numberOfColors) * nextGradient.percentage / 100.0)

                dR = (tR-fR)/CGFloat(dDegrees)
                dG = (tG-fG)/CGFloat(dDegrees)
                dB = (tB-fB)/CGFloat(dDegrees)

                currDegree += Int(CGFloat(numberOfColors) * currGradient.percentage / 100.0)
            }

            let step = CGFloat(colorIndex - currDegree)

            spectrumColours.append(UIColor(red: fR+step*dR, green: fG+step*dG, blue: fB+step*dB, alpha: 1.0))
        }

        let angle = 2 * Double.pi/Double(numberOfColors)
        var bezierPath: UIBezierPath
        let center = CGPoint(x: size.width / 2, y: size.height / 2)

        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: size.width, height: size.height),
            true,
            0.0)
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))

        for colorIndex in 0 ..< numberOfColors {
            let colour = spectrumColours[colorIndex]; //colour for increment

            bezierPath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: CGFloat(Double(colorIndex) * angle) ,
                                      endAngle: CGFloat((Double(colorIndex) + 1) * angle),
                                      clockwise: true)

            bezierPath.addLine(to: center)
            bezierPath.close()

            colour.setFill()
            colour.setStroke()
            bezierPath.fill()
            bezierPath.stroke()
        }
        let image =  UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
