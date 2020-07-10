import RadialGauge

class RadialGaugeViewController: UIViewController {

	private var presenter: RadialGaugePresenter!
	var radialGauge: RadialGauge!

	var highThumbTitleLabel: UILabel!
	var lowThumbTitleLabel: UILabel!
	var highThumbLabel: UILabel!
	var lowThumbLabel: UILabel!
	var highThumbActions: UIStackView!
	var lowThumbActions: UIStackView!
	var firstHighThumbButton: ActualGradientButton!
	var secondHighThumbButton: ActualGradientButton!
	var firstLowThumbButton: ActualGradientButton!
	var secondLowThumbButton: ActualGradientButton!

	convenience init(presenter: RadialGaugePresenter) {
		self.init()
		self.presenter = presenter
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		buildViews()
		set()
    }

	private func set() {
		setColors()
		setValues()
		setButtons()
	}

	private func setColors() {
		let viewModel = presenter.viewModel
		if let progressLayerColor = viewModel.progressLayerColor {
			radialGauge.progressLayerColor = progressLayerColor
		} else if !viewModel.progressLayerGradient.isEmpty {
			radialGauge.gradientColors = viewModel.progressLayerGradient
		}

		radialGauge.backgroundTrackColor = viewModel.backgroundLayerColor
	}

	private func setValues() {
		let viewModel = presenter.viewModel
		if let lowThumbViewModel = viewModel.lowThumbViewModel {
			radialGauge.lowThumbMaximumValue = lowThumbViewModel.maxValue
			radialGauge.lowThumbMinimumValue = lowThumbViewModel.minValue
			radialGauge.handleThumbValue(value: lowThumbViewModel.value, thumbType: .lowThumb)
			radialGauge.lowThumbStepSize = viewModel.stepSize
			lowThumbTitleLabel.text = "Low thumb value: \(radialGauge.lowThumbValue)"
		}

		if let highThumbViewModel = viewModel.highThumbViewModel {
			radialGauge.highThumbMaximumValue = highThumbViewModel.maxValue
			radialGauge.highThumbMinimumValue = highThumbViewModel.minValue
			radialGauge.handleThumbValue(value: highThumbViewModel.value, thumbType: .highThumb)
			radialGauge.highThumbStepSize = viewModel.stepSize
			highThumbTitleLabel.text = "High thumb value: \(radialGauge.highThumbValue)"
		}

		if let indicatorValue = viewModel.indicatorValue {
			radialGauge.setIndicatorValue(indicatorValue)
		}

		radialGauge.isLowThumbVisible = viewModel.isLowThumbVisible
		radialGauge.isHighThumbVisible = viewModel.isHighThumbVisible
		radialGauge.isIndicatorVisible = viewModel.isIndicatorVisible
	}

	private func setButtons() {
		if !radialGauge.isLowThumbVisible && !radialGauge.isHighThumbVisible {
			firstHighThumbButton.setTitle("Animate down", for: .normal)
			secondHighThumbButton.setTitle("Animate Up", for: .normal)
			firstHighThumbButton.isHidden = false
			secondHighThumbButton.isHidden = false
			firstLowThumbButton.isHidden = !radialGauge.isLowThumbVisible
			secondLowThumbButton.isHidden = !radialGauge.isLowThumbVisible
		} else {
			firstLowThumbButton.isHidden = !radialGauge.isLowThumbVisible
			secondLowThumbButton.isHidden = !radialGauge.isLowThumbVisible

			firstHighThumbButton.isHidden = !radialGauge.isHighThumbVisible
			secondHighThumbButton.isHidden = !radialGauge.isHighThumbVisible
		}

//		firstHighThumbButton.isHidden = true
//		secondHighThumbButton.isHidden = true
//		firstLowThumbButton.isHidden = true
//		secondLowThumbButton.isHidden = true

	}

}
