import UIKit

extension HomeViewController {

	func buildViews() {
		createViews()
		styleViews()
		defineLayoutForViews()
	}

	func createViews() {
		radialGauge = SimpleRadialGauge()
		view.addSubview(radialGauge)
	}

	func styleViews() {
		view.backgroundColor = .white
		radialGauge.progressLayerColor = AppColors.progressTrackColor
		radialGauge.backgroundTrackColor = AppColors.backgroundTrackColor
	}

	func defineLayoutForViews() {
		radialGauge.translatesAutoresizingMaskIntoConstraints = false
		radialGauge.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		radialGauge.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		radialGauge.heightAnchor.constraint(equalToConstant: 250).isActive = true
		radialGauge.widthAnchor.constraint(equalToConstant: 250).isActive = true
	}

}
