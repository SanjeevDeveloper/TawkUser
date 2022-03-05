//
//  NetworkStatus.swift
//  TawkUser
//
//  Created by Sanjeev on 04/03/22.
//

import Foundation
import Network

class NetworkStatus {
    static public let shared = NetworkStatus()
    private var monitor: NWPathMonitor = NWPathMonitor()
    private var queue = DispatchQueue.global()
    var isOn: Bool = true
    var listener: ((Bool) -> ())?

    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: queue)
    }

    func start() {
        self.monitor.pathUpdateHandler = { path in
            self.isOn = path.status == .satisfied
            self.listener?(self.isOn)
        }
    }

    func stop() {
        self.monitor.cancel()
    }
}
