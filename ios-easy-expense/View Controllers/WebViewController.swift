//
//  WebViewController.swift
//  ios-easy-expense
//
//  Created by Vincent Ursino on 2023-04-15.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView : WKWebView!
    @IBOutlet var cashRegisterImageView : UIImageView!
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        setHidden(hidden: false)
        startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        setHidden(hidden: true)
        stopAnimating()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let urlAddress = URL(string: "https://consumer.gov/managing-your-money/making-budget")
        let url = URLRequest(url: urlAddress!)
        webView.load(url)
        webView.navigationDelegate = self
    }
    
    func startAnimating() {
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        fadeOutAnimation.fromValue = 1.0
        fadeOutAnimation.toValue = 0.0
        fadeOutAnimation.duration = 0.5
        fadeOutAnimation.fillMode = CAMediaTimingFillMode.both
        fadeOutAnimation.repeatCount = Float.infinity

        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        fadeInAnimation.fromValue = 0.0
        fadeInAnimation.toValue = 1.0
        fadeInAnimation.duration = 0.5
        fadeInAnimation.beginTime = fadeOutAnimation.duration
        fadeInAnimation.fillMode = CAMediaTimingFillMode.both
        fadeInAnimation.repeatCount = Float.infinity

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [fadeOutAnimation, fadeInAnimation]
        animationGroup.duration = fadeOutAnimation.duration * 2
        animationGroup.repeatCount = Float.infinity

        cashRegisterImageView.layer.add(animationGroup, forKey: "MyFadeAnim")
    }
    
    func stopAnimating() {
        cashRegisterImageView.layer.removeAnimation(forKey: "MyFadeAnim")
    }
    
    func setHidden(hidden: Bool) {
        cashRegisterImageView.alpha = hidden == true ? 0 : 1
    }
}
