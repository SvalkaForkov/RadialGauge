import UIKit
import RadialGauge

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

	private var homePresenter: HomePresenter!
	var titleLabel: UILabel!
	var descriptionLabel: UILabel!

	var pageControl: UIPageControl!
	var collectionView: UICollectionView!
	var layout: UICollectionViewFlowLayout!
	let collectionMargin = CGFloat(16)
	let itemSpacing = CGFloat(20)

	var itemHeight: CGFloat {
		return UIScreen.main.bounds.height * 0.5
	}

	var itemWidth: CGFloat {
		return UIScreen.main.bounds.width * 0.74
	}

	var sectionInset: CGFloat {
		return (view.bounds.size.width - itemWidth - (itemSpacing * 2 - 8)) / 2
	}

	var currentItem = 0

	var viewModels: [RadialGaugeViewController] = []

	convenience init(homePresenter: HomePresenter) {
		self.init()
		self.homePresenter = homePresenter
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		initializeViewControllers()
		buildViews()
		setCollectionView()
		setCurrentInfo()
	}

	private func initializeViewControllers() {
		viewModels = homePresenter.viewModels
			.map { $0.radialGaugeConfigViewModel }
			.map { viewModel -> RadialGaugeViewController in
				let presenter = RadialGaugePresenter(viewModel: viewModel)
				return RadialGaugeViewController(presenter: presenter)
		}
	}

	private func setCollectionView() {
		collectionView.register(ContainerCell.self, forCellWithReuseIdentifier: ContainerCell.reuseIdentifier)
		collectionView.delegate = self
		collectionView.dataSource = self
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		self.pageControl.numberOfPages = viewModels.count
		return viewModels.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContainerCell.reuseIdentifier,
													  for: indexPath) as! ContainerCell

		cell.addHostedView(viewModels[indexPath.row].view)
		return cell
	}

	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

		let pageWidth = Float(itemWidth + itemSpacing)
		let targetXContentOffset = Float(targetContentOffset.pointee.x)
		let contentWidth = Float(collectionView!.contentSize.width  )
		var newPage = Float(self.pageControl.currentPage)

		if velocity.x == 0 {
			newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
		} else {
			newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
			if newPage < 0 {
				newPage = 0
			}
			if (newPage > contentWidth / pageWidth) {
				newPage = ceil(contentWidth / pageWidth) - 1.0
			}
		}

		pageControl.currentPage = Int(newPage)
		setCurrentInfo()

		let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
		targetContentOffset.pointee = point
	}

	private func setCurrentInfo() {
		if let viewModel = homePresenter.viewModels.at(pageControl.currentPage) {
			animateText(label: descriptionLabel, text: viewModel.description)
			animateText(label: titleLabel, text: viewModel.title)
		}
	}

	private func animateText(label: UILabel, text: String) {
		UIView.transition(with: label,
						  duration: 0.25,
						  options: .transitionCrossDissolve,
						  animations: {
							label.text = text
			})
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		let vc = RadialGaugeViewController(viewModel: viewModels[indexPath.row])
//		self.navigationController?.pushViewController(vc, animated: true)
	}

}
