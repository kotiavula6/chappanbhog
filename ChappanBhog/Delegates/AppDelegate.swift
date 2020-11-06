//
//  AppDelegate.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
//import TwitterKit
import Firebase
import SDWebImage
import CoreLocation
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let shared: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var tabbarController: TabBarVC?
    var sideMenuViewController: SlideMenuController!
    
    let manager = CLLocationManager()
    var currentLocation: CLLocation?
    var isFromSaveUserSata = false
    var currentCity: String = ""
    var currentCountry: String = "india"
    var isLucknow: Bool {
        return currentCity.lowercased() == "lucknow"
    }
    
    var isIndia: Bool {
        return currentCountry.lowercased() == "india"
    }
    
    var isGuestUser: Bool {
        let userId = UserDefaults.standard.value(forKey: Constants.UserId) as? Int ?? 0
        return userId == 0
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //TWTRTwitter.sharedInstance().start(withConsumerKey:"4Z8hpvQBOxBbtfXtjmtLWtt9Y", consumerSecret:"RfLtpt7X2RS34CAJICJqsTfV3U7kfgfk3XaHWA5oPa2k2GXE6U")

        // Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        
        GIDSignIn.sharedInstance().clientID = "574908180295-s62bs9umoqrvuo366ri3es6ucrq0oqp8.apps.googleusercontent.com"
        
        //PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "", PayPalEnvironmentSandbox: "AbuR52xSzomjCqHRJg8mOFjE-tF40xLMIjydEsCukOK3Oo23PVFbbfUQw24Ey_myeNTkbRfIjXVVwpOH"])

        
//        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//        let rootVc = storyBoard.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
//        let nav = UINavigationController(rootViewController: rootVc)
//        nav.isNavigationBarHidden = true
//        self.window?.rootViewController = nav
//        self.window?.makeKeyAndVisible()
        
        let loggedIn = UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN")
        let type = UserDefaults.standard.integer(forKey: "type")
        let verified = UserDefaults.standard.integer(forKey: Constants.verified)
        
        if loggedIn {
            if type == 0 && verified == 0 {
                // Type = Email and Phone number is not verified
                 _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(goToLoginScreen), userInfo: nil, repeats: false)
            }
            else {
                 _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(showHomeScreen), userInfo: nil, repeats: false)
                uploadTokenToServer()
            }
        }
        else {
            _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(goToLoginScreen), userInfo: nil, repeats: false)
        }
        
        // Location Manager
        startLocationUpdate()
        
        // Push Notifications
        registerPushNotification()
        
        syncCountriesFromLocalJson() // Sync from local
        CartHelper.shared.syncCountries { (success, msg) in } // Sync from server
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func syncCountriesFromLocalJson() {
        // Sync countries from local json
        if let url = Bundle.main.url(forResource: "countries", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: Any]]
                    if let result = jsonObj {
                        CartHelper.shared.countryStateArr.removeAll()
                        for value in result {
                            let country = CountryStateModel(dict: value)
                            CartHelper.shared.countryStateArr.append(country)
                        }
                    }
                } catch _ {
                    
                }
            } catch let error {
                print(error)
            }
        }
    }


    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ChappanBhog")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    @objc func showHomeScreen() {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let customTabbarViewController = Storyboard.instantiateViewController(withIdentifier: "Home") as? TabBarVC,
            let leftVC = Storyboard.instantiateViewController(withIdentifier: "SidemenuController") as? SidemenuController else {
            return
        }
        
        self.tabbarController = customTabbarViewController
        let navigationViewController: UINavigationController = UINavigationController(rootViewController: customTabbarViewController)
        navigationViewController.navigationBar.isHidden = true
        self.sideMenuViewController = SlideMenuController(mainViewController: navigationViewController, leftMenuViewController: leftVC)
        window?.rootViewController = sideMenuViewController
    }
    
    @objc func goToLoginScreen() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let rootVc = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        let nav = UINavigationController(rootViewController: rootVc)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    @objc func logout() {
        AppDelegate.shared.goToLoginScreen()
        UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
        GIDSignIn.sharedInstance().signOut()
        deleteTokenFromServer()
        clearDefaults()
        
       // let store = TWTRTwitter.sharedInstance().sessionStore
        //if let userID = store.session()?.userID {
          //store.logOutUserID(userID)
        //}
    }
    
    @objc func moveToDashboard() {
        guard let tabbarVC = self.tabbarController, let controllers = tabbarVC.viewControllers else { return }
        tabbarVC.selectedIndex = 0
        controllers[0].navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func clearDefaults() {
        UserDefaults.standard.removeObject(forKey: "ISUSERLOGGEDIN")
        UserDefaults.standard.removeObject(forKey: Constants.Name)
        UserDefaults.standard.removeObject(forKey: Constants.EmailID)
        UserDefaults.standard.removeObject(forKey: Constants.Phone)
        UserDefaults.standard.removeObject(forKey: Constants.DialingCode)
        UserDefaults.standard.removeObject(forKey: Constants.UserId)
        UserDefaults.standard.removeObject(forKey: Constants.IsLogin)
        UserDefaults.standard.removeObject(forKey: Constants.access_token)
        UserDefaults.standard.removeObject(forKey: Constants.verified)
        UserDefaults.standard.removeObject(forKey: Constants.type)
        UserDefaults.standard.removeObject(forKey: Constants.Image)
    }
    
    @objc func notifyCartUpdate() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kCartCount"), object: nil)
    }
    
    @objc func notifyLocationUpdate() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kLocationUpdate"), object: nil)
    }
    
    /// Returns true if login needed
    func checkNeedLoginAndShowAlertInController(_ controller: UIViewController) -> Bool {
        if !isGuestUser { return false } // User is logged in
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "ChhappanBhog", message: "Please login to proceed.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Login", style: UIAlertAction.Style.default, handler: { (action) in
                AppDelegate.shared.logout()
            }))
            alert.addAction(UIAlertAction(title: "Not Now", style: UIAlertAction.Style.default, handler: { (action) in
                
            }))
            controller.present(alert, animated: true, completion: nil)
        }
        
        return true
    }
}

extension AppDelegate {
    func sd_indicator() -> SDWebImageActivityIndicator {
        return SDWebImageActivityIndicator.gray
    }
}


// MARK:- Locations
extension AppDelegate: CLLocationManagerDelegate {
    
    func startLocationUpdate() {
        // Location Manager
        manager.delegate = self
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func stopLocationUpdate() {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if (locations.count > 0) {
            // let preLocation = locations[1]
            let location = locations[0]
            
            if let lastLocation = self.currentLocation {
                // Check if distance difference is atleast 500 meters
                let distance = fabs(lastLocation.distance(from: location))
                if distance < 500 {
                    return
                }
                
                /// Update current location
                self.currentLocation = location
                self.getPlaceMark(location) { (placeMark) in
                    self.currentCity = placeMark?.locality ?? ""
                    self.currentCountry = placeMark?.country ?? ""
                    self.notifyLocationUpdate()
                    
                    /*if !self.currentCity.isEmpty, let root = self.window?.rootViewController {
                        ShowAlert(AlertTitle: "ChhappanBhog", AlertDisc: "City: \(self.currentCity)\nCountry: \(self.currentCountry)", View: root)
                    }*/
                }
            }
            else {
                // First time
                /// Update current location
                self.currentLocation = location
                self.getPlaceMark(location) { (placeMark) in
                    self.currentCity = placeMark?.locality ?? ""
                    self.currentCountry = placeMark?.country ?? ""
                    self.notifyLocationUpdate()
                    
                    /*if !self.currentCity.isEmpty, let root = self.window?.rootViewController {
                        ShowAlert(AlertTitle: "ChhappanBhog", AlertDisc: "City: \(self.currentCity)\nCountry: \(self.currentCountry)", View: root)
                    }*/
                }
            }
        }
    }
    
    func canTrackLocation() -> (message: String, canTrack: Bool) {
        let message = "Location is needed to fetch the nearby gyms.\nGo to settings -> `ChhappanBhog` and enable the location."
        let status = CLLocationManager.authorizationStatus()
        switch status {
            case .notDetermined: return (message, false);
            case .restricted: return (message, false);
            case .denied: return (message, false);
            case .authorizedAlways: return ("", true);
            case .authorizedWhenInUse: return ("", true);
        @unknown default:
            return (message, false);
        }
    }
}


// MARK:- GeoCoding
import Contacts
extension AppDelegate {
    
    func getPlaceMark(_ lat: Double, lng: Double, completion: @escaping (_ placeMark: CLPlacemark?) -> Void) {
        let coordinates : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        getPlaceMark(coordinates, completion: completion)
    }
    
    func getPlaceMark(_ coordinates: CLLocationCoordinate2D, completion: @escaping (_ placeMark: CLPlacemark?) -> Void) {
        let location: CLLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        getPlaceMark(location, completion: completion)
    }
    
    func getPlaceMark(_ location: CLLocation, completion: @escaping (_ placeMark: CLPlacemark?) -> Void) {
        let geo: CLGeocoder = CLGeocoder()
        geo.reverseGeocodeLocation(location) { (placeMarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                completion(nil)
            }
            if let pms = placeMarks, let pm = pms.first {
                completion(pm)
            }
            else {
                completion(nil)
            }
        }
    }

    func getAddress(placeMark: CLPlacemark) -> String {
        if let postalAddress = placeMark.postalAddress {
            let postalAddressFormatter = CNPostalAddressFormatter()
            postalAddressFormatter.style = .mailingAddress
            return postalAddressFormatter.string(from: postalAddress)
        }
        return ""
    }
}

// MARK:- Push Notifications
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func isDeviceHasPushNotificationPermission(completionHandler: @escaping (_ enabled: Bool) -> Void) {
        
        if !UIApplication.shared.isRegisteredForRemoteNotifications {
            completionHandler(false)
            return
        }
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                completionHandler(true)
            case .denied:
                completionHandler(false)
            case .notDetermined:
                completionHandler(false)
            @unknown default:
                completionHandler(false)
            }
        }
    }
    
    func uploadTokenToServer() {
        // Update device token to server
        let userID = UserDefaults.standard.value(forKey: Constants.UserId) as? Int ?? 0
        guard userID > 0, let pushToken = getFCMToken() else {
            return
        }
        let notificationUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_PUSH_TOKEN_SAVE
        AFWrapperClass.requestPOSTURL(notificationUrl, params: ["user_id": userID, "token": pushToken], success: { (dict) in
            let success = dict["success"] as? Bool ?? false
            if success { print("Token updated...") }
        }) { (error) in
            
        }
    }
    
    func deleteTokenFromServer() {
        let userID = UserDefaults.standard.value(forKey: Constants.UserId) as? Int ?? 0
        guard userID > 0 else {
            return
        }
        let notificationUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_LOGOUT
        AFWrapperClass.requestPOSTURL(notificationUrl, params: ["user_id": userID], success: { (dict) in
            let success = dict["success"] as? Bool ?? false
            if success { print("Logout API success...") }
        }) { (error) in
            
        }
    }
    
    func saveFCMToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "FCM_TOKEN")
    }
    
    func getFCMToken() -> String? {
        return UserDefaults.standard.string(forKey: "FCM_TOKEN")
    }
    
    func registerPushNotification() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("D'oh: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    /*func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let hexDeviceToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("DeviceToken: ", hexDeviceToken)
        saveDeviceToken(hexDeviceToken)
        uploadTokenToServer()
    }*/
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //let hexDeviceToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        //print("DeviceToken: ", hexDeviceToken)
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")

        saveFCMToken(fcmToken)
        uploadTokenToServer()
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        // Print full message.
        print(userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        guard let userId = UserDefaults.standard.value(forKey: Constants.UserId) as? Int, userId > 0 else {
            UIApplication.shared.applicationIconBadgeNumber = 0
            return
        }

        // let userInfo = notification.request.content.userInfo
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
