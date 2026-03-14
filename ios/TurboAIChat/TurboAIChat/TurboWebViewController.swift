import UIKit
import Turbo
import WebKit

final class TurboWebViewController: VisitableViewController {
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        self.visitableURL = url
    }

    required init?(coder: NSCoder) { fatalError() }
}
