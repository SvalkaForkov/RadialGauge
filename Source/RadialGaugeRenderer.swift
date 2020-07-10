import UIKit

class RadialGaugeRenderer {

    let backgroundTrackLayer = CAShapeLayer()
    let progressTrackLayer = CAShapeLayer()
    let highThumbLayer = CAShapeLayer()
    let lowThumbLayer = CAShapeLayer()
    let indicatorLayer = CAShapeLayer()

    private (set) var highThumbAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8
    private (set) var lowThumbAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8
    private (set) var indicatorAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8

    private var backgroundTrackLayerCenter: CGFloat {
        return backgroundTrackLayer.bounds.width - offset / 2 - lineWidth / 2
    }

    var alphaValue: Float = 1 {
        didSet {
            backgroundTrackLayer.opacity = alphaValue
            backgroundTrackLayer.opacity = alphaValue
            progressTrackLayer.opacity = alphaValue
            highThumbLayer.opacity = alphaValue
            lowThumbLayer.opacity = alphaValue
        }
    }

    var offset: CGFloat {
        let thumbLength = max(highThumbLength, lowThumbLength)
        return max(thumbLength / 2, lineWidth / 2)
    }

    var backgroundTrackColor: UIColor = .lightGray {
        didSet {
            setBackgroundTrackStrokeColor()
        }
    }

    var progressTrackColor: UIColor = .blue {
        didSet {
            setProgressTrackStrokeColor()
        }
    }

    var radius: CGFloat {
        let bounds = backgroundTrackLayer.bounds
        return min(bounds.width, bounds.height) / 2 - offset
    }

    var highThumbColor: UIColor = .white {
        didSet {
            setHighThumbStrokeColor()
        }
    }

    var lowThumbColor: UIColor = .white {
        didSet {
            setLowThumbStrokeColor()
        }
    }

    var indicatorColor: UIColor = .black {
        didSet {
            setIndicatorStrokeColor()
        }
    }

    var lineWidth: CGFloat = 15 {
        didSet {
            setBackgroundTrackLineWidth()
            setProgressTrackLineWidth()
            updateIndicatorLayerPath()
        }
    }

    var startAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8 {
        didSet {
            updateTrackLayers()
        }
    }

    var endAngle: CGFloat = CGFloat(Double.pi) * 3 / 8 {
        didSet {
            updateTrackLayers()
        }
    }

    public var highThumbLength: CGFloat = 24 {
        didSet {
            updateTrackLayers()
            updateThumbLayerPath(thumbLayer: highThumbLayer, lineWidth: highThumbLineWidth)
        }
    }

    public var lowThumbLength: CGFloat = 24 {
        didSet {
            updateTrackLayers()
            updateThumbLayerPath(thumbLayer: lowThumbLayer, lineWidth: lowThumbLineWidth)
        }
    }

    public var indicatorLength: CGFloat = 30 {
        didSet {
            updateIndicatorLayerPath()
        }
    }

    var highThumbLineWidth: CGFloat = 10 {
        didSet {
            updateThumbLayerPath(thumbLayer: highThumbLayer, lineWidth: highThumbLineWidth)
        }
    }

    var lowThumbLineWidth: CGFloat = 10 {
        didSet {
            updateThumbLayerPath(thumbLayer: lowThumbLayer, lineWidth: lowThumbLineWidth)
        }
    }

    var indicatorLineWidth: CGFloat = 10 {
        didSet {
            updateIndicatorLayerPath()
        }
    }

    init() {
        styleLayers()
    }

    func renderRadialGauge(insideBounds bounds: CGRect) {
        updateBounds(bounds)
        updateTrackLayers()
        updateIndicatorLayerPath()
        updateThumbLayerPath(thumbLayer: lowThumbLayer, lineWidth: lowThumbLineWidth)
        updateThumbLayerPath(thumbLayer: highThumbLayer, lineWidth: highThumbLineWidth)
    }

    func setThumbAngle(
        thumbType: RadialGaugeThumbType,
        newThumbAngle: Decimal,
        animated: Bool = false
    ) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        let newFloatThumbAngle = CGFloat(truncating: newThumbAngle as NSNumber)
        let thumbLayer: CAShapeLayer
        let thumbAngle: CGFloat
        switch thumbType {
        case .highThumb:
            thumbLayer = highThumbLayer
            thumbAngle = highThumbAngle
			highThumbAngle = CGFloat(truncating: newFloatThumbAngle as NSNumber)
        case .lowThumb:
            thumbLayer = lowThumbLayer
            thumbAngle = lowThumbAngle
            lowThumbAngle = newFloatThumbAngle
        }

        thumbLayer.transform = CATransform3DMakeRotation(newFloatThumbAngle, 0, 0, 1)
        if animated {
            animateThumb(
                thumbLayer: thumbLayer,
                newThumbAngle: newFloatThumbAngle,
                thumbAngle: thumbAngle)
        }

        CATransaction.commit()
    }

    func setIndicatorAngle(
        _ newPointerAngle: Decimal,
        animated: Bool = false
    ) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let newPointerFloatAngle = CGFloat(truncating: newPointerAngle as NSNumber)

        indicatorLayer.transform = CATransform3DMakeRotation(newPointerFloatAngle, 0, 0, 1)

        if animated {
            animateThumb(thumbLayer: indicatorLayer, newThumbAngle: newPointerFloatAngle, thumbAngle: indicatorAngle)
        }

        CATransaction.commit()
        indicatorAngle = newPointerFloatAngle
    }

    private func animateThumb(
        thumbLayer: CAShapeLayer,
        newThumbAngle: CGFloat,
        thumbAngle: CGFloat
    ) {
        let minThumbAngle = min(newThumbAngle, thumbAngle)
        let maxThumbAngle = max(newThumbAngle, thumbAngle)
        let midAngle = (maxThumbAngle - minThumbAngle) / 2 + minThumbAngle
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.values = [thumbAngle, midAngle, newThumbAngle]
        animation.keyTimes = [0.0, 0.5, 1.0]
        animation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)]
        thumbLayer.add(animation, forKey: nil)
    }

    private func updateLayerPath(layer: CAShapeLayer) {
        let bounds = layer.bounds
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        let ring = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        layer.setNeedsLayout()

        layer.path = ring.cgPath
    }

    private func updateThumbLayerPath(thumbLayer: CAShapeLayer, lineWidth: CGFloat) {
        let bounds = backgroundTrackLayer.bounds

        let pointer = UIBezierPath(ovalIn: CGRect(
            x: bounds.width - highThumbLength / 2 - offset,
            y: bounds.midY - highThumbLength / 2,
            width: highThumbLength,
            height: highThumbLength))

        thumbLayer.path = pointer.cgPath
        thumbLayer.lineWidth = lineWidth
    }

    private func updateIndicatorLayerPath() {
        let bounds = backgroundTrackLayer.bounds

        let firstLinePoint = bounds.width - indicatorLength / 2 - offset
        let secondLinePoint = firstLinePoint + indicatorLength
        let pointer = UIBezierPath()
        pointer.move(to: CGPoint(
            x: firstLinePoint,
            y: bounds.midY))
        pointer.addLine(to: CGPoint(x: secondLinePoint, y: bounds.midY))
        indicatorLayer.path = pointer.cgPath
    }

    private func updateTrackLayers() {
        updateLayerPath(layer: backgroundTrackLayer)
        updateLayerPath(layer: progressTrackLayer)
    }

    private func styleLayers() {
        backgroundTrackLayer.fillColor = UIColor.clear.cgColor
        progressTrackLayer.fillColor = UIColor.clear.cgColor
        highThumbLayer.fillColor = UIColor.clear.cgColor
        lowThumbLayer.fillColor = UIColor.clear.cgColor
        indicatorLayer.fillColor = UIColor.clear.cgColor
        highThumbLayer.zPosition = 2
        lowThumbLayer.zPosition = 2
        indicatorLayer.zPosition = 1
        backgroundTrackLayer.lineCap = .round
        progressTrackLayer.lineCap = .round

        setBackgroundTrackStrokeColor()
        setProgressTrackStrokeColor()
        setHighThumbStrokeColor()
        setLowThumbStrokeColor()
        setIndicatorStrokeColor()
        setBackgroundTrackLineWidth()
        setProgressTrackLineWidth()
    }

    private func setBackgroundTrackStrokeColor() {
        backgroundTrackLayer.strokeColor = backgroundTrackColor.cgColor
    }

    private func setProgressTrackStrokeColor() {
        progressTrackLayer.strokeColor = progressTrackColor.cgColor
    }

    private func setHighThumbStrokeColor() {
        highThumbLayer.strokeColor = highThumbColor.cgColor
    }

    private func setLowThumbStrokeColor() {
        lowThumbLayer.strokeColor = lowThumbColor.cgColor
    }

    private func setIndicatorStrokeColor() {
        indicatorLayer.strokeColor = indicatorColor.cgColor
    }

    private func setBackgroundTrackLineWidth() {
        backgroundTrackLayer.lineWidth = lineWidth
    }

    private func setProgressTrackLineWidth() {
        progressTrackLayer.lineWidth = lineWidth
    }

    private func updateBounds(_ bounds: CGRect) {
        backgroundTrackLayer.bounds = bounds
        backgroundTrackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)

        progressTrackLayer.bounds = bounds
        progressTrackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)

        updateTrackLayers()

        highThumbLayer.bounds = backgroundTrackLayer.bounds
        highThumbLayer.position = backgroundTrackLayer.position
        updateThumbLayerPath(thumbLayer: highThumbLayer, lineWidth: highThumbLineWidth)

        lowThumbLayer.bounds = backgroundTrackLayer.bounds
        lowThumbLayer.position = backgroundTrackLayer.position
        updateThumbLayerPath(thumbLayer: lowThumbLayer, lineWidth: lowThumbLineWidth)

        indicatorLayer.bounds = backgroundTrackLayer.bounds
        indicatorLayer.position = backgroundTrackLayer.position
        updateIndicatorLayerPath()
    }

}
