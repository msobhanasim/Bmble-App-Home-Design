//
//  CustomTransition.swift
//  Non-Interactive Transition
//
//  Created by Karan Pal on 02/02/21.
//

import UIKit

class PresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var animator: UIViewImplicitlyAnimating?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if self.animator != nil {
            return self.animator!
        }
        
        let container = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: .from)!
        
        let fromViewInitialFrame = CGRect(x: transitionContext.initialFrame(for: fromVC).minX, y: transitionContext.initialFrame(for: fromVC).minY, width: transitionContext.initialFrame(for: fromVC).width, height: transitionContext.initialFrame(for: fromVC).height)
        
        var fromViewFinalFrame = fromViewInitialFrame
        fromViewFinalFrame.origin.x = -fromViewFinalFrame.width
        
        let toViewInitialFrameCustom = CGRect(x: transitionContext.initialFrame(for: fromVC).minX, y: transitionContext.initialFrame(for: fromVC).minY, width: transitionContext.initialFrame(for: fromVC).width, height: transitionContext.initialFrame(for: fromVC).height - 100.0)
        
        
        
        let fromView = fromVC.view!
        let toView = transitionContext.view(forKey: .to)!
        
        var toViewInitialFrame = toViewInitialFrameCustom
        toViewInitialFrame.origin.x = toView.frame.size.width
        
        toView.frame = toViewInitialFrame
        container.addSubview(toView)
        
        let animator = UIViewPropertyAnimator(duration: self.transitionDuration(using: transitionContext), curve: .easeInOut) {
            
            toView.frame = toViewInitialFrameCustom
            fromView.frame = fromViewFinalFrame
        }
        
        animator.addCompletion { _ in
            transitionContext.completeTransition(true)
        }
        
        self.animator = animator
        
        return animator
        
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        self.animator = nil
    }
}




