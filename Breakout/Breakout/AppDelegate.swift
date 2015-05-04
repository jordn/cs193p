//
//  AppDelegate.swift
//  Breakout
//
//  Created by Jordan Burgess on 13/04/2015.
//  Copyright (c) 2015 Jordan Burgess. All rights reserved.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Motion is done using hardware that must be shared
    // so anyone in this app using CoreMotion must use this
    struct Motion {
        static let Manager = CMMotionManager()
    }
}

