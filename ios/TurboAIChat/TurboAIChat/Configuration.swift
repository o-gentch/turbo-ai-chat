import Foundation

enum Configuration {
    // Меняй URL в зависимости от окружения:
    // - Симулятор:  http://localhost:3000
    // - Реальный iPhone (в той же Wi-Fi сети): http://192.168.x.x:3000
    // - Продакшн:   https://your-domain.com

    static let rootURL = URL(string: "http://192.168.100.8:3000")!

    // User-Agent — по нему Rails определяет turbo_native_app?
    static let userAgent = "Turbo Native iOS"
}
