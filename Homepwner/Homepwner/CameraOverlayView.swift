//
//  CameraOverlayView.swift
//  Homepwner
//
//  Created by John Regner on 11/1/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

class CameraOverlayView: UIView {
    override func drawRect(rect: CGRect) {
        let height = rect.size.height
        let width = rect.size.width

        let ctx: CGContextRef = UIGraphicsGetCurrentContext()
        let linewidth: CGFloat = 2
        CGContextSetLineWidth(ctx, linewidth)
        //draw up down line
        CGContextMoveToPoint(ctx, rect.size.width / 2, 0)
        CGContextAddLineToPoint(ctx, rect.size.width / 2, rect.size.height)
        //draw horizontal line
        CGContextMoveToPoint(ctx, 0, rect.size.height / 2)
        CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height / 2)

        //Stroke Path
        CGContextStrokePath(ctx)
    }
}
