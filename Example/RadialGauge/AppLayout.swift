import UIKit

extension CGFloat {

	static let defaultGutter: CGFloat = 10

	static func gutter(
		baseValue: CGFloat = defaultGutter,
		withMultiplier multiplier: CGFloat = 1.0,
		withOffset offset: CGFloat = 0
	) -> CGFloat {
		return (baseValue * multiplier) + offset
	}
}
