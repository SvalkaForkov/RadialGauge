import UIKit

class RotationGestureRecognizer: UIPanGestureRecognizer {

    private(set) var touchAngle: CGFloat = 0
    private(set) var touchPoint: CGPoint = CGPoint(x: 0, y: 0)

    var isHighThumbUnderInteraction: Bool = false
    var isLowThumbUnderInteraction: Bool = false

    private var radialGauge: RadialGauge? {
        return view as? RadialGauge
    }

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        maximumNumberOfTouches = 1
        minimumNumberOfTouches = 1
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        if
            let touch = touches.first,
            let view = view as? RadialGauge
        {
            let touchPoint = touch.location(in: view)
            isHighThumbUnderInteraction = view.isThumbSelected(touchPoint: touchPoint, thumbType: .highThumb)
            isLowThumbUnderInteraction = view.isThumbSelected(touchPoint: touchPoint, thumbType: .lowThumb)
        }
        radialGauge?.gaugeInteraction(interactionType: .start)
        updateAngle(with: touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        updateAngle(with: touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)

        radialGauge?.delegate?.gaugeInteraction(interactionType: .end)

        if isHighThumbUnderInteraction || isLowThumbUnderInteraction {
            radialGauge?.sliderThumbEnd()
        }

        isHighThumbUnderInteraction = false
        isLowThumbUnderInteraction = false
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        radialGauge?.delegate?.gaugeInteraction(interactionType: .cancelled)
    }

    private func angle(for point: CGPoint, in view: UIView) -> CGFloat {
        let centerOffset = CGPoint(x: point.x - view.bounds.midX, y: point.y - view.bounds.midY)
        return atan2(centerOffset.y, centerOffset.x)
    }

    private func updateAngle(with touches: Set<UITouch>) {
        guard
            let touch = touches.first,
            let view = view
        else {
            return
        }
        let touchPoint = touch.location(in: view)
        touchAngle = angle(for: touchPoint, in: view)
    }

}
