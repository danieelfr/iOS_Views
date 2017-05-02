import UIKit

class FaceView: UIView {
    
    var scale: CGFloat = 0.90
    
    private var skullRadius: CGFloat {
     
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private var skullCenter: CGPoint {
        
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private struct Ratios {
        
        static let SkullRadiosToEyeOffset: CGFloat = 3
        static let SkullRadiosToEyeRadius: CGFloat = 10
        static let SkullRadiosToMouthWidth: CGFloat = 1
        static let SkullRadiosToMouthHeight: CGFloat = 3
        static let SkullRadiosToMouthOffset: CGFloat = 3
    }

    private enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: false)
        
        path.lineWidth = 5
        
        return path
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint {
        
        let eyeOffset = skullRadius / Ratios.SkullRadiosToEyeOffset
        
        var eyeCenter = skullCenter
        
        eyeCenter.y -= eyeOffset
        
        switch eye {
        
        case .Left: eyeCenter.x -= eyeOffset
            
        case .Right: eyeCenter.x += eyeOffset
            
        }
        
        return eyeCenter
    }
    
    private func pathForMouth() -> UIBezierPath {
        
        let mouthWidth = skullRadius / Ratios.SkullRadiosToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiosToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiosToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let mouthCurvature: Double = 1.0
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 5.0
        
        return path
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath {
        
        let eyeRadius = skullRadius / Ratios.SkullRadiosToEyeRadius
        let eyeCenter = getEyeCenter(eye)
        
        return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
        
    }
    
    override func drawRect(rect: CGRect) {
        
        UIColor.blackColor().set()
        pathForCircleCenteredAtPoint(skullCenter, withRadius: skullRadius).stroke()
        pathForEye(.Left).stroke()
        pathForEye(.Right).stroke()
        pathForMouth().stroke()
    }
}
