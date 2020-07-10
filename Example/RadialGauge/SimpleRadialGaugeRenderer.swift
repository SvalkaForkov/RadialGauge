import UIKit

class SimpleRadialGaugeRenderer {

	let backgroundTrackLayer = CAShapeLayer()
	let progressTrackLayer = CAShapeLayer()
	let thumbLayer = CAShapeLayer()

	var radius: CGFloat = 100
	var startAngle: CGFloat = -CGFloat(245).toRadians()
	var endAngle: CGFloat = CGFloat(65).toRadians()

//	private (set) var thumbAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8

	private var offset: CGFloat {
		return max(thumbLength, lineWidth)
	}

	var backgroundTrackColor: UIColor = .gray {
		didSet {
			setBackgroundTrackStrokeColor()
		}
	}

	var progressTrackColor: UIColor = .blue {
		didSet {
			setProgressTrackStrokeColor()
		}
	}

	var lineWidth: CGFloat = 15 {
		didSet {
			setBackgroundTrackLineWidth()
			setProgressTrackLineWidth()
		}
	}

	var thumbLineWidth: CGFloat = 10 {
		didSet {
			updateThumbLayerPath(thumbLayer: thumbLayer, lineWidth: thumbLineWidth)
		}
	}

	var thumbLength: CGFloat = 24 {
		didSet {
			updateThumbLayerPath(thumbLayer: thumbLayer, lineWidth: thumbLineWidth)
		}
	}

	var thumbLayerColor: UIColor = .white {
		didSet {
			setThumbStrokeColor()
		}
	}

	init() {
		styleLayers()
	}

	private func styleLayers() {
		setThumbStrokeColor()
		thumbLayer.fillColor = UIColor.clear.cgColor

		setCommonTracksStyle(layer: backgroundTrackLayer)
		setCommonTracksStyle(layer: progressTrackLayer)
		setBackgroundTrackStrokeColor()
		setProgressTrackStrokeColor()
		setBackgroundTrackLineWidth()
		setProgressTrackLineWidth()
	}

	func updateTrackLayers() {
		updateLayerPath(layer: backgroundTrackLayer)
		updateLayerPath(layer: progressTrackLayer)
	}

	func renderRadialGauge(insideBounds bounds: CGRect) {
		backgroundTrackLayer.bounds = bounds
		backgroundTrackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)

		progressTrackLayer.bounds = bounds
		progressTrackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)

		updateTrackLayers()

		thumbLayer.bounds = bounds
		thumbLayer.position = backgroundTrackLayer.position
		updateThumbLayerPath(thumbLayer: thumbLayer, lineWidth: thumbLineWidth)
	}

	func setThumbAngle(_ newThumbAngle: Decimal) {
		CATransaction.begin()
		CATransaction.setDisableActions(true)

		let thumbAngle = CGFloat(truncating: newThumbAngle as NSNumber)
		thumbLayer.transform = CATransform3DMakeRotation(thumbAngle, 0, 0, 1)

		CATransaction.commit()
	}

	private func setCommonTracksStyle(layer: CAShapeLayer) {
		layer.fillColor = UIColor.clear.cgColor
		layer.lineCap = .round
	}

	private func updateThumbLayerPath(thumbLayer: CAShapeLayer, lineWidth: CGFloat) {
		let bounds = backgroundTrackLayer.bounds

		let pointer = UIBezierPath(ovalIn: CGRect(
			x: bounds.width - thumbLength / 2 - thumbLength,
			y: bounds.midY - thumbLength / 2,
			width: thumbLength,
			height: thumbLength))

		thumbLayer.path = pointer.cgPath
		thumbLayer.lineWidth = lineWidth
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

	private func setBackgroundTrackStrokeColor() {
		backgroundTrackLayer.strokeColor = backgroundTrackColor.cgColor
	}
	

	private func setProgressTrackStrokeColor() {
		progressTrackLayer.strokeColor = progressTrackColor.cgColor
	}

	private func setBackgroundTrackLineWidth() {
		backgroundTrackLayer.lineWidth = lineWidth
	}

	private func setProgressTrackLineWidth() {
		progressTrackLayer.lineWidth = lineWidth
	}

	private func setThumbStrokeColor() {
		thumbLayer.strokeColor = thumbLayerColor.cgColor
	}

}
