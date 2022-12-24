protocol FeedViewModelInterface {
    func fetchNextPage(completion: @escaping (_ feedItems: [Feed]) -> Void)
}

final class FeedManager {
    private let feedService: FeedServiceInterface
    private let feedStorage: FeedStorageInterface
    private let reachabilityNotifier: ReachabilityNotifierInterface
    private var lastNetworkStatus: Bool
    
    init(feedService: FeedServiceInterface, feedStorage: FeedStorageInterface, reachabilityNotifier: ReachabilityNotifierInterface) {
        self.feedService = feedService
        self.feedStorage = feedStorage
        self.reachabilityNotifier = reachabilityNotifier
        self.lastNetworkStatus = reachabilityNotifier.lastNetworkStatus
        reachabilityNotifier.add(observer: self)
    }
    
    func networkStatusHasChanged(networkStatus: Bool) {
        self.lastNetworkStatus = networkStatus
    }
    
    func makeFeedVM() -> FeedViewModelInterface {
        if lastNetworkStatus {
            return FeedViewModel2(feedService: self.feedService, feedStorage: self.feedStorage)
        } else {
            return OfflineFeedViewModel(feedStorage: self.feedStorage)
        }
    }
}

final class OfflineFeedViewModel: FeedViewModelInterface {
    private let feedStorage: FeedStorageInterface
    
    init(feedStorage: FeedStorageInterface) {
        self.feedStorage = feedStorage
    }
    
    func fetchNextPage(completion: @escaping (_ feedItems: [Feed]) -> Void) {
        completion(self.feedStorage.retrieveFeedItems())
    }
}

final class FeedViewModel2: FeedViewModelInterface {
    
    private let feedService: FeedServiceInterface
    private let feedStorage: FeedStorageInterface
    
    init(feedService: FeedServiceInterface, feedStorage: FeedStorageInterface) {
        self.feedService = feedService
        self.feedStorage = feedStorage
    }
    
    func fetchNextPage(completion: @escaping (_ feedItems: [Feed]) -> Void) {
        
        feedService.fetchData { feedItems in
            
            if feedItems.count > 0 { // success, no data
                self.feedStorage.save(items: feedItems)
                completion(feedItems)
            } else { // false
                // product decides what to do here
            }
            
        }
    }
}














final class FeedViewModel: FeedViewModelInterface, ReachabilityNotifierObserverInterface {
    
    private let feedService: FeedServiceInterface
    private let feedStorage: FeedStorageInterface
    private let reachabilityNotifier: ReachabilityNotifierInterface
    private var lastNetworkStatus: Bool
    private var items = [Feed] // or page number
    
    init(feedService: FeedServiceInterface, feedStorage: FeedStorageInterface, reachabilityNotifier: ReachabilityNotifierInterface) {
        self.feedService = feedService
        self.feedStorage = feedStorage
        self.reachabilityNotifier = reachabilityNotifier
        self.lastNetworkStatus = reachabilityNotifier.lastNetworkStatus
        reachabilityNotifier.add(observer: self)
    }
    
    func fetchNextPage(completion: @escaping (_ feedItems: [Feed]) -> Void) {
        
        feedService.fetchData { feedItems in
            
            if feedItems.count == 0 { // failure, no data
                
                if self.lastNetworkStatus == false {
                    completion(self.feedStorage.retrieveFeedItems())
                } else {
                    // Product needs to decide what to do here, retry? error state?
                }
                
            } else { // success
                self.feedStorage.save(items: feedItems)
                completion(feedItems)
            }
            
            
        }
    }
    
    func networkStatusHasChanged(networkStatus: Bool) {
        self.lastNetworkStatus = networkStatus
    }
    
}
