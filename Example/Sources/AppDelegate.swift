//
//  Created by Indoorway on 08.11.2017.
//  Copyright © 2017 Indoorway. All rights reserved.
//

import UIKit
import IndoorwaySdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let mapViewController = MapViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        IndoorwaySdk.configure(token: <#apiKey#>)
        let visitor = IndoorwayVisitorEntry(name: <#visitorName#>, email: <#visitorEmail#>, age: nil, sex: nil, groupUuid: nil, sharedLocation: nil)
        IndoorwaySdk.instance().visitor.setup(visitor: visitor, completion: { _ in })

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mapViewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

