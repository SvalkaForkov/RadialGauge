import UIKit

/**
Customizable and reusable iOS circular slider.

Radial Gauge can be customized to meet many requirements.

**How to use**
```
var radialGauge = RadialGauge()
...
radialGauge.setProgressTrackValue(50)
```
*/
class SimpleRadialGauge: UIView {

	var radialGaugeRenderer: SimpleRadialGaugeRenderer!
	var gestureRecognizer: RotationGestureRecognizer!

	/** Minimum value of radial gauge. */
	public var minimumValue: Decimal = 0
	/** Maximum value of radial gauge. */
	public var maximumValue: Decimal = 100
	/** Minimum value of the low thumb. */
	public var lowThumbMinimumValue: Decimal = 0
	/** Maximum value of the low thumb. */
	public var lowThumbMaximumValue: Decimal = 100
	/** Minimum value of the high thumb. */
	public var highThumbMinimumValue: Decimal = 0
	/** Maximum value of the high thumb. */
	public var highThumbMaximumValue: Decimal = 100

	/** Specifies the default step size for incrementing or decrementing high thumb values. */
	public var thumbStepSize: Decimal = 1

	/** Specifies the color of the background track. Defaults to gray
	Delegate which exposes selected values. */
	public weak var delegate: RadialGaugeDelegate?

	/** Specifies the color of the background track. Defaults to gray */
	public var backgroundTrackColor: UIColor {
		get { return radialGaugeRenderer.backgroundTrackColor }
		set { radialGaugeRenderer.backgroundTrackColor = newValue }
	}

	/** Specifies the color of the progress track. Defaults to blue */
	public var progressLayerColor: UIColor {
		get { return radialGaugeRenderer.progressTrackColor }
		set { radialGaugeRenderer.progressTrackColor = newValue }
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		buildViews()
		addGestureRecognizer()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		buildViews()
		addGestureRecognizer()
	}

	func setProgressTrackValue(_ value: Decimal) {
		CATransaction.begin()
		CATransaction.setDisableActions(true)

		let normalizedValue = queryNormalizedValue(value: value)
		radialGaugeRenderer.progressTrackLayer.strokeEnd = normalizedValue

		CATransaction.commit()
	}

	private func queryNormalizedValue(value: Decimal) -> CGFloat {
		let normalizedValue = (value - minimumValue) / (maximumValue - minimumValue)
		return CGFloat(truncating: normalizedValue as NSNumber)
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		radialGaugeRenderer.renderRadialGauge(insideBounds: bounds)
	}

	func setValue(_ value: Decimal) {
		let newAngleValue = queryThumbAngleValue(value)
		radialGaugeRenderer.setThumbAngle(newAngleValue)
		thumbValue = value
		setProgressTrackValue(value)
	}

	private var angleRange: CGFloat {
		return endAngle - startAngle
	}

	private var valueRange: Decimal {
		return maximumValue - minimumValue
	}

	/** Specifies the angle of the start of the control track. Defaults to -11π/8 */
	var startAngle: CGFloat {
		get { return radialGaugeRenderer.startAngle }
		set { radialGaugeRenderer.startAngle = newValue }
	}

	/** Specifies the end angle of the knob control track. Defaults to 3π/8 */
	var endAngle: CGFloat {
		get { return radialGaugeRenderer.endAngle }
		set { radialGaugeRenderer.endAngle = newValue }
	}

	/** Default value of thumb. */
	var thumbValue: Decimal = 0 {
		didSet {
			delegate?.thumbValueChanged(value: thumbValue)
		}
	}

	private func queryThumbAngleValue(_ value: Decimal) -> Decimal {
		return (value - minimumValue) / valueRange * Decimal(Double(angleRange)) + Decimal(Double(startAngle))
	}

}
