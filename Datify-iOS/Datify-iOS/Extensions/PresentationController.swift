//
//  PresentationController.swift
//  Drawsome
//
//  Created by Sobhan on 23/12/2020.
//  Copyright © 2020 CP. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {

//  var blurEffectView: UIVisualEffectView!
  var blurEffectView: UIView!
  var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
  
  
  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
    
    
//    Code for Blur Effect: P.S: I will use same naming convention ffor better scalability.
    
//      let blurEffect =  UIBlurEffect(style: .dark)
//      blurEffectView = UIVisualEffectView(effect: blurEffect)
//      super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
//      tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
//      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//      self.blurEffectView.isUserInteractionEnabled = true
//      self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    
    
// Code for Non Blur Effect: P.S: I have used same naming convention ffor better scalability.
    
//    let blurEffect =  UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.presentingViewController.view?.bounds.width ?? 0.0, height: self.presentingViewController.view?.bounds.height ?? 0.0))
    blurEffectView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    blurEffectView.backgroundColor = .black
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.blurEffectView.isUserInteractionEnabled = true
    self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    
    
  }
  
  override var frameOfPresentedViewInContainerView: CGRect {
    CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height - (self.containerView!.frame.height * 0.95)),
             size: CGSize(width: self.containerView!.frame.width, height: (self.containerView!.frame.height * 0.95)))
  }

  override func presentationTransitionWillBegin() {
      self.blurEffectView.alpha = 0
      self.containerView?.addSubview(blurEffectView)
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.alpha = 0.4
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
  }
  
  override func dismissalTransitionWillBegin() {
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.alpha = 0
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.removeFromSuperview()
      })
  }
  
  override func containerViewWillLayoutSubviews() {
      super.containerViewWillLayoutSubviews()
    presentedView!.roundCorners([.topLeft, .topRight], radius: 22)
  }

  override func containerViewDidLayoutSubviews() {
      super.containerViewDidLayoutSubviews()
      presentedView?.frame = frameOfPresentedViewInContainerView
      blurEffectView.frame = containerView!.bounds
  }

  @objc func dismissController(){
      self.presentedViewController.dismiss(animated: true, completion: nil)
  }
}

extension UIView {
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      layer.mask = mask
  }
}

