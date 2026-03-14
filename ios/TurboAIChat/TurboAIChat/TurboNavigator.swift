import UIKit
import Turbo
import WebKit
import os.log

private let log = OSLog(subsystem: "TurboAIChat", category: "TurboNavigator")

final class TurboNavigator: NSObject {
    static let shared = TurboNavigator()

    let navigationController = UINavigationController()

    private lazy var session: Session = {
        let config = WKWebViewConfiguration()
        // Передаём кастомный User-Agent чтобы Rails знал что это нативное приложение
        config.applicationNameForUserAgent = Configuration.userAgent

        let session = Session(webViewConfiguration: config)
        session.delegate = self
        return session
    }()

    func route(to url: URL) {
        os_log("Загрузка URL: %{public}@", log: log, type: .info, url.absoluteString)
        let proposal = VisitProposal(url: url, options: VisitOptions(action: .advance))
        visit(proposal)
    }

    private func visit(_ proposal: VisitProposal) {
        let vc = TurboWebViewController(url: proposal.url)
        switch proposal.options.action {
        case .advance:
            navigationController.pushViewController(vc, animated: true)
        case .replace:
            navigationController.setViewControllers([vc], animated: false)
        default:
            navigationController.pushViewController(vc, animated: true)
        }
        session.visit(vc)
    }
}

// MARK: - SessionDelegate
extension TurboNavigator: SessionDelegate {
    func session(_ session: Session, didProposeVisit proposal: VisitProposal) {
        visit(proposal)
    }

    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, error: Error) {
        let nsError = error as NSError
        let debugInfo = """
        \(error.localizedDescription)
        Domain: \(nsError.domain)
        Code: \(nsError.code)
        URL: \(Configuration.rootURL.absoluteString)
        """
        os_log("Ошибка загрузки: %{public}@", log: log, type: .error, debugInfo)

        let alert = UIAlertController(
            title: "Ошибка загрузки",
            message: debugInfo,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in session.reload() })
        navigationController.present(alert, animated: true)
    }

    func sessionWebViewProcessDidTerminate(_ session: Session) {
        session.reload()
    }

    func session(_ session: Session, openExternalURL url: URL) {
        UIApplication.shared.open(url)
    }
}
