import UIKit

extension CAShapeLayer {

	func dropRadialGaugeShadow(
		color: UIColor = .gray,
		offSet: CGSize = CGSize(width: 0, height: 5),
		radius: CGFloat = 22,
		opacity: Float = 1
	) {
		dropShadow(color: color, offSet: offSet, radius: radius, opacity: opacity)
	}

	private func dropShadow(
		color: UIColor,
		offSet: CGSize,
		radius: CGFloat,
		opacity: Float
	) {
		shadowColor = color.cgColor
		shadowOpacity = opacity
		shadowOffset = offSet
		shadowRadius = radius
		shouldRasterize = true
		rasterizationScale = UIScreen.main.scale
	}

}
