//
//  Constants.swift
//  ChatTestRealm
//
//  Created by Kai Qiao on 11/14/19.
//  Copyright © 2019 iKai0314. All rights reserved.
//

import Foundation
struct Constants {
    // **** Realm Cloud Users:
    // **** Replace MY_INSTANCE_ADDRESS with the hostname of your cloud instance
    // **** e.g., "mycoolapp.us1.cloud.realm.io"
    // ****
    // ****
    // **** ROS On-Premises Users
    // **** Replace the AUTH_URL and REALM_URL strings with the fully qualified versions of
    // **** address of your ROS server, e.g.: "http://127.0.0.1:9080" and "realm://127.0.0.1:9080"
        static let MY_INSTANCE_ADDRESS = "kchat.us1a.cloud.realm.io"

    static let AUTH_URL  = URL(string: "https://kchat.us1a.cloud.realm.io")!
    static let REALM_URL = URL(string: "realms://kchat.us1a.cloud.realm.io/ChatTestRealm")!
}

