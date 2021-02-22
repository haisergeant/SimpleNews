//
//  Animation.swift
//
//  Created by Hai Le Thanh.
//  
//

import UIKit

struct Animation {
    let duration: TimeInterval
    let delay: TimeInterval
    let closure: (UIView) -> Void
    
    static func move(duration: TimeInterval, delay: TimeInterval = 0, point: CGPoint) -> Animation {
        return Animation(duration: duration, delay: delay) { view in
            view.frame.origin = point
        }
    }
    
    static func changeAlpha(duration: TimeInterval, delay: TimeInterval = 0, alpha: CGFloat) -> Animation {
        return Animation(duration: duration, delay: delay) { view in
            view.alpha = alpha
        }
    }
    
    static func scale(duration: TimeInterval, delay: TimeInterval = 0, scale: CGFloat) -> Animation {
        return Animation(duration: duration, delay: delay) { view in
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}

extension UIView {
    func animate(_ animations: [Animation]) {
        guard !animations.isEmpty else {
            return
        }

        var animations = animations
        let first = animations.removeFirst()

        let propertyAnimator = UIViewPropertyAnimator(duration: first.duration,
                                                      curve: .easeInOut) {
            first.closure(self)
        }
        
        propertyAnimator.addCompletion { _ in
            self.animate(animations)
        }
        propertyAnimator.startAnimation(afterDelay: first.delay)
    }
}
