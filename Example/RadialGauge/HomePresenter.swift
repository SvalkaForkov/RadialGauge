import UIKit

class HomePresenter {

	var viewModels: [RadialGaugeViewModel] {
		return [
			RadialGaugeViewModel(title: "Radial Gauge - Dual mode",
								 description: "Indicator value: 50\nLow thumb max value: 50\nLow thumb min value: 0\nHigh thumb max value: 100\nHigh thumb min value: 0",
								 radialGaugeConfigViewModel: RadialGaugeConfigViewModel(
									 shouldAnimateValue: false,
									 progressLayerColor: nil,
									 progressLayerGradient: AppColors.gradientComponents,
									 backgroundLayerColor: UIColor(rgb: 0xf3f3fa),
									 lowThumbViewModel: RadialGaugeThumbViewModel(
										 maxValue: 50,
										 minValue: 0,
										 value: 35,
										 isThumbVisible: true),
									 highThumbViewModel: RadialGaugeThumbViewModel(
										maxValue: 100,
										minValue: 0,
										value: 35,
										isThumbVisible: true),
									stepSize: 1,
									indicatorValue: 50
									)
			),
			RadialGaugeViewModel(title: "Radial Gauge - Single mode",
								 description: "Indicator value: 50\nThumb max value: 50\nThumb min value: 0",
								 radialGaugeConfigViewModel: RadialGaugeConfigViewModel(
									 shouldAnimateValue: false,
									 progressLayerColor: UIColor(rgb: 0xdf6773),
									 progressLayerGradient: [],
									 backgroundLayerColor: UIColor(rgb: 0xf3f3fa),
									 lowThumbViewModel: nil,
									 highThumbViewModel: RadialGaugeThumbViewModel(
										maxValue: 50,
										minValue: 0,
										value: 35,
										isThumbVisible: true),
									 stepSize: 1,
									 indicatorValue: 60
				)
			),
			RadialGaugeViewModel(title: "Radial Gauge - Progress",
								 description: "Thumb max value: 100\nThumb min value: 0",
								 radialGaugeConfigViewModel: RadialGaugeConfigViewModel(
									shouldAnimateValue: true,
									progressLayerColor: UIColor(rgb: 0xdf6773),
									progressLayerGradient: [],
									backgroundLayerColor: UIColor(rgb: 0xf3f3fa),
									lowThumbViewModel: nil,
									highThumbViewModel: RadialGaugeThumbViewModel(
										maxValue: 100,
										minValue: 0,
										value: 35,
										isThumbVisible: false),
									stepSize: 1,
									indicatorValue: nil
				)
			)
		]
	}

}
