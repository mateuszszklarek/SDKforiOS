//
//  AppDelegate.swift
//  IndoorwayKit
//
//  Created by Indoorway on 11/14/2016.
//  Copyright (c) 2016 Indoorway. All rights reserved.
//

import UIKit
import IndoorwayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		IndoorwayConfiguration.configure(withApiKey: <#T##String#>)
		IndoorwayConfiguration.setupVisitor(withName: <#T##String#>, email: <#String#>, age: <#T##Int#>, sex: <#T##IndoorwayVisitorSex#>, group: <#T##String#>, shareLocation: <#Bool#>)
		return true
	}
}
