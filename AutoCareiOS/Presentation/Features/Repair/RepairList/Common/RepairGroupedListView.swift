//
//  RepairGroupedListView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 31.07.2025.
//

import SwiftUI

struct RepairGroupedListView: View {
    let groupedRepairs: [RepairGroup]

    @Binding var searchText: String
    @Binding var showTapBar: Bool

    private var filteredGroups: [RepairGroup] {
        if searchText.isEmpty {
            return groupedRepairs
        }

        let query = searchText.lowercased()

        return groupedRepairs.compactMap { group in
            let filtered = group.repairs.filter {
                $0.partReplaced.lowercased().contains(query) ||
                ($0.notes?.lowercased().contains(query) ?? false)
            }

            guard !filtered.isEmpty else { return nil }

            return RepairGroup(
                monthTitle: group.monthTitle,
                repairs: filtered,
                totalAmount: filtered.reduce(0) { $0 + Double($1.amount) }
            )
        }
    }

    var body: some View {
        ForEach(filteredGroups, id: \.id) { group in
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(group.monthTitle)
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Text("\(group.totalAmount)")
                        .font(.subheadline.weight(.semibold).monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 2)
                .padding(.top, 12)
                .padding(.bottom, 6)

                ForEach(group.repairs) { repair in
                    NavigationLink {
                        DetailRepairView(repair: repair)
                            .onAppear { showTapBar = false }
                            .onDisappear { showTapBar = true }
                    } label: {
                        ListRowView(repair: repair)
                            .padding(.vertical, 7)
                            .padding(.horizontal, 5)
                    }
                    .contextMenu {
                        Button("Delete repair", role: .destructive) {
                            // Пока ничего не делаем — будет через callback позже
                        }
                    }
                }
            }
        }
    }
}
