struct Feed {
    
}

protocol FeedServiceInterface {
    func fetchData(completion: @escaping (_ feeds: [Feed]) -> Void)
}

final class FeedService: FeedServiceInterface {
    func fetchData(completion: @escaping (_ feeds: [Feed]) -> Void) {
        
    }
}
