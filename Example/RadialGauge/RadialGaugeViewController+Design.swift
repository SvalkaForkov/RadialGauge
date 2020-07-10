import UIKit
import RadialGauge

extension RadialGaugeViewController {

	func buildViews() {
		createViews()
		styleViews()
		defineLayoutForViews()
	}

	func createViews() {
		highThumbLabel = UILabel()
		lowThumbLabel = UILabel()

		highThumbActions = UIStackView()
		view.addSubview(highThumbActions)

		firstHighThumbButton = ActualGradientButton()
		firstHighThumbButton.setTitle("-", for: .normal)
		highThumbActions.addArrangedSubview(firstHighThumbButton)

		secondHighThumbButton = ActualGradientButton()
		secondHighThumbButton.setTitle("+", for: .normal)
		highThumbActions.addArrangedSubview(secondHighThumbButton)

		lowThumbActions = UIStackView()
		view.addSubview(lowThumbActions)

		firstLowThumbButton = ActualGradientButton()
		firstLowThumbButton.setTitle("-", for: .normal)
		lowThumbActions.addArrangedSubview(firstLowThumbButton)

		secondLowThumbButton = ActualGradientButton()
		secondLowThumbButton.setTitle("+", for: .normal)
		lowThumbActions.addArrangedSubview(secondLowThumbButton)

		radialGauge = RadialGauge()
		radialGauge.delegate = self
		view.addSubview(radialGauge)

		highThumbTitleLabel = UILabel()
		view.addSubview(highThumbTitleLabel)

		lowThumbTitleLabel = UILabel()
		view.addSubview(lowThumbTitleLabel)
	}

	func styleViews() {
		highThumbActions.axis = .horizontal
		highThumbActions.distribution = .fillEqually
		highThumbActions.alignment = .center
		highThumbActions.spacing = .gutter()

		lowThumbActions.axis = .horizontal
		lowThumbActions.distribution = .fillEqually
		lowThumbActions.alignment = .center
		lowThumbActions.spacing = .gutter()

		highThumbTitleLabel.textColor = UIColor(rgb: 0x6f6f7b)
		lowThumbTitleLabel.textColor = UIColor(rgb: 0x6f6f7b)
	}

	func defineLayoutForViews() {
		highThumbTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		highThumbTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .gutter(withMultiplier: 3)).isActive = true
		highThumbTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .gutter(withMultiplier: 3)).isActive = true
		highThumbTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: .gutter(withMultiplier: 2)).isActive = true

		lowThumbTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		lowThumbTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .gutter(withMultiplier: 3)).isActive = true
		lowThumbTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .gutter(withMultiplier: 3)).isActive = true
		lowThumbTitleLabel.topAnchor.constraint(equalTo: highThumbTitleLabel.bottomAnchor, constant: .gutter()).isActive = true


		radialGauge.translatesAutoresizingMaskIntoConstraints = false
		radialGauge.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		radialGauge.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		radialGauge.heightAnchor.constraint(equalToConstant: 250).isActive = true
		radialGauge.widthAnchor.constraint(equalToConstant: 250).isActive = true

		highThumbActions.translatesAutoresizingMaskIntoConstraints = false
		highThumbActions.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.gutter()).isActive = true
		highThumbActions.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .gutter()).isActive = true
		highThumbActions.bottomAnchor.constraint(equalTo: lowThumbActions.topAnchor, constant: -.gutter()).isActive = true

		lowThumbActions.translatesAutoresizingMaskIntoConstraints = false
		lowThumbActions.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.gutter()).isActive = true
		lowThumbActions.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .gutter()).isActive = true
		lowThumbActions.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.gutter()).isActive = true
	}

}

import UIKit
class ActualGradientButton: UIButton {

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		styleViews()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		styleViews()
	}

	func styleViews() {

		setTitleColor(UIColor(rgb: 0x6f6f7b), for: .normal)
		backgroundColor = .white
		layer.masksToBounds = false
		layer.shadowRadius = 8
		layer.shadowOpacity = 0.5
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0, height: 8)

		alpha = 0.8
	}

}
