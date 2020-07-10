import UIKit

extension UIView {

	func autoPinEdgesToSuperviewEdges() {
		guard let superview = self.superview else {
			return
		}
		leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
		trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
		topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
		bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
	}

	func removeSubviews() {
		subviews.forEach { $0.removeFromSuperview() }
	}

}
