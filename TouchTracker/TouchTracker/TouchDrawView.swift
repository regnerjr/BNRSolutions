import UIKit

class TouchDrawView: UIView {

    @IBOutlet var moveRecognizer: UIPanGestureRecognizer!
    
    var linesInProcess = [NSValue:Line]()
    var completeLines = [Line]()

    var selectedLine: Line? = nil

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
        
        //if there is a selected line draw it in green
        if let selected = selectedLine {
            UIColor.greenColor().set()
            CGContextMoveToPoint(context, selected.begin.x, selected.begin.y)
            CGContextAddLineToPoint(context, selected.end.x, selected.end.y)
            CGContextStrokePath(context)
        }
        
    }

    func lineAtPoint(p: CGPoint) -> Line? {
        
        for line in completeLines {
            let start = line.begin
            let end = line.end
            
            for var t: CGFloat = 0.0 ; t <= 1.0; t += 0.05 {
                let x = start.x + t * (end.x - start.x)
                let y = start.y + t * (end.y - start.y)
                
                if hypot(x - p.x, y - p.y) < 20.0 {
                    return line
                }
            }
        }
        return nil
        
    }

    func clearAll(){
        linesInProcess.removeAll(keepCapacity: false)
        completeLines.removeAll(keepCapacity: false)
        setNeedsDisplay()
    }
    
    //MARK: - Touch Handling
    @IBAction func handleTap(sender: UITapGestureRecognizer){

        let point = sender.locationInView(self)
        selectedLine = lineAtPoint(point)
        
        if let selected = selectedLine {
            self.becomeFirstResponder()
            displayMenu(atPoint: point)
        } else {
            UIMenuController.sharedMenuController().setMenuVisible(false, animated: true)
        }

        //if we just tapped then don't draw a dot here.
        linesInProcess.removeAll(keepCapacity: false)
        setNeedsDisplay()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {


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
    
    //MARK: - MenuController
    
    func displayMenu(atPoint point: CGPoint){
        let menu = UIMenuController.sharedMenuController()
        let deleteItem = UIMenuItem(title: "Delete", action: Selector("deleteSelectedLine"))
        menu.menuItems = [deleteItem]
        menu.setTargetRect(CGRect(x: point.x, y: point.y, width: 0, height: 0), inView: self)
        menu.setMenuVisible(true, animated: true)
    }

    func deleteSelectedLine(){

        if let line = selectedLine {
            //remove the selected line from the complete lines
            completeLines = completeLines.filter{ $0 !== line}
            selectedLine = nil
        }
        
        setNeedsDisplay()
    }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    //MARK: - Long Press
    @IBAction func longPress(gr: UILongPressGestureRecognizer){


        if gr.state == UIGestureRecognizerState.Began {
            let point = gr.locationInView(self)
            selectedLine = lineAtPoint(point)
            
            if selectedLine != nil {
                linesInProcess.removeAll(keepCapacity: false)
            }
        } else if gr.state == UIGestureRecognizerState.Ended {
            selectedLine = nil
        }
        self.setNeedsDisplay()
    }
    
    //MARK: - Pan Handler
    @IBAction func moverLine(gr: UIPanGestureRecognizer){
        if selectedLine == nil {
            return
        }
        
        //when pan recognizer changes position
        if gr.state == UIGestureRecognizerState.Changed {
            let translation = gr.translationInView(self)
            selectedLine = translateLine(selectedLine, translation)
            setNeedsDisplay()
            gr.setTranslation(CGPointZero, inView: self)
        }
    }
}

func translateLine(selectedLine: Line?, translation: CGPoint) -> Line? {
    if let line = selectedLine {
        var begin = line.begin
        var end = line.end
        begin.x += translation.x
        begin.y += translation.y
        end.x   += translation.x
        end.y   += translation.y
        selectedLine?.begin = begin
        selectedLine?.end = end
        return selectedLine
    }
    return nil
}

extension TouchDrawView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == moveRecognizer {
            return true
        } else {
            return false
        }
    }
    
}
