import UIKit

final class FeedViewController: UIViewController {
    
    private let viewModel: FeedViewModelInterface
    
    init(viewModel: FeedViewModelInterface) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func userHasScrolledToTheBottom() {
        viewModel.fetchNextPage { feedItems in
            // refresh UI
        }
    }
    
}
