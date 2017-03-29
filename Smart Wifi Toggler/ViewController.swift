//
//  ViewController.swift
//  Smart Wifi Toggler
//
//  Created by Jack lightbody on 3/26/17.
//  Copyright © 2017 Jack lightbody. All rights reserved.
//

import UIKit
import PermissionScope
import SafariServices

class ViewController: UIViewController {
	let pscope = PermissionScope()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		pscope.addPermission(NotificationsPermission(notificationCategories: nil),
		                     message: "We use this to send remind you to turn off wifi")
		pscope.addPermission(LocationAlwaysPermission(),
		                     message: "We use this to track when you leave home")
		
		// Show dialog with callbacks
		pscope.show({ finished, results in
			print("got results \(results)")
		}, cancelled: { (results) -> Void in
			print("thing was cancelled")
		})
		SFContentBlockerManager.reloadContentBlocker(withIdentifier: "com.jacklightbody.Smart-Wifi-Toggler.Data-Blocker", completionHandler: nil)

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

