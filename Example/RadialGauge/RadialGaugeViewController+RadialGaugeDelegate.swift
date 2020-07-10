import RadialGauge

extension RadialGaugeViewController: RadialGaugeDelegate {

	func highThumbValueChanged(value: Decimal) {
		highThumbTitleLabel.text = "High thumb value: \(value)"
	}

	func lowThumbValueChanged(value: Decimal) {
		lowThumbTitleLabel.text = "Low thumb value: \(value)"
	}

	func indicatorValueChanged(value: Decimal) {}

	func highThumbSliderEnd(value: Decimal) {}

	func lowThumbSliderEnd(value: Decimal) {}

	func gaugeInteraction(interactionType: InteractionType) {}

	
}
