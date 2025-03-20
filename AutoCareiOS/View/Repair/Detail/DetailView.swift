import SwiftUI

struct DetailView: View {
    @EnvironmentObject var repairViewModel: RepairViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @State private var imagesRepair: [UIImage]? = []
    @State private var showCopyAlert = false
    @State private var copiedArticle = ""
    
    var repair: Repair
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                header
                
                // Info Cards
                infoCards
                
                // Description
                if let notes = repair.notes, !notes.isEmpty {
                    descriptionSection(notes: notes)
                }
                
                // Parts
                if let parts = repair.parts, !parts.isEmpty {
                    partsSection(parts: parts)
                }
                
                // Images
                if let images = imagesRepair, !images.isEmpty {
                    imagesSection(images: images)
                }
            }
            .padding()
        }
        .alert("Article \(copiedArticle) copied!", isPresented: $showCopyAlert) {
            Button("OK", role: .cancel) { }
        }
        .onAppear {
            loadImages()
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(repair.partReplaced ?? "Unknown part")
                .font(.title)
                .fontWeight(.bold)
            
            if let date = repair.repairDate {
                Text(date.formatted(.dateTime.year().month().day()))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var infoCards: some View {
        VStack(spacing: 16) {
            // Amount Card
            InfoCard(
                icon: "banknote.fill",
                title: "Amount",
                value: "\(repair.amount) \(settingsViewModel.currency)",
                color: .blue
            )
            
            // Mileage Card
            InfoCard(
                icon: "gauge",
                title: "Mileage",
                value: "\(repair.repairMileage) \(settingsViewModel.distanceUnit)",
                color: .green
            )
            
            // Category Card
            if let category = repair.repairCategory {
                InfoCard(
                    icon: "tag.fill",
                    title: "Category",
                    value: category,
                    color: .orange
                )
            }
        }
    }
    
    private func descriptionSection(notes: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Description", systemImage: "text.alignleft")
                .font(.headline)
            
            Text(notes)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func partsSection(parts: [String: String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Parts", systemImage: "wrench.and.screwdriver.fill")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(Array(parts.sorted { $0.key < $1.key }), id: \.key) { part in
                    HStack {
                        Button(action: {
                            copyToClipboard(text: part.key)
                            copiedArticle = part.key
                            showCopyAlert = true
                        }) {
                            Text(part.key)
                                .font(.system(.body, design: .monospaced))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.secondary.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        
                        Spacer()
                        
                        Text(part.value)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func imagesSection(images: [UIImage]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Photos", systemImage: "photo.stack.fill")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(images.indices, id: \.self) { index in
                        Image(uiImage: images[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 280, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private func loadImages() {
        if let repairImages = repairViewModel.getPhotosRepair(repair: repair) {
            imagesRepair = repairImages
        }
    }
    
    private func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

// MARK: - Supporting Views
struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    let context = CoreDataManaged.shared.context
    
    let repair = Repair(context: context)
    repair.partReplaced = "Brake pads"
    repair.amount = 100_000
    repair.repairMileage = 123_000
    repair.repairDate = Date()
    repair.notes = "Brake pads were replaced"
    repair.parts = ["EF31": "Generator", "E531": "Generator"]
    repair.repairCategory = "Service"
    
    return DetailView(repair: repair)
        .environmentObject(RepairViewModel())
        .environmentObject(SettingsViewModel())
}
