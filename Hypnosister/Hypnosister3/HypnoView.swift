import UIKit
import QuartzCore

class HypnosisView: UIView {

    let boxLayer: CALayer = {
        let layer =  CALayer()
        layer.bounds = CGRect(x: 0.0, y: 0.0, width: 85.0, height: 85.0)
        layer.position = CGPoint(x: 160.0, y: 100.0)
        
        let redish = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5).CGColor
        layer.backgroundColor = redish
        
        let layerImage = UIImage(named: "Hypno.png")?.CGImage
        layer.contents = layerImage
        layer.contentsRect = CGRect(x: -0.1, y: -0.1, width: 1.2, height: 1.2)
        layer.contentsGravity = kCAGravityResizeAspect
        return layer
    }()
    var circleColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override func drawRect(rect: CGRect)
    {
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()
        let center = CGPoint(
            x: rect.origin.x + rect.size.width / 2,
            y: rect.origin.y + rect.size.height / 2)
        let half_linewidth: CGFloat = 5
        let maxRadius = hypot((rect.size.width / 2) ,
                             (rect.size.height / 2) )
        //let maxRadius = hypot(rect.size.width , rect.size.height ) / 4.0

        CGContextSetLineWidth(ctx, 2 * half_linewidth)


        for (var current = maxRadius ; current > 0; current -= 20 ) {
            circleColor.setStroke()
            CGContextAddArc(ctx, center.x, center.y, current, 0.0, CGFloat(2.0 * M_PI), 1)
            CGContextStrokePath(ctx)
        }

        let text: NSString = "You are getting sleepy."
        let font = UIFont.boldSystemFontOfSize(28)
        let text_size: CGSize = text.sizeWithAttributes([NSFontAttributeName: font])
        let textRect = CGRect(origin: CGPoint(x: center.x - text_size.width / 2, y: center.y - text_size.height / 2 ), size: text_size)
        UIColor.blackColor().setFill()

        let offset = CGSize(width: 4, height: 3)
        let offsetColor: CGColorRef = UIColor.darkGrayColor().CGColor
        CGContextSetShadowWithColor(ctx, offset, 2.0, offsetColor)

        text.drawInRect(textRect, withAttributes: [NSFontAttributeName: font])
        CGContextSetShadowWithColor(ctx, CGSize(width: 0, height: 0), 0.0, UIColor.clearColor().CGColor)
    }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent) {
        if motion == UIEventSubtype.MotionShake {
            println("Device started shaking!")
            self.circleColor = UIColor.redColor()
        }
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let t = touches.anyObject() as? UITouch {
            let p = t.locationInView(self)
            boxLayer.position = p
        }
    }
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if let t = touches.anyObject() as? UITouch {
            let p = t.locationInView(self)
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            boxLayer.position = p
            CATransaction.commit()
        }
    }
}