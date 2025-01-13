import SwiftUI
import SwiftData
import PhotosUI

struct AddObservationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedPlanet: Planet = .earth
    @State private var customPlanet = ""
    @State private var category = ObservationCategory.other
    @State private var importance = ImportanceLevel.medium
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var useCustomImages = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Images") {
                    Toggle("Use Custom Images", isOn: $useCustomImages)
                    
                    if useCustomImages {
                        PhotosPicker(selection: $selectedItems,
                                   maxSelectionCount: 10,
                                   matching: .images,
                                   photoLibrary: .shared()) {
                            Label("Select Images", systemImage: "photo.stack")
                        }
                        
                        if !selectedImages.isEmpty {
                            TabView {
                                ForEach(selectedImages, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 200)
                                }
                            }
                            .frame(height: 200)
                            .tabViewStyle(.page)
                            .indexViewStyle(.page(backgroundDisplayMode: .always))
                            
                            // Thumbnails Grid
                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(selectedImages.indices, id: \.self) { index in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: selectedImages[index])
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 80, height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                        
                                        Button {
                                            selectedImages.remove(at: index)
                                            selectedItems.remove(at: index)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(.white, Color(.systemGray3))
                                                .background(Circle().fill(Color.black.opacity(0.5)))
                                        }
                                        .offset(x: 6, y: -6)
                                    }
                                }
                            }
                            .padding(.top, 8)
                        } else {
                            ContentUnavailableView("No Images Selected", 
                                systemImage: "photo.stack",
                                description: Text("Select up to 10 images"))
                                .frame(height: 200)
                        }
                    } else {
                        selectedPlanet.defaultImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 3)
                            .padding(.horizontal)
                    }
                }
                
                Section("Basic Information") {
                    TextField("Title", text: $title)
                    
                    Picker("Planet", selection: $selectedPlanet) {
                        ForEach(Planet.allCases, id: \.self) { planet in
                            Text(planet.rawValue).tag(planet)
                        }
                    }
                    
                    if selectedPlanet == .other {
                        TextField("Custom planet name", text: $customPlanet)
                    }
                }
                
                Section("Description") {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                        .overlay(alignment: .topLeading) {
                            if description.isEmpty {
                                Text("Describe your observation...")
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                                    .padding(.leading, 5)
                            }
                        }
                }
                
                Section {
                    Picker("Category", selection: $category) {
                        ForEach(ObservationCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    
                    Picker("Importance", selection: $importance) {
                        ForEach(ImportanceLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                } header: {
                    Text("Classification")
                }
            }
            .navigationTitle("New Observation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveObservation()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
        .onChange(of: selectedItems) { oldValue, newValue in
            Task {
                selectedImages.removeAll()
                
                for item in newValue {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImages.append(image)
                    }
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !title.isEmpty && 
        !description.isEmpty && 
        (selectedPlanet != .other || !customPlanet.isEmpty)
    }
    
    private func saveObservation() {
        var mainImageData: Data? = nil
        var additionalImagesData: [Data] = []
        
        if useCustomImages && !selectedImages.isEmpty {
            // Primera imagen como principal
            mainImageData = selectedImages[0].jpegData(compressionQuality: 0.8)
            
            // Resto de imágenes como adicionales
            if selectedImages.count > 1 {
                additionalImagesData = selectedImages[1...].compactMap { $0.jpegData(compressionQuality: 0.8) }
            }
        }
        
        let observation = UserObservation(
            title: title,
            description: description,
            selectedPlanet: selectedPlanet,
            customPlanet: selectedPlanet == .other ? customPlanet : nil,
            category: category,
            importance: importance,
            customImage: mainImageData,
            additionalImages: additionalImagesData.isEmpty ? nil : additionalImagesData
        )
        modelContext.insert(observation)
        dismiss()
    }
}

// Extension para el placeholder del TextEditor
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
