import UIKit

class TouchDrawView: UIView {

    var linesInProcess = [NSValue:Line]()
    var completeLines = [Line]()
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 10.0)
        CGContextSetLineCap(context, kCGLineCapRound)

        //draw complete lines in black
        UIColor.blackColor().set()
        for line in completeLines {
            CGContextMoveToPoint(context, line.begin.x, line.begin.y)
            CGContextAddLineToPoint(context, line.end.x, line.end.y)
            CGContextStrokePath(context)
        }

        //draw the lines in process in red
        UIColor.redColor().set()
        for (k,line) in linesInProcess {
            CGContextMoveToPoint(context, line.begin.x, line.begin.y)
            CGContextAddLineToPoint(context, line.end.x, line.end.y)
            CGContextStrokePath(context)
        }
        
    }

    func clearAll(){
        linesInProcess.removeAll(keepCapacity: false)
        completeLines.removeAll(keepCapacity: false)
        setNeedsDisplay()
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        println("Touches Began with \(touches.count) touches")
        for t in touches {
            let t = t as UITouch //touches come from an untyped NSSet
            if t.tapCount > 1 {
                clearAll()
                return
            }
        
            let key = NSValue(nonretainedObject: t)
            
            let loc = t.locationInView(self)
            let newLine = Line(begin: loc, end: loc)
            linesInProcess[key] = newLine
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
                println("Touches Moved with \(touches.count) touches")
        for t in touches {
            let t = t as UITouch //touches come from an untyped NSSet
            let key = NSValue(nonretainedObject: t)
            
            let loc = t.locationInView(self)
            //get existing struct, and make a new one with the updated data
            if let current = linesInProcess[key] {
                linesInProcess[key] = Line(begin: current.begin, end: loc)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        endTouches(touches)
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        endTouches(touches)
    }

    func endTouches(touches: NSSet){
        println("Touches Ending  with \(touches.count) touches")
        for t in touches {
            let t = t as UITouch //touches come from an untyped NSSet
            let key = NSValue(nonretainedObject: t)
            let line = linesInProcess[key]
            
            //line is nil if this is a double tap
            if let line = line {
                completeLines.append(line)
                linesInProcess.removeValueForKey(key)
            }
        }
        setNeedsDisplay()
    }
    
}