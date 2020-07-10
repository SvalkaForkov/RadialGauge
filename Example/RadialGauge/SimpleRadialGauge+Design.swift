import UIKit

extension SimpleRadialGauge {

	func buildViews() {
		createViews()
		styleViews()
		defineLayoutForViews()
	}

	func createViews() {
		radialGaugeRenderer = RadialGaugeRenderer()
		layer.addSublayer(radialGaugeRenderer.backgroundTrackLayer)
		layer.addSublayer(radialGaugeRenderer.progressTrackLayer)
		layer.addSublayer(radialGaugeRenderer.thumbLayer)
	}

	func styleViews() {
		radialGaugeRenderer.thumbLayer.dropRadialGaugeShadow()
	}

	func defineLayoutForViews() {
		
	}

}
