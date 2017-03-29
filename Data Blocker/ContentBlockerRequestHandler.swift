//
//  ContentBlockerRequestHandler.swift
//  Data Blocker
//
//  Created by Jack lightbody on 3/29/17.
//  Copyright © 2017 Jack lightbody. All rights reserved.
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

	func beginRequest(with context: NSExtensionContext) {
		let emptyjson = NSItemProvider(contentsOf: Bundle.main.url(forResource: "emptylist", withExtension: "json"))!
		let datajson = NSItemProvider(contentsOf: Bundle.main.url(forResource: "datalist", withExtension: "json"))!
		let defaults = UserDefaults.standard
		let name = defaults.string(forKey: "dataDietMethod")
		let item = NSExtensionItem()
		if name == "data"{
			item.attachments = [datajson]
		}else{
			item.attachments = [emptyjson]
		}
		
		context.completeRequest(returningItems: [item], completionHandler: nil)
	}
	
}
