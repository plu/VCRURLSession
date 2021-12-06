//
//  VCRURLSessionViaSPMApp.swift
//  VCRURLSessionViaSPM
//
//  Created by Plunien, Johannes on 06.12.21.
//  Copyright © 2021 Johannes Plunien. All rights reserved.
//

import SwiftUI
import VCRURLSession

@main
struct VCRURLSessionViaSPMApp: App {
    init() {
        VCRURLSessionController.registerProtocolClasses()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
