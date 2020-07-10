public struct GradientComponents {

	var color: UIColor!
	var degree: Int = 0
	var percentage: CGFloat = 0

	public init(color: UIColor, percentage: CGFloat) {
		self.color = color
		self.degree = 0
		self.percentage = percentage
	}

}
