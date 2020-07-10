import UIKit

extension ContainerCell {

	func buildViews() {
		createViews()
		styleViews()
	}

	func createViews() {
		container = UIView()
		addSubview(container)
	}

	func styleViews() {
		contentView.translatesAutoresizingMaskIntoConstraints = false
		container.clipsToBounds = true
		clipsToBounds = false

		backgroundColor = .clear
		layer.masksToBounds = false
		layer.shadowRadius = 8
		layer.shadowOpacity = 0.5
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0 , height:8)

		contentView.backgroundColor = .white
		contentView.layer.cornerRadius = 8
	}

	func defineLayoutForViews() {
		guard superview != nil else {
			return
		}
		contentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.autoPinEdgesToSuperviewEdges()

		container.translatesAutoresizingMaskIntoConstraints = false
		container.autoPinEdgesToSuperviewEdges()

		hostedView.translatesAutoresizingMaskIntoConstraints = false
		hostedView.autoPinEdgesToSuperviewEdges()
	}

}
