struct AddObservationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedPlanet: Planet = .earth
    @State private var customPlanet = ""
    @State private var category = ObservationCategory.other
    @State private var importance = ImportanceLevel.medium
    @State private var selectedItem: PhotosPickerItem?
    @State private var customImage: UIImage?
    @State private var useCustomImage = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Image") {
                    Toggle("Use Custom Image", isOn: $useCustomImage)
                    
                    if useCustomImage {
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            if let customImage {
                                Image(uiImage: customImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(radius: 3)
                                    .padding(.horizontal)
                            } else {
                                ContentUnavailableView("No Image Selected", 
                                    systemImage: "photo.badge.plus",
                                    description: Text("Tap to select an image"))
                                    .frame(height: 200)
                            }
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
                        .textInputAutocapitalization(.words)
                        .placeholder(when: title.isEmpty) {
                            Text("Enter observation title")
                                .foregroundColor(.gray)
                        }
                    
                    Picker("Planet", selection: $selectedPlanet) {
                        ForEach(Planet.allCases, id: \.self) { planet in
                            Text(planet.rawValue).tag(planet)
                        }
                    }
                    
                    if selectedPlanet == .other {
                        TextField("Custom planet name", text: $customPlanet)
                            .textInputAutocapitalization(.words)
                            .placeholder(when: customPlanet.isEmpty) {
                                Text("Enter planet name")
                                    .foregroundColor(.gray)
                            }
                    }
                }
                
                Section("Description") {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                        .placeholder(when: description.isEmpty) {
                            Text("Describe your observation in detail...")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.leading, 4)
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
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        customImage = image
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
        var imageData: Data? = nil
        if useCustomImage, let customImage {
            imageData = customImage.jpegData(compressionQuality: 0.8)
        }
        
        let observation = UserObservation(
            title: title,
            description: description,
            selectedPlanet: selectedPlanet,
            customPlanet: selectedPlanet == .other ? customPlanet : nil,
            category: category,
            importance: importance,
            customImage: imageData
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
