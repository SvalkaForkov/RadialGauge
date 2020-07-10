import UIKit

extension SimpleRadialGauge {

	func buildViews() {
		createViews()
		styleViews()
	}

	func createViews() {
		radialGaugeRenderer = SimpleRadialGaugeRenderer()
		layer.addSublayer(radialGaugeRenderer.backgroundTrackLayer)
		layer.addSublayer(radialGaugeRenderer.progressTrackLayer)
		layer.addSublayer(radialGaugeRenderer.thumbLayer)
	}

	func styleViews() {
		radialGaugeRenderer.thumbLayer.dropShadow()
	}

}
