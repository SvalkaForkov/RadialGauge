import UIKit

extension RadialGauge {

    func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }

    func createViews() {
		radialGaugeRenderer = RadialGaugeRenderer()

        layer.addSublayer(radialGaugeRenderer.backgroundTrackLayer)
        layer.addSublayer(radialGaugeRenderer.progressTrackLayer)
        layer.addSublayer(radialGaugeRenderer.indicatorLayer)
        layer.addSublayer(radialGaugeRenderer.highThumbLayer)
        layer.addSublayer(radialGaugeRenderer.lowThumbLayer)

        gaugeViewWithGradient = UIView()
        addSubview(gaugeViewWithGradient)

        radialGradient = RadialGradientWithDotImageView()
        gaugeViewWithGradient.addSubview(radialGradient)
    }

    func styleViews() {
        radialGaugeRenderer.highThumbLayer.dropRadialGaugeShadow()
        radialGaugeRenderer.lowThumbLayer.dropRadialGaugeShadow()
        gaugeViewWithGradient.isHidden = true
        gaugeViewWithGradient.transform = CGAffineTransform(rotationAngle: degreesToRadians(degrees: 0))
        radialGradient.transform = CGAffineTransform(rotationAngle: degreesToRadians(degrees: 100))
    }

    func defineLayoutForViews() {
		gaugeViewWithGradient.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			gaugeViewWithGradient.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			gaugeViewWithGradient.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			gaugeViewWithGradient.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			gaugeViewWithGradient.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
		])

		radialGradient.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			radialGradient.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			radialGradient.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			radialGradient.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			radialGradient.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
		])
    }

}
