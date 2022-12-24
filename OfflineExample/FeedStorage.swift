protocol FeedStorageInterface {
    func save(items: [Feed])
    func retrieveFeedItems() -> [Feed]
}

final class FeedStorage: FeedStorageInterface {
    func save(items: [Feed]) {
        
    }
    
    func retrieveFeedItems() -> [Feed] {
        return []
    }
}
