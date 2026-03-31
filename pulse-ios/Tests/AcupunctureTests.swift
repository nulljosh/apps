import Testing
@testable import Acupuncture

@Test func footZonesExist() {
    #expect(footZones.count == 16)
}

@Test func handZonesExist() {
    #expect(handZones.count == 11)
}

@Test func meridiansExist() {
    #expect(meridians.count == 11)
}

@Test func allPointsCount() {
    let points = getAllPoints()
    #expect(points.count >= 30)
}

@Test func symptomsExist() {
    #expect(symptoms.count == 12)
}

@Test func sessionStoreAddDelete() {
    let store = SessionStore()
    let initial = store.sessions.count
    store.add(Session(type: "reflexology", name: "Brain", area: "Foot"))
    #expect(store.sessions.count == initial + 1)
    let id = store.sessions.first!.id
    store.delete(id: id)
    #expect(store.sessions.count == initial)
}

@Test func symptomCrossReferences() {
    let allZones = footZones + handZones
    let allPoints = getAllPoints()
    for symptom in symptoms {
        for zoneId in symptom.reflexZones {
            #expect(allZones.contains { $0.id == zoneId }, "Missing zone \(zoneId) for symptom \(symptom.name)")
        }
        for pointId in symptom.acuPoints {
            #expect(allPoints.contains { $0.point.id == pointId }, "Missing point \(pointId) for symptom \(symptom.name)")
        }
    }
}
