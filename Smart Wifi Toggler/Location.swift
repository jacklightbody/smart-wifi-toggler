//
//  Location.swift
//  Smart Wifi Toggler
//
//  Created by Jack lightbody on 3/26/17
//  Copyright (c) 2017 Jack lightbody. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import UserNotifications
class Location: NSObject, CLLocationManagerDelegate{
    static let sharedInstance = Location()
    // makes the class a singleton so we're always looking at the same instance
    // see http://krakendev.io/blog/the-right-way-to-write-a-singleton for detailed discussion
    var locationManager:CLLocationManager = CLLocationManager()
	var lastHomeNotificationTime: Double = 0
	var lastAwayNotificationTime: Double = 0
	var lastSafeTime: Double = 0
    var status: CLAuthorizationStatus?
    
    // initializer. Checks if logged in and if so gets all the stuff we need
    // private to make sure that the class stays a singleton
    fileprivate override init(){
        super.init()
		self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		self.locationManager.distanceFilter = 100
		self.locationManager.allowDeferredLocationUpdates(untilTraveled: 100, timeout:CLTimeIntervalMax)
		self.locationManager.requestAlwaysAuthorization()
		self.locationManager.startUpdatingLocation()
    }
    // various helper funcs to get data
    func enabled()-> Bool{
		if CLLocationManager.locationServicesEnabled() {
			switch(CLLocationManager.authorizationStatus()) {
			case .notDetermined, .restricted, .denied:
				return false
			case .authorizedAlways, .authorizedWhenInUse:
				return true
			}
		} else {
			return false
		}
    }
    // MARK: - CoreLocation Delegate Methods
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
    // when location is updated, send a request to the api controller
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
		let location = locations.last! as CLLocation
		let content = UNMutableNotificationContent()
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
		switch shouldSendNewNotification(location: location) {
			case 1:
				lastHomeNotificationTime = NSDate().timeIntervalSince1970
				// Send turn on notification
				content.title = "Back at Home"
				content.body = "Don't forget to turn on wifi"
				break
			case 2:
				lastAwayNotificationTime = NSDate().timeIntervalSince1970
				content.title = "Leaving Home"
				content.body = "Don't forget to turn off wifi"
				// Send turn off notification
				break
			default:
				return
		}
		content.sound = UNNotificationSound.default()
		let request = UNNotificationRequest(identifier: "SmartWifi", content: content, trigger: trigger)
		let center = UNUserNotificationCenter.current()
		center.add(request, withCompletionHandler: nil)
    }
	func atSafeSpot(location: CLLocation) -> Bool {
		// Here we want to check if we're within acceptable limits from any user defined safe spots
		// TODO: Actually implement this
		return false
	}
	func wifiConnected() -> Bool{
		let reachability = Reachability()
		return (reachability?.isReachableViaWiFi)!
	}
	// This function returns an int since we have a couple different options here
	// 0: Don't send anything
	// 1: Send a notification that they're at home again and can turn on wifi
	// 2: Send a notification that they should turn off wifi
	func shouldSendNewNotification(location: CLLocation) -> Int {
		let lastNotificationTime = max(lastAwayNotificationTime, lastHomeNotificationTime)
		if NSDate().timeIntervalSince1970 - lastNotificationTime < (10*60) {
			// if last notification was less then 10 minutes ago then forget it
			return 0
		}
		if atSafeSpot(location: location){
			// If wifi is already on then no need to tell them
			lastSafeTime = NSDate().timeIntervalSince1970
			if !wifiConnected() {
				return 1
			}
			return 0
		}
		if lastSafeTime > lastAwayNotificationTime{
			// Send a notification if we've been home since the last notification
			return 2
		}
		// If none of these are true, then don't notify
		return 0
		
	}
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }
}
