import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var session: BeepSession
    @State private var showReload = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    BalanceCardView()
                    ReloadButton { showReload = true }
                    if !session.trips.isEmpty {
                        RecentTripsSection()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 4)
                .padding(.bottom, 24)
            }
            .refreshable { await session.refresh() }
            .navigationTitle("Compass")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showReload, onDismiss: {
            Task { await session.loadDashboard() }
        }) {
            ReloadSheetView()
        }
        .task {
            if session.trips.isEmpty {
                await session.loadTrips()
            }
        }
    }
}

struct BalanceCardView: View {
    @EnvironmentObject var session: BeepSession

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(red: 0, green: 0.44, blue: 0.89))

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Compass Card")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.85))
                    Spacer()
                    Image(systemName: "tram.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.9))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Balance")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white.opacity(0.7))
                    if session.isRefreshing && session.cardInfo == nil {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(.white.opacity(0.25))
                            .frame(width: 130, height: 48)
                    } else {
                        Text(session.cardInfo?.balance ?? "--")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                }

                HStack {
                    if let num = session.cardInfo?.cardNumber, !num.isEmpty {
                        Text(num)
                            .font(.system(.callout, design: .monospaced))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    Spacer()
                    if let info = session.cardInfo {
                        HStack(spacing: 5) {
                            Circle()
                                .fill(info.autoLoadEnabled ? Color.green : Color.white.opacity(0.4))
                                .frame(width: 6, height: 6)
                            Text(info.autoLoadEnabled ? "AutoLoad On" : "AutoLoad Off")
                                .font(.caption.weight(.semibold))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.18))
                        .clipShape(Capsule())
                        .foregroundStyle(.white.opacity(0.9))
                    }
                }
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity, minHeight: 196)
    }
}

struct ReloadButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                Text("Reload Card")
                    .font(.subheadline.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color(UIColor.secondarySystemBackground))
            .foregroundStyle(Color(red: 0, green: 0.44, blue: 0.89))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

struct RecentTripsSection: View {
    @EnvironmentObject var session: BeepSession

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Trips")
                .font(.headline)
            ForEach(session.trips.prefix(3)) { trip in
                TripRow(trip: trip)
                if trip.id != session.trips.prefix(3).last?.id {
                    Divider()
                }
            }
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
