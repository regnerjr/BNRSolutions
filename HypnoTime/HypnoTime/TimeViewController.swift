import UIKit
import QuartzCore

class TimeViewController: UIViewController {
                            
    @IBOutlet weak var timeLabel: UILabel!
    @IBAction func getTime(sender: AnyObject) {
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.MediumStyle
        
        timeLabel.text = formatter.stringFromDate(now)
//        spinTimeLabel()
        bounceTimeLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func spinTimeLabel(){
        //create basic animation
        let spin = CABasicAnimation(keyPath: "transform.rotation")
        spin.delegate = self
        spin.toValue = NSNumber(double: M_PI * 2.0)
        spin.duration = 1.0
        let tf = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        spin.timingFunction = tf
        
        timeLabel.layer.addAnimation(spin, forKey: "spinAnimation")
    }

    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        println("\(anim) finished: \(flag)")
    }

    func bounceTimeLabel(){
        let bounce = CAKeyframeAnimation(keyPath: "transform")
        
        let forward = CATransform3DMakeScale(1.3, 1.3, 1)
        let back = CATransform3DMakeScale(0.7, 0.7, 1)
        let forward2 = CATransform3DMakeScale(1.2, 1.2, 1)
        let back2 = CATransform3DMakeScale(0.9, 0.9, 1)
        
        bounce.values = [
            NSValue(CATransform3D:CATransform3DIdentity),
            NSValue(CATransform3D: forward),
            NSValue(CATransform3D: back),
            NSValue(CATransform3D: forward2),
            NSValue(CATransform3D: back2),
            NSValue(CATransform3D: CATransform3DIdentity)
        ]
        bounce.duration = 0.6
        timeLabel.layer.addAnimation(bounce, forKey: "bounceAnimation")
        
    }
}

