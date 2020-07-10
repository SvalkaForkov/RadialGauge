public class RadialGauge: UIView {

	internal var radialGaugeRenderer: RadialGaugeRenderer!
    internal var gestureRecognizer: RotationGestureRecognizer!
	internal var gaugeViewWithGradient: UIView!
	internal var radialGradient: RadialGradientWithDotImageView!

	/** Specifies the color of the background track. Defaults to gray
	Delegate which exposes selected values. */
	public weak var delegate: RadialGaugeDelegate?
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
	/** When low thumb is close to high thumb then both thumbs will be moved if this value is true. */
	public var dualMoveEnabled: Bool = true
	/** Thumbs step size. */
	public var thumbStepSize: Decimal?
	/** Maximum distance between low and high thumb. */
    public var lowHighDeadband: Decimal?
	/** Specifies the default step size for incrementing or decrementing high thumb values. */
	public var highThumbStepSize: Decimal = 0
	/** Specifies the default step size for incrementing or decrementing low thumb values. */
	public var lowThumbStepSize: Decimal = 0
	/** Gradient colors for progress track layer. */
	public var gradientColors = [GradientComponents]()

	var angleRange: CGFloat {
		return endAngle - startAngle
	}

	var valueRange: Decimal {
		return maximumValue - minimumValue
	}

	var gaugeSpread: CGFloat {
		return radiansToDegrees(radians: endAngle - startAngle)
	}

	/** Maximum distance between low and high thumb. */
	// If lowHighDeadband is not defined then thumb step size for deadband will be used.
	var deadband: Decimal {
		guard isLowThumbVisible else { return 0 }
		if let lowHighDeadband = lowHighDeadband {
			return lowHighDeadband
		} else if let thumbStepSize = thumbStepSize {
			return thumbStepSize
		}
		return highThumbStepSize
	}

    /** Angle value in degrees for high thumb */
    var highThumbAngleDeg: Int {
        return thumbAngleDeg(radialGaugeRenderer.highThumbAngle)
    }

    /** Angle value in degrees for low thumb */
    var lowThumbAngleDeg: Int {
        return thumbAngleDeg(radialGaugeRenderer.lowThumbAngle)
    }

	public var indicatorValue: Decimal = 0 {
		didSet {
			delegate?.indicatorValueChanged(value: indicatorValue)
		}
	}

    /** Default value of high thumb. */
    public var highThumbValue: Decimal = 0 {
        didSet {
            delegate?.highThumbValueChanged(value: highThumbValue)
        }
    }

    /** Default value of low thumb. */
    public var lowThumbValue: Decimal = 0 {
        didSet {
            delegate?.lowThumbValueChanged(value: lowThumbValue)
        }
    }

    var alphaValue: CGFloat = 1 {
        didSet {
            radialGaugeRenderer.alphaValue = Float(alphaValue)
        }
    }

    /** Specifies the offset of radial gauge inside superview. Used to increase the touch area of thumb. */
    var offset: CGFloat {
        return radialGaugeRenderer.offset
    }

    /** Specifies the progress track visibility */
    var isProgressLayerVisible: Bool = true {
        didSet {
            radialGaugeRenderer.progressTrackLayer.isHidden = !isProgressLayerVisible
        }
    }

    /** Specifies the high thumb visibility  */
    public var isHighThumbVisible: Bool = true {
        didSet {
            radialGaugeRenderer.highThumbLayer.isHidden = !isHighThumbVisible
        }
    }

    /** Specifies the low thumb visibility  */
    public var isLowThumbVisible: Bool = true {
        didSet {
            radialGaugeRenderer.lowThumbLayer.isHidden = !isLowThumbVisible
        }
    }

    /** Specifies the indicator visibility  */
    public var isIndicatorVisible: Bool = true {
        didSet {
            radialGaugeRenderer.indicatorLayer.isHidden = !isIndicatorVisible
        }
    }

    /** Specifies the width in points of the tracks. Defaults to 15 */
    public var lineWidth: CGFloat {
        get { return radialGaugeRenderer.lineWidth }
        set { radialGaugeRenderer.lineWidth = newValue }
    }

    /** Specifies the width in points of the high thumb. Defaults to 10 */
    public var highThumbLineWidth: CGFloat {
        get { return radialGaugeRenderer.highThumbLineWidth }
        set { radialGaugeRenderer.highThumbLineWidth = newValue }
    }

    /** Specifies the width in points of the low thumb. Defaults to 10 */
    public var lowThumbLineWidth: CGFloat {
        get { return radialGaugeRenderer.lowThumbLineWidth }
        set { radialGaugeRenderer.lowThumbLineWidth = newValue }
    }

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

    /** Specifies the color of the high thumb. Defaults to white */
    public var highThumbColor: UIColor {
        get { return radialGaugeRenderer.highThumbColor }
        set { radialGaugeRenderer.highThumbColor = newValue }
    }

    /** Specifies the color of the low thumb. Defaults to white */
    public var lowThumbColor: UIColor {
        get { return radialGaugeRenderer.lowThumbColor }
        set { radialGaugeRenderer.lowThumbColor = newValue }
    }

    /** Specifies the color of the indicator. Defaults to white */
    public var indicatorColor: UIColor {
        get { return radialGaugeRenderer.indicatorColor }
        set { radialGaugeRenderer.indicatorColor = newValue }
    }

    /** Specifies the angle of the start of the control track. Defaults to -11π/8 */
    public var startAngle: CGFloat {
        get { return radialGaugeRenderer.startAngle }
        set { radialGaugeRenderer.startAngle = newValue }
    }

    /** Specifies the end angle of the knob control track. Defaults to 3π/8 */
    public var endAngle: CGFloat {
        get { return radialGaugeRenderer.endAngle }
        set { radialGaugeRenderer.endAngle = newValue }
    }

    /** Specifies the length in points of the high thumb. Defaults to 24 */
    public var highThumbLength: CGFloat {
        get { return radialGaugeRenderer.highThumbLength }
        set { radialGaugeRenderer.highThumbLength = newValue }
    }

    /** Specifies the length in points of the low thumb. Defaults to 24 */
    public var lowThumbLength: CGFloat {
        get { return radialGaugeRenderer.lowThumbLength }
        set { radialGaugeRenderer.lowThumbLength = newValue }
    }

    /** Specifies the length in points of the indicator. Defaults to 30 */
    public var indicatorLength: CGFloat {
        get { return radialGaugeRenderer.indicatorLength }
        set { radialGaugeRenderer.indicatorLength = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
        initializeValues()
        addGestureRecognizer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildViews()
        initializeValues()
        addGestureRecognizer()
    }

	public override func layoutSubviews() {
        super.layoutSubviews()
        radialGaugeRenderer.renderRadialGauge(insideBounds: bounds)
        if !gradientColors.isEmpty {
            setProgressTrackAsGradient()
        }
    }

    public func setMaximumValue(_ value: Decimal) {
        maximumValue = value
    }

    /**
     Sets the high thumb value.
     - parameter value: High thumb decimal value.
     - parameter animated: Defines if thumb update is animated.
     */
    func setHighThumbValue(_ value: Decimal, animated: Bool = false, isSliding: Bool = true) {
        let newAngleValue = queryThumbAngleValue(value)

        guard
            let newValue = queryValueInRange(
                value: value,
                minValue: highThumbMinimumValue,
                maxValue: highThumbMaximumValue),
            isNotOverflown(
                newAngleValue: newAngleValue,
                lastThumbAngle: highThumbAngleDeg,
                isThumbVisible: isHighThumbVisible)
        else {
            return
        }

        let movingHighThumbToLeft = value < highThumbValue
        let isMinimumThumbsDistanceReached = value < (lowThumbValue + deadband)
        let isLowButtonInRange = lowThumbValue > lowThumbMinimumValue
        if isMinimumThumbsDistanceReached && movingHighThumbToLeft && isLowThumbVisible && isLowButtonInRange {
            decrementTwoThumbs(isSliding: isSliding)
        } else if !isMinimumThumbsDistanceReached {
            setProgressTrackStrokeEnd(animated: animated, highThumbValue: newValue)
            radialGaugeRenderer.setThumbAngle(thumbType: .highThumb, newThumbAngle: newAngleValue)
            highThumbValue = newValue
        }
    }

    /**
     Increment high thumb value.
     - parameter animated: Defines if thumb update is animated.
     */
    public func incrementHighThumbValue(animated: Bool = false) {
        let incrementedValue = highThumbValue + highThumbStepSize
        setHighThumbValue(incrementedValue, animated: animated, isSliding: false)
    }

    /**
     Decrement high thumb value.
     - parameter animated: Defines if thumb update is animated.
     */
    public func decrementHighThumbValue(animated: Bool = false) {
        let decrementedValue = highThumbValue - highThumbStepSize
        setHighThumbValue(decrementedValue, animated: animated, isSliding: false)
    }

    /**
     Sets the low thumb value.
     - parameter value: Low thumb decimal value.
     - parameter animated: Defines if thumb update is animated.
     */
    func setLowThumbValue(_ value: Decimal, animated: Bool = false, isSliding: Bool = true) {
        let newAngleValue = queryThumbAngleValue(value)

        guard
            let newValue = queryValueInRange(
                value: value,
                minValue: lowThumbMinimumValue,
                maxValue: lowThumbMaximumValue),
            isNotOverflown(
                newAngleValue: newAngleValue,
                lastThumbAngle: lowThumbAngleDeg,
                isThumbVisible: isLowThumbVisible)
        else {
            return
        }

        let movingLowThumbToRight = value > lowThumbValue
        let isMinimumThumbsDistanceReached = value > (highThumbValue - deadband)
        let isHighButtonInRange = highThumbValue < highThumbMaximumValue
        if isMinimumThumbsDistanceReached && movingLowThumbToRight && isHighButtonInRange {
            incrementTwoThumbs(isSliding: isSliding)
        } else if !isMinimumThumbsDistanceReached {
            setProgressTrackStrokeStart(animated: animated, lowThumbValue: newValue)
            radialGaugeRenderer.setThumbAngle(thumbType: .lowThumb, newThumbAngle: newAngleValue)
            lowThumbValue = newValue
        }
    }

    public func handleThumbValue(value: Decimal, thumbType: RadialGaugeThumbType) {
        if thumbType == .highThumb {
            if value < lowThumbValue + deadband { return }
            var highValue = value
            if value <= highThumbMinimumValue { highValue = highThumbMinimumValue }
            if value > maximumValue { highValue = maximumValue }
            let highThumbAngleValue = queryThumbAngleValue(highValue)
            setProgressTrackStrokeEnd(animated: false, highThumbValue: highValue)
            radialGaugeRenderer.setThumbAngle(thumbType: .highThumb, newThumbAngle: highThumbAngleValue)
            highThumbValue = highValue
        } else {
            if value > highThumbValue - deadband { return }
            var lowValue = value
            if value < minimumValue { lowValue = minimumValue }
            if value >= lowThumbMaximumValue { lowValue = lowThumbMaximumValue  }
            let lowThumbAngleValue = queryThumbAngleValue(lowValue)
            setProgressTrackStrokeStart(animated: false, lowThumbValue: lowValue)
            radialGaugeRenderer.setThumbAngle(thumbType: .lowThumb, newThumbAngle: lowThumbAngleValue)
            lowThumbValue = lowValue
        }
    }

    /**
     Increment low thumb value.
     - parameter animated: Defines if thumb update is animated.
     */
    func incrementLowThumbValue(animated: Bool = false) {
        let incrementedValue = lowThumbValue + lowThumbStepSize
        setLowThumbValue(incrementedValue, animated: animated, isSliding: false)
    }

    /**
     Decrement low thumb value.
     - parameter animated: Defines if thumb update is animated.
     */
    func decrementLowThumbValue(animated: Bool = false) {
        let decrementedValue = lowThumbValue - lowThumbStepSize
        setLowThumbValue(decrementedValue, animated: animated, isSliding: false)
    }

    /**
     Sets the indicator value
     - parameter value: value of indicator.
     - parameter animated: Defines if indicator update is animated.
     */
    public func setIndicatorValue(_ newValue: Decimal, animated: Bool = false) {
        indicatorValue = min(maximumValue, max(minimumValue, newValue))
        let angleValue = queryThumbAngleValue(indicatorValue)
        radialGaugeRenderer.setIndicatorAngle(angleValue)
    }

    /**
     Sets the controls visibility except background track.
     - parameter value: Show all controls
     */
    public func showAllControls(_ show: Bool) {
        isProgressLayerVisible = show
        isIndicatorVisible = show
        showAllThumbs(show)
    }

    /**
     Sets the thumbs visibility.
     - parameter value: Show all thumbs.
     */
    public func showAllThumbs(_ show: Bool) {
        isLowThumbVisible = show
        isHighThumbVisible = show
    }

    func sliderThumbEnd() {
        delegate?.highThumbSliderEnd(value: highThumbValue)
        if isLowThumbVisible {
            delegate?.lowThumbSliderEnd(value: lowThumbValue)
        }
    }

    func gaugeInteraction(interactionType: InteractionType) {
        delegate?.gaugeInteraction(interactionType: interactionType)
    }

	private func incrementTwoThumbs(isSliding: Bool) {
		guard dualMoveEnabled else { return }
		let highThumbIncrementedValue = highThumbValue + lowThumbStepSize
		handleThumbValue(value: highThumbIncrementedValue, thumbType: .highThumb)

		let lowThumbIncrementedValue = lowThumbValue + lowThumbStepSize
		handleThumbValue(value: lowThumbIncrementedValue, thumbType: .lowThumb)

		if !isSliding {
			delegate?.gaugeInteraction(interactionType: .start)
			sliderThumbEnd()
			delegate?.gaugeInteraction(interactionType: .end)
		}
	}

	private func decrementTwoThumbs(isSliding: Bool) {
		guard dualMoveEnabled else { return }
		let lowThumbDecrementedValue = lowThumbValue - highThumbStepSize
		handleThumbValue(value: lowThumbDecrementedValue, thumbType: .lowThumb)

		let hightThumbDecrementedValue = highThumbValue - highThumbStepSize
		handleThumbValue(value: hightThumbDecrementedValue, thumbType: .highThumb)

		if !isSliding {
			delegate?.gaugeInteraction(interactionType: .start)
			sliderThumbEnd()
			delegate?.gaugeInteraction(interactionType: .end)
		}
	}

    private func setProgressTrackAsGradient() {
        gaugeViewWithGradient.isHidden = false
        let image = RadialGradientWithDotImageView.getCircularGradientImage(
            gradientColors: gradientColors,
            size: CGSize(width: frame.width, height: frame.height),
            numberOfColors: Int(gaugeSpread))

        radialGradient.image = image

        radialGaugeRenderer.progressTrackLayer.removeFromSuperlayer()
        gaugeViewWithGradient.layer.mask = radialGaugeRenderer.progressTrackLayer
    }

    private func queryValueInRange(value: Decimal, minValue: Decimal, maxValue: Decimal) -> Decimal? {
        if value <= maxValue && value >= minValue {
            return value
        }
        return nil
    }

    private func queryThumbAngleValue(_ value: Decimal) -> Decimal {
        return (value - minimumValue) / valueRange * Decimal(Double(angleRange)) + Decimal(Double(startAngle))
    }

    private func initializeValues() {
		handleThumbValue(value: 0, thumbType: .highThumb)
		handleThumbValue(value: 0, thumbType: .lowThumb)
        indicatorValue = maximumValue / minimumValue
        radialGaugeRenderer.setThumbAngle(thumbType: .highThumb, newThumbAngle: Decimal(Double(endAngle)))
        radialGaugeRenderer.setThumbAngle(thumbType: .lowThumb, newThumbAngle: Decimal(Double(startAngle)))
		highThumbStepSize = 10
		lowThumbStepSize = 10
    }

    private func thumbAngleDeg(_ thumbAngleRad: CGFloat) -> Int {
        let angle = radiansToDegrees(radians: thumbAngleRad)
        let startAngle = radiansToDegrees(radians: -radialGaugeRenderer.startAngle).rounded(.down)
        return Int(angle + startAngle) - 1
    }


	private func isNotOverflown(newAngleValue: Decimal, lastThumbAngle: Int, isThumbVisible: Bool) -> Bool {
		guard isThumbVisible else { return true }
		let newThumbAngle = thumbAngleDeg(CGFloat(truncating: newAngleValue as NSNumber))
		return abs(lastThumbAngle - newThumbAngle) <= 180
	}

}
