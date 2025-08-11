//
//  Controller.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 11.08.2025.
//

import Foundation
import UIKit
import SafariServices
import SwiftUI

class AdsViewController: UIViewController, SFSafariViewControllerDelegate  {

    let levelData = SFSafariViewController(url: URL(string: UserDefaults.standard.string(forKey: "finalURL") ?? "")!)
//    let levelData = SFSafariViewController(url: URL(string: "https://muchklegra.top/start")!)
    private lazy var soundConroller: SFSafariViewController = {
        let viewController = levelData
        return viewController
    }()
    
    var deviceHasSafeArea: Bool {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return false
        }
        
        guard let window = windowScene.windows.first else {
            return false
        }
        
        let topSafeArea = window.safeAreaInsets.top
        let rightSafeArea = window.safeAreaInsets.right
        let leftSafeArea = window.safeAreaInsets.left
        
        return topSafeArea > 20 || rightSafeArea > 20 || leftSafeArea > 20
    }

    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        UserDefaults.standard.setValue("done", forKey: "swipeBack")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.computeMargins()
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        computeMargins()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        soundConroller = levelData
        soundConroller.delegate = self
        computeMargins()
        present(soundConroller, animated: true) { [weak self] in
            self?.computeMargins()
        }
    }
    
    func computeMargins() {
        
        let topMargin: CGFloat = -50
        var bottomMargin: CGFloat = 50
        
        soundConroller.dismissButtonStyle = .close
        soundConroller.preferredBarTintColor = .clear
        soundConroller.preferredControlTintColor = .clear
        
        let dateConfig = SFSafariViewController.Configuration()
        dateConfig.entersReaderIfAvailable = true
        dateConfig.barCollapsingEnabled = true
        
        let screenSize = UIScreen.main.bounds.size
        var soundView = UIScreen.main.bounds
        
        if screenSize.width > screenSize.height {
            
            if deviceHasSafeArea {
                bottomMargin = CGFloat(50)
                soundView.origin = CGPoint(x: soundView.origin.x, y: topMargin + 30)
                soundView.size = CGSize(width: soundView.width, height: screenSize.height - 24)
                soundConroller.view.frame = soundView
                let customBounds = CGRect(x: 0, y: 0, width: soundView.width, height: soundView.height + 50)
                soundConroller.view.bounds = customBounds
            } else {
                marginChoose(valueTop: 14, valueBottom: 0, valueHeight: 10)
            }
        } else {
            if deviceHasSafeArea {
                marginChoose(valueTop: 28, valueBottom: 0, valueHeight: 70)
                
            } else {
                marginChoose(valueTop: 14, valueBottom: 10, valueHeight: 10)
            }
        }
        
        func marginChoose(valueTop: CGFloat, valueBottom: CGFloat, valueHeight: CGFloat) {
            bottomMargin = CGFloat(50)
            soundView.origin = CGPoint(x: soundView.origin.x, y: topMargin + valueTop)
            soundView.size = CGSize(width: soundView.width, height: screenSize.height + bottomMargin + valueBottom)
            soundConroller.view.frame = soundView
            let customBounds = CGRect(x: 0, y: 0, width: soundView.width, height: soundView.height + valueHeight)
            soundConroller.view.bounds = customBounds
        }
        
        soundConroller.modalPresentationCapturesStatusBarAppearance = true
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension SFSafariViewController{
    override open var prefersStatusBarHidden: Bool{
        get{
            return true
        }
    }
}







