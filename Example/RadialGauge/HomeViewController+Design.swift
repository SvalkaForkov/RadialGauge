import UIKit
import RadialGauge

extension HomeViewController {

	func buildViews() {
		createViews()
		styleViews()
		defineLayoutForViews()
	}

	func createViews() {
		titleLabel = UILabel()
		view.addSubview(titleLabel)

		descriptionLabel = UILabel()
		view.addSubview(descriptionLabel)

		layout = UICollectionViewFlowLayout()

		pageControl = UIPageControl()
		view.addSubview(pageControl)

		collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		view.addSubview(collectionView)
	}

	func styleViews() {
		titleLabel.textColor = .white
		titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
		descriptionLabel.textColor = .white

		descriptionLabel.numberOfLines = 0

		let gradient = CAGradientLayer()

		gradient.frame = view.bounds
		gradient.colors = AppColors.gradientColors

		view.layer.insertSublayer(gradient, at: 0)

		collectionView.backgroundColor = .clear
		collectionView.showsHorizontalScrollIndicator = false

		layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
		layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
		layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
		layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)
		layout.minimumLineSpacing = itemSpacing
		layout.scrollDirection = .horizontal

		pageControl.currentPage = 0
	}

	func defineLayoutForViews() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sectionInset + itemSpacing).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .gutter()).isActive = true
		descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sectionInset + itemSpacing).isActive = true
		descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		collectionView.heightAnchor.constraint(equalToConstant: itemHeight + 60).isActive = true

		pageControl.translatesAutoresizingMaskIntoConstraints = false
		pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		pageControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
		pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
		pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
		
	}

}
