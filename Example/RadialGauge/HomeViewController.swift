import UIKit
import RadialGauge

class HomeViewController: UIViewController {

	var radialGauge: SimpleRadialGauge!

	override func viewDidLoad() {
		super.viewDidLoad()
		buildViews()
		setRadialGaugeValues()
	}

	func setRadialGaugeValues() {
		radialGauge.setProgressTrackValue(50)
		radialGauge.setValue(50)
	}

}
