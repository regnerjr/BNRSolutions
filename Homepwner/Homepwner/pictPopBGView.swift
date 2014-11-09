//
//  pictPopBGView.swift
//

import UIKit

class pictPopBGView: UIPopoverBackgroundView {

    override var arrowOffset: CGFloat {
        get{
            return self.arrowOffset
        }
        set{
            self.arrowOffset = newValue
        }
    }
    override var arrowDirection: UIPopoverArrowDirection {
        get {
            return self.arrowDirection
        }
        set {
            self.arrowDirection = newValue
        }
    }

    var arrowView: UIView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0),
                                                   size: CGSize(width: 60, height: 60)))
    var backgroundView: UIView

    override init(frame: CGRect) {
        backgroundView = UIView(frame: frame)
        backgroundView.backgroundColor = UIColor.purpleColor()
        arrowView.backgroundColor = UIColor.redColor()
        super.init(frame:frame)
        backgroundColor = UIColor.redColor()

        self.addSubview(arrowView)
        self.addSubview(backgroundView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setArrowOffset(offset:CGFloat){
        arrowOffset = offset
    }

    override class func wantsDefaultContentAppearance() -> Bool {
        return true
    }
}
extension pictPopBGView : UIPopoverBackgroundViewMethods {
    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    override class func arrowBase() -> CGFloat {
        return 60
    }
    override class func arrowHeight() -> CGFloat {
        return 60
    }
}
