import Foundation

struct AppspendItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var appName: String
    var amount: Double
}
