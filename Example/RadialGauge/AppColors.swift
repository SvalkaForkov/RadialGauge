import UIKit
import RadialGauge

class AppColors {

	static var gradientColors: [CGColor] {
		return [
			UIColor(rgb: 0xeeb063).cgColor,
			UIColor(rgb: 0xe98e6a).cgColor,
			UIColor(rgb: 0xdf6773).cgColor
		]
	}

	static var gradientComponents = [
		GradientComponents(color: UIColor.white, percentage: 0.0),
		GradientComponents(color: UIColor(rgb: 0xeeb063), percentage: 25.0),
		GradientComponents(color: UIColor(rgb: 0xe98e6a), percentage: 25.0),
		GradientComponents(color: UIColor(rgb: 0xdf6773), percentage: 25.0)
	]

}
