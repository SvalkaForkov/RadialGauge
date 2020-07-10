import UIKit

extension SimpleRadialGauge {

	func addGestureRecognizer() {
		gestureRecognizer = RotationGestureRecognizer(
			target: self,
			action: #selector(SimpleRadialGauge.thumbSelected))
		addGestureRecognizer(gestureRecognizer)
	}

	@objc private func thumbSelected(_ gesture: RotationGestureRecognizer) {
		let touchAngle = gesture.touchAngle
		let newThumbValue = queryNewThumbValue(
			touchAngle: touchAngle,
			lastThumbValue: thumbValue,
			stepSize: thumbStepSize)
		 setValue(newThumbValue)
	}

	private func queryNewThumbValue(touchAngle: CGFloat, lastThumbValue: Decimal, stepSize: Decimal) -> Decimal {
		let newAngleValue = handleThumbAction(touchAngle: touchAngle)
		var roundedValue: Decimal = Decimal()
		var value = (newAngleValue - lastThumbValue) / stepSize
		NSDecimalRound(&roundedValue, &value, 0, .plain)
		let incrementValue = roundedValue * stepSize
		return lastThumbValue + incrementValue
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

}
