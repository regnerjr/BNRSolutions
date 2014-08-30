//
//  HypnosisView.swift
//  HypnoTime
//
//  Created by John Regner on 8/30/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

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

        CGContextSetLineWidth(ctx, 2 * half_linewidth)


        for (var current = maxRadius ; current > 0; current -= 20 ) {
            //circleColor = colors[Int(rand()) % Int(8)]
            circleColor = UIColor.lightGrayColor()
            circleColor.setStroke()
            CGContextAddArc(ctx, center.x, center.y, current, 0.0, CGFloat(2.0 * M_PI), 1)
            CGContextStrokePath(ctx)
        }

        //draw text
        //let text: NSString = "You are getting sleepy."
        //let font = UIFont.boldSystemFontOfSize(28)
        //let text_size: CGSize = text.sizeWithAttributes([NSFontAttributeName: font])
        //let textRect = CGRect(origin: CGPoint(x: center.x - text_size.width / 2, y: center.y - text_size.height / 2 ), size: text_size)
        //UIColor.blackColor().setFill()

        //let offset = CGSize(width: 4, height: 3)
        //let offsetColor: CGColorRef = UIColor.darkGrayColor().CGColor
        //CGContextSetShadowWithColor(ctx, offset, 2.0, offsetColor)

        //text.drawInRect(textRect, withAttributes: [NSFontAttributeName: font])
        CGContextSetShadowWithColor(ctx, CGSize(width: 0, height: 0), 0.0, UIColor.clearColor().CGColor)

        //Draw the crosshair here
        //CGContextSetLineWidth(ctx, 3)
        //UIColor.greenColor().setStroke()
        //CGContextMoveToPoint(ctx, center.x, center.y)
        //CGContextAddLineToPoint(ctx, center.x, center.y - 20) //up
        //CGContextAddLineToPoint(ctx, center.x, center.y + 20) //down
        //CGContextMoveToPoint(ctx, center.x, center.y)
        //CGContextAddLineToPoint(ctx, center.x - 20, center.y) //left
        //CGContextAddLineToPoint(ctx, center.x + 20, center.y) //right
        //CGContextStrokePath(ctx)
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