import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var session: BeepSession
    @State private var showReloadPicker = false
    @State private var showReload = false
    @State private var showAutoLoad = false
    @State private var pendingAmount: Int? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    BalanceCardView(onAutoLoadTap: { showAutoLoad = true })
                    ReloadButton { showReloadPicker = true }
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
        .sheet(isPresented: $showReloadPicker) {
            ReloadPickerView { amount in
                pendingAmount = amount
                showReloadPicker = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    showReload = true
                }
            }
        }
        .sheet(isPresented: $showReload, onDismiss: {
            Task { await session.loadDashboard() }
        }) {
            ReloadSheetView(prefilledAmount: pendingAmount)
        }
        .sheet(isPresented: $showAutoLoad, onDismiss: {
            Task { await session.loadDashboard() }
        }) {
            AutoLoadSheetView()
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
    var onAutoLoadTap: () -> Void = {}

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
                        Button(action: onAutoLoadTap) {
                            HStack(spacing: 5) {
                                Circle()
                                    .fill(info.autoLoadEnabled ? Color.green : Color.white.opacity(0.4))
                                    .frame(width: 6, height: 6)
                                Text(info.autoLoadEnabled ? "AutoLoad On" : "AutoLoad Off")
                                    .font(.caption.weight(.semibold))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 9, weight: .semibold))
                                    .opacity(0.7)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.white.opacity(0.18))
                            .clipShape(Capsule())
                            .foregroundStyle(.white.opacity(0.9))
                        }
                        .buttonStyle(.plain)
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

struct ReloadPickerView: View {
    let onConfirm: (Int) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAmount = 20
    @State private var customText = ""
    @State private var useCustom = false

    let presets = [10, 20, 50, 100]

    private var finalAmount: Int {
        useCustom ? (Int(customText) ?? 0) : selectedAmount
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Text("Select Amount")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(presets, id: \.self) { amount in
                            Button {
                                selectedAmount = amount
                                useCustom = false
                            } label: {
                                Text("$\(amount)")
                                    .font(.title3.weight(.semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .background(!useCustom && selectedAmount == amount
                                        ? Color(red: 0, green: 0.44, blue: 0.89)
                                        : Color(UIColor.secondarySystemGroupedBackground))
                                    .foregroundStyle(!useCustom && selectedAmount == amount ? .white : .primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Divider()

                    Toggle("Custom amount", isOn: $useCustom)

                    if useCustom {
                        HStack(spacing: 4) {
                            Text("$")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(.secondary)
                            TextField("Amount", text: $customText)
                                .keyboardType(.numberPad)
                                .font(.title3.weight(.semibold))
                        }
                        .padding(14)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                Button {
                    onConfirm(finalAmount)
                } label: {
                    Text("Continue to Payment")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(finalAmount > 0
                            ? Color(red: 0, green: 0.44, blue: 0.89)
                            : Color.secondary.opacity(0.25))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(finalAmount <= 0)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .navigationTitle("Reload Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
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
