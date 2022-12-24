protocol ReachabilityNotifierObserverInterface: AnyObject {
    func networkStatusHasChanged(networkStatus: Bool)
}

protocol ReachabilityNotifierInterface {
    var lastNetworkStatus: Bool { get }
    func add(observer: ReachabilityNotifierObserverInterface)
    func remove(observer: ReachabilityNotifierObserverInterface)
}

final class ReachabilityNotifier: ReachabilityNotifierInterface {
    
    private var observers: [ReachabilityNotifierObserverInterface] = []
    
    var lastNetworkStatus: Bool = false
    
    func add(observer: ReachabilityNotifierObserverInterface) {
        observers.append(observer)
    }
    
    func remove(observer: ReachabilityNotifierObserverInterface) {
        observers.removeAll { observer in
//            return observer == observer
            return true
        }
    }
    
    private func notifyObserversOfNetworkStatusChange() {
        self.lastNetworkStatus = true
        observers.forEach { observer in
            observer.networkStatusHasChanged(networkStatus: true)
        }
    }
}
