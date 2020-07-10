import UIKit

extension RadialGauge: UIGestureRecognizerDelegate {

    // Passthrough of all touches that aren't directly on thumbs.
	public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let lowThumbSelected = isThumbSelected(touchPoint: point, thumbType: .lowThumb)
        let highThumbSelected = isThumbSelected(touchPoint: point, thumbType: .highThumb)

        return lowThumbSelected || highThumbSelected
    }

    func addGestureRecognizer() {
        gestureRecognizer = RotationGestureRecognizer(
            target: self,
            action: #selector(RadialGauge.thumbSelected(_:)))
        addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.delegate = self
    }

    func isThumbSelected(touchPoint: CGPoint, thumbType: RadialGaugeThumbType) -> Bool {
        let thumbAngle: CGFloat
        let thumbLength: CGFloat
        switch thumbType {
        case .highThumb:
            guard isHighThumbVisible else { return false }
            thumbAngle = radialGaugeRenderer.highThumbAngle
            thumbLength = radialGaugeRenderer.highThumbLength
        case .lowThumb:
            guard isLowThumbVisible else { return false }
            thumbAngle = radialGaugeRenderer.lowThumbAngle
            thumbLength = radialGaugeRenderer.lowThumbLength
        }

        let thumbCenter = queryThumbCenter(
            thumbAngle: thumbAngle,
            thumbLenth: thumbLength)
        return sqrt(pow(touchPoint.x - thumbCenter.x, 2) +
            pow(touchPoint.y - thumbCenter.y, 2)) <= thumbLength
    }

    func setProgressTrackStrokeEnd(animated: Bool, highThumbValue: Decimal) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        if animated {
            createStrokeAnimation(
                keyPath: "strokeEnd",
                toValue: CGFloat(truncating: highThumbValue as NSNumber),
                fromValue: radialGaugeRenderer.progressTrackLayer.strokeEnd)
        }

        let normalizedValue = queryNormalizedValue(value: highThumbValue)
        radialGaugeRenderer.progressTrackLayer.strokeEnd = normalizedValue

        CATransaction.commit()
    }

    func setProgressTrackStrokeStart(animated: Bool, lowThumbValue: Decimal) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        if animated {
            createStrokeAnimation(
                keyPath: "strokeStart",
                toValue: CGFloat(truncating: lowThumbValue as NSNumber),
                fromValue: radialGaugeRenderer.progressTrackLayer.strokeStart)
        }

        let normalizedValue = queryNormalizedValue(value: lowThumbValue)
        radialGaugeRenderer.progressTrackLayer.strokeStart = normalizedValue

        CATransaction.commit()
    }

    func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * .pi / 180
    }

    func radiansToDegrees(radians: CGFloat) -> CGFloat {
        return radians * 180 / .pi
    }

    private func queryNormalizedValue(value: Decimal) -> CGFloat {
        let normalizedValue = (value - minimumValue) / (maximumValue - minimumValue)
        return CGFloat(truncating: normalizedValue as NSNumber)
    }

    private func handleThumbAction(touchAngle: CGFloat) -> Decimal {
        let midPointAngle = (2 * CGFloat(Double.pi) + startAngle - endAngle) / 2 + endAngle
        var boundedAngle = touchAngle

        if (boundedAngle > midPointAngle) ||
            (boundedAngle < (midPointAngle - 2 * CGFloat(Double.pi))) {
            boundedAngle -= 2 * CGFloat(Double.pi)
        }

        boundedAngle = min(endAngle, max(startAngle, boundedAngle))
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let angleValue = (boundedAngle - startAngle) /
            angleRange *
            CGFloat(truncating: valueRange as NSNumber) +
            CGFloat(truncating: minimumValue as NSNumber)

        return Decimal(Double(angleValue))
    }

    @objc private func thumbSelected(_ gesture: RotationGestureRecognizer) {
        if gesture.isHighThumbUnderInteraction {
            handleHighThumbSelected(touchAngle: gesture.touchAngle)
        } else if gesture.isLowThumbUnderInteraction {
            handleLowThumbSelected(touchAngle: gesture.touchAngle)
        }
    }

    private func handleHighThumbSelected(touchAngle: CGFloat) {
        let newThumbValue = queryNewThumbValue(
            touchAngle: touchAngle,
            lastThumbValue: highThumbValue,
            stepSize: highThumbStepSize)
        guard newThumbValue >= lowThumbValue else { return }
        setHighThumbValue(newThumbValue)
    }

    private func handleLowThumbSelected(touchAngle: CGFloat) {
        let newThumbValue = queryNewThumbValue(
            touchAngle: touchAngle,
            lastThumbValue: lowThumbValue,
            stepSize: lowThumbStepSize)
        guard newThumbValue <= highThumbValue else { return }
        setLowThumbValue(newThumbValue)
    }

    private func queryNewThumbValue(touchAngle: CGFloat, lastThumbValue: Decimal, stepSize: Decimal) -> Decimal {
        let newAngleValue = handleThumbAction(touchAngle: touchAngle)
        var roundedValue: Decimal = Decimal()
        var value = (newAngleValue - lastThumbValue) / stepSize
        NSDecimalRound(&roundedValue, &value, 0, .plain)
        let incrementValue = roundedValue * stepSize
        return lastThumbValue + incrementValue
    }

    private func createStrokeAnimation(
        keyPath: String,
        toValue: CGFloat,
        fromValue: CGFloat
    ) {
        let strokeAnimation = CABasicAnimation(keyPath: keyPath)
        let normalizedValue = queryNormalizedValue(value: Decimal(Double(toValue)))
        strokeAnimation.duration = 0.66
        strokeAnimation.repeatCount = 1
        strokeAnimation.fromValue = fromValue
        strokeAnimation.toValue = normalizedValue
        strokeAnimation.isRemovedOnCompletion = false
        strokeAnimation.fillMode = CAMediaTimingFillMode.removed
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        radialGaugeRenderer.progressTrackLayer.add(strokeAnimation, forKey: "strokeAnimation")
    }

    private func queryControlThickness(thumbLenth: CGFloat) -> CGFloat {
        let thumbRadius = thumbLenth / 2
        return max(thumbRadius, lineWidth / 2.0)
    }

    private func queryThumbCenter(thumbAngle: CGFloat, thumbLenth: CGFloat) -> CGPoint {
        var thumbCenter = convert(center, from: superview)
        let thumbAngle = CGFloat(thumbAngle)
        let controlThickness = queryControlThickness(thumbLenth: thumbLenth)
        let controlRadius = min(bounds.width, bounds.height) / 2.0 - controlThickness
        thumbCenter.x += CGFloat(cos(thumbAngle)) * controlRadius
        thumbCenter.y += CGFloat(sin(thumbAngle)) * controlRadius
        return thumbCenter
    }

}
