import SwiftUI

struct TripsView: View {
    @EnvironmentObject var session: CompassSession

    var body: some View {
        NavigationStack {
            Group {
                if session.trips.isEmpty && !session.isRefreshing {
                    EmptyTripsView()
                } else {
                    List {
                        ForEach(session.trips) { trip in
                            TripRow(trip: trip)
                                .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .refreshable { await session.loadTrips() }
            .navigationTitle("Trips")
            .overlay {
                if session.isRefreshing && session.trips.isEmpty {
                    ProgressView()
                }
            }
        }
    }
}

struct TripRow: View {
    let trip: TripRecord

    var amountColor: Color {
        if trip.amount.hasPrefix("-") { return .red }
        if trip.amount.hasPrefix("+") { return .green }
        return .primary
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(trip.location.isEmpty ? (trip.product.isEmpty ? "Trip" : trip.product) : trip.location)
                    .font(.subheadline.weight(.medium))
                    .lineLimit(1)
                Group {
                    if !trip.date.isEmpty && !trip.product.isEmpty && !trip.location.isEmpty {
                        Text("\(trip.date) · \(trip.product)")
                    } else if !trip.date.isEmpty {
                        Text(trip.date)
                    } else if !trip.product.isEmpty {
                        Text(trip.product)
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                if !trip.amount.isEmpty {
                    Text(trip.amount)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(amountColor)
                }
                if !trip.balance.isEmpty {
                    Text(trip.balance)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 2)
    }
}

struct EmptyTripsView: View {
    @EnvironmentObject var session: CompassSession

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tram")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No Trips")
                .font(.title3.weight(.semibold))
            Text("Your recent trips will appear here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button("Load Trips") {
                Task { await session.loadTrips() }
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0, green: 0.44, blue: 0.89))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
