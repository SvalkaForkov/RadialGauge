import UIKit

extension CAShapeLayer {

	func dropShadow(
		color: UIColor = .gray,
		offSet: CGSize = CGSize(width: 0, height: 5),
		radius: CGFloat = 22,
		opacity: Float = 1
	) {
		shadowColor = color.cgColor
		shadowOpacity = opacity
		shadowOffset = offSet
		shadowRadius = radius
		shouldRasterize = true
		rasterizationScale = UIScreen.main.scale
	}

}
