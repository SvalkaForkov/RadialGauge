public protocol RadialGaugeDelegate: class {

    /**
     Called when high thumb value is changed.
     - parameter value: New high thumb value.
     */
    func highThumbValueChanged(value: Decimal)

    /**
     Called when low thumb value is changed.
     - parameter value: New low thumb value.
     */
    func lowThumbValueChanged(value: Decimal)

	/**
	Called when indicator value is changed.
	- parameter value: New indicator value.
	*/
	func indicatorValueChanged(value: Decimal)
    /**
     Called when slider touches end.
     - parameter value: New high thumb value.
     */
    func highThumbSliderEnd(value: Decimal)

    /**
     Called when slider touches end.
     - parameter value: New low thumb value.
     */
    func lowThumbSliderEnd(value: Decimal)

    /**
     Called on changed slider interaction.
     - parameter value: Current slider interaction type.
     */
    func gaugeInteraction(interactionType: InteractionType)

}
