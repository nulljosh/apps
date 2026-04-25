import Foundation

struct Subject: Identifiable, Equatable {
    let id: String
    let name: String
    let icon: String
    let level: String
}

struct Category: Identifiable {
    let id: String
    let title: String
    let icon: String
    let subjects: [Subject]
}
