import SwiftData
import Foundation

let JOB_STATUSES = ["Lead", "Scheduled", "In Progress", "Done", "Cancelled"]
let JOB_SERVICES = [
    "Garage Door Repair", "Spring Replacement", "Cable Repair", "Maintenance",
    "Emergency Repair", "Hinge Replacement", "Keypad / Remote", "Panel Repair",
    "Weather Strip", "Roller Replacement", "Opener Repair", "Other",
]

@Model final class Job {
    var id: String
    var customer: String
    var address: String
    var phone: String
    var email: String
    var service: String
    var status: String
    var notes: String
    var scheduledAt: String
    var createdAt: String

    init(id: String = UUID().uuidString, customer: String, address: String = "",
         phone: String = "", email: String = "", service: String = "", status: String = "Lead",
         notes: String = "", scheduledAt: String = "",
         createdAt: String = ISO8601DateFormatter().string(from: Date())) {
        self.id = id; self.customer = customer; self.address = address
        self.phone = phone; self.email = email; self.service = service
        self.status = status; self.notes = notes; self.scheduledAt = scheduledAt
        self.createdAt = createdAt
    }

    var statusIndex: Int { JOB_STATUSES.firstIndex(of: status) ?? 0 }
    var canAdvance: Bool { statusIndex < JOB_STATUSES.count - 2 }
    func advance() { if canAdvance { status = JOB_STATUSES[statusIndex + 1] } }
}

struct JobData: Codable {
    var id, customer, address, phone, email, service, status, notes, scheduledAt, createdAt: String
}

extension Job {
    var data: JobData {
        JobData(id: id, customer: customer, address: address, phone: phone, email: email,
                service: service, status: status, notes: notes, scheduledAt: scheduledAt, createdAt: createdAt)
    }
    static func from(_ d: JobData) -> Job {
        Job(id: d.id, customer: d.customer, address: d.address, phone: d.phone, email: d.email,
            service: d.service, status: d.status, notes: d.notes, scheduledAt: d.scheduledAt, createdAt: d.createdAt)
    }
}
