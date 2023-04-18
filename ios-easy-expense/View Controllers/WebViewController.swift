//
//  WebViewController.swift
//  ios-easy-expense
//
//  Created by Enrico Ginocchi on 2023-04-15.
//  This class handles loading the predefined website onto the WebKit View and the animating of the custom Activity Indicator.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView : WKWebView!
    @IBOutlet var cashRegisterImageView : UIImageView!
    
    /// This method is called when the navigation of the WebKit View begins.
    /// - Parameters:
    ///     - webView: The WKWebView
    ///     - navigation: The WKNavigation
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        setHidden(hidden: false)
        startAnimating()
    }
    
    /// This method is called when the navigation of the WebKit View is finished.
    /// - Parameters:
    ///     - webView: The WKWebView
    ///     - navigation: The WKNavigation
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        setHidden(hidden: true)
        stopAnimating()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Load the URL onto the WebKit View
        let urlAddress = URL(string: "https://consumer.gov/managing-your-money/making-budget")
        let url = URLRequest(url: urlAddress!)
        webView.load(url)
        webView.navigationDelegate = self
    }
    
    /// This method is a helper method that handles the animating of the custom Activity Indicator.
    func startAnimating() {
        // Define the fade out animation and its values
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        fadeOutAnimation.duration = 0.5
        fadeOutAnimation.fillMode = CAMediaTimingFillMode.both
        fadeOutAnimation.repeatCount = Float.infinity

        // Define the fade in animation and its values
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        fadeInAnimation.fromValue = 0.0
        fadeInAnimation.toValue = 1.0
        fadeInAnimation.duration = 0.5
        fadeInAnimation.beginTime = fadeOutAnimation.duration
        fadeInAnimation.fillMode = CAMediaTimingFillMode.both
        fadeInAnimation.repeatCount = Float.infinity

        // Put them both in an animation group
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [fadeOutAnimation, fadeInAnimation]
        animationGroup.duration = fadeOutAnimation.duration * 2
        animationGroup.repeatCount = Float.infinity

        // Add it to the image view
        cashRegisterImageView.layer.add(animationGroup, forKey: "MyFadeAnim")
    }
    
    /// This method is a helper method that stops the animation.
    func stopAnimating() {
        cashRegisterImageView.layer.removeAnimation(forKey: "MyFadeAnim")
    }
    
    /// This method is a helper method that hides the custom Activity Indicator.
    func setHidden(hidden: Bool) {
        cashRegisterImageView.alpha = hidden == true ? 0 : 1
    }
}
