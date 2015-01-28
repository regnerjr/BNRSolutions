import UIKit

@objc class Line {
    
    var begin: CGPoint
    var end: CGPoint
 
    init(begin: CGPoint, end:CGPoint){

        self.begin = begin
        self.end = end
    }
}