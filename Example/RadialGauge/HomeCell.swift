//import UIKit
//import RadialGauge
//
//class HomeCell: UICollectionViewCell {
//
//	static let reuseIdentifier = "CollectionCell"
//
//	var radialGauge: RadialGauge!
//
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//		buildViews()
//	}
//
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//		buildViews()
//	}
//
//	func setup(viewModel: RadialGaugeViewModel) {
//		if let progressLayerColor = viewModel.progressLayerColor {
//			radialGauge.progressLayerColor = progressLayerColor
//		} else if !viewModel.progressLayerGradient.isEmpty {
//			radialGauge.gradientColors = viewModel.progressLayerGradient
//		}
//
//		radialGauge.backgroundTrackColor = viewModel.backgroundLayerColor
//	}
//
//	override func didMoveToSuperview() {
//		defineLayoutForViews()
//	}
//}
import UIKit

class ContainerCell: UICollectionViewCell {

	static let reuseIdentifier = String(describing: self)

	private let cellBorderRadius: CGFloat = 8
	var hostedView: UIView!
	var container: UIView!

	override init(frame: CGRect) {
		super.init(frame: frame)
		buildViews()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		buildViews()
	}

	func addHostedView(_ hostedView: UIView) {
		self.hostedView = hostedView
		container.addSubview(self.hostedView)
		defineLayoutForViews()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		container.removeSubviews()
	}

	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		defineLayoutForViews()
	}

}
