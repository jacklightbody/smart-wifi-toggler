//
//  NeedAccessView.swift
//  Smart Wifi Toggler
//
//  Created by Jack lightbody on 4/2/17.
//  Copyright © 2017 Jack lightbody. All rights reserved.
//

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

class NeedAccessView: UIViewController {
	let pscope = PermissionScope()
	
	@IBAction func requestPermissions(_ sender: Any) {
		// Show dialog with callbacks
		pscope.show({ finished, results in
			let mainView = ViewController()
			self.present(mainView, animated: true, completion: nil)
		}, cancelled: { (results) -> Void in
			print("thing was cancelled")
		})
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		pscope.addPermission(NotificationsPermission(notificationCategories: nil),
		                     message: "We use this to remind you to turn off wifi when you leave home")
		pscope.addPermission(LocationAlwaysPermission(),
		                     message: "We use this to track when you leave home")
		

		SFContentBlockerManager.reloadContentBlocker(withIdentifier: "com.jacklightbody.Smart-Wifi-Toggler.Data-Blocker", completionHandler: nil)
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

