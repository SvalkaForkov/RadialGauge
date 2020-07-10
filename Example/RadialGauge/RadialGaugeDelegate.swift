import UIKit

public protocol RadialGaugeDelegate: class {

	/**
	Called when thumb value is changed.
	- parameter value: New thumb value.
	*/
	func thumbValueChanged(value: Decimal)

}
