//
//  AppDelegate.swift
//  Hypnosister3
//
//  Created by John Regner on 8/23/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIScrollViewDelegate {
                            
    var window: UIWindow!
    var hypnosisView: HypnosisView!

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {


        window = UIWindow(frame:UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.whiteColor()
        window.makeKeyAndVisible()

        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)

        let screenBounds = window.bounds

        let scrollView = UIScrollView(frame: screenBounds)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.delegate = self
        window.addSubview(scrollView)

        let quarterWidth = Double(screenBounds.width / 4.0)

        //create 2 views and add them as subviews, taking care where their origins are
        let frame1 = CGRect(x: screenBounds.origin.x, y: screenBounds.origin.y, width: screenBounds.width, height: screenBounds.height)
        hypnosisView = HypnosisView(frame: frame1)
        scrollView.addSubview(hypnosisView)

        scrollView.contentSize = CGSize(width: screenBounds.width, height: screenBounds.height)

        let hatView = BNRView(frame: CGRect(x: 5, y: 5, width: 80, height: 80))
        hatView.backgroundColor = UIColor.clearColor()
        hypnosisView.addSubview(hatView)
        return true
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return hypnosisView
    }
}

class HypnosisView: UIView {

    let colors = [UIColor.blackColor(), UIColor.purpleColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.orangeColor(), UIColor.redColor(),UIColor.magentaColor()]

    var circleColor: UIColor {
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
            circleColor = colors[Int(rand()) % Int(8)]
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

        //Draw the crosshair here
        CGContextSetLineWidth(ctx, 3)
        UIColor.greenColor().setStroke()
        CGContextMoveToPoint(ctx, center.x, center.y)
        CGContextAddLineToPoint(ctx, center.x, center.y - 20) //up
        CGContextAddLineToPoint(ctx, center.x, center.y + 20) //down
        CGContextMoveToPoint(ctx, center.x, center.y)
        CGContextAddLineToPoint(ctx, center.x - 20, center.y) //left
        CGContextAddLineToPoint(ctx, center.x + 20, center.y) //right
        CGContextStrokePath(ctx)
    }

    override init(frame: CGRect) {
        circleColor = UIColor.lightGrayColor()
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent) {
        if motion == UIEventSubtype.MotionShake {
            println(" Device started shaking!")
            self.circleColor = UIColor.redColor()
        }
    }

}

class BNRView : UIView {
    var hat = UIImage(named: "logo.png")

    override func drawRect(rect: CGRect) {
        //Get drawing context
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()

        //draw the black circle
        CGContextSetLineWidth(ctx, 3)
        UIColor.blackColor().setStroke()
        CGContextAddArc(ctx, (rect.origin.x + rect.width / 2.0),(rect.origin.y + rect.height / 2.0),                        rect.width / 2.0 - 2, 0, CGFloat(2.0 * M_PI), 1)
        CGContextStrokePath(ctx)

        //Clip to Cirle
        CGContextAddArc(ctx, (rect.origin.x + rect.width / 2.0),(rect.origin.y + rect.height / 2.0),                        rect.width / 2.0 - 2, 0, CGFloat(2.0 * M_PI), 1)
        CGContextClip(ctx)

        //draw the light blue to white gradient in the circle
        //Currently Broken
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        let colors: CFArray = [UIColor.blueColor(), UIColor.whiteColor()]
        let gradient = CGGradientCreateWithColors(colorSpace, colors, locations)
        //create points for linear gradient
        let startPoint = CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMinY(rect));
        let endPoint = CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMidY(rect));
        CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);

        //draw the hat
        let imageRect = CGRect(x: 5, y: 26, width: 70, height: 80)
        hat.drawInRect(imageRect)

    }
    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
