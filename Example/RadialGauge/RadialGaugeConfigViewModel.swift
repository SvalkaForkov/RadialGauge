import RadialGauge

struct RadialGaugeConfigViewModel {

	var isLowThumbVisible: Bool {
		if let lowThumbViewModel = lowThumbViewModel {
			return lowThumbViewModel.isThumbVisible
		}
		return false
	}

	var isHighThumbVisible: Bool {
		if let highThumbViewModel = highThumbViewModel {
			return highThumbViewModel.isThumbVisible
		}
		return false
	}

	var isIndicatorVisible: Bool {
		return indicatorValue != nil
	}

	var shouldAnimateValue: Bool
	var progressLayerColor: UIColor?
	var progressLayerGradient: [GradientComponents]
	var backgroundLayerColor: UIColor
	var lowThumbViewModel: RadialGaugeThumbViewModel?
	var highThumbViewModel: RadialGaugeThumbViewModel?
	var stepSize: Decimal
	var indicatorValue: Decimal?

}
