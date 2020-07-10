import UIKit

class RotationGestureRecognizer: UIPanGestureRecognizer {

	private(set) var touchAngle: CGFloat = 0

	override init(target: Any?, action: Selector?) {
		super.init(target: target, action: action)
		maximumNumberOfTouches = 1
		minimumNumberOfTouches = 1
	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesMoved(touches, with: event)
		touchAngle = queryTouchAngle(for: touches.first)
	}

	private func angle(for point: CGPoint, in view: UIView) -> CGFloat {
		let centerOffset = CGPoint(x: point.x - view.bounds.midX, y: point.y - view.bounds.midY)
		return atan2(centerOffset.y, centerOffset.x)
	}

	private func queryTouchAngle(for touch: UITouch?) -> CGFloat {
		guard
			let touch = touch,
			let view = view
		else {
			return 0
		}

		let touchPoint = touch.location(in: view)
		return angle(for: touchPoint, in: view)
	}

}
