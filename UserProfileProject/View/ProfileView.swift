//
//  ProfileView.swift
//  UserProfileProject
//
//  Created by Alexey Kiselev on 19.03.2024.
//
import SwiftUI

struct ProfileView: View {
    @State var userProfile: UserProfile
    @Binding var isPresented: Bool
    
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary

    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    
    init(userProfile: UserProfile, isPresented: Binding<Bool>) {
        self.userProfile = userProfile
        self._isPresented = isPresented
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Фото профиля")) {
                    // Отображение фото профиля или аватара по умолчанию
                    (image?.resizable().scaledToFit() ?? Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit())
                        .onTapGesture {
                            showingActionSheet = true
                        }
                }
                // Секция с полями ввода
                Section(header: Text("Информация")) {
                    TextField("Фамилия", text: $userProfile.lastName)
                    TextField("Имя", text: $userProfile.firstName)
                    TextField("Отчество", text: $userProfile.patronymic)
                    TextField("Никнейм", text: $userProfile.nickname)
                    TextField("Email", text: $userProfile.email)
                    TextField("Телефон", text: $userProfile.phone)
                    TextField("Телеграм", text: $userProfile.telegram)
                }
                // кнопки
                Section {
                    Button("Сохранить"){
                        userProfile.saveToUserDefaults()
                        isPresented = false
                    }
                    Button("Отмена") {
                        isPresented = false
                    }
                }
            }
            .navigationBarTitle("Профиль", displayMode: .inline)
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage, sourceType: imageSource)
            }
            // actionSheet для выбора способа добавления фото
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Выберите источник фото"), message: nil, buttons: [
                    .default(Text("Камера")) {
                        self.imageSource = .camera
                        self.showingImagePicker = true
                    },
                    .default(Text("Галерея")) {
                        self.imageSource = .photoLibrary
                        self.showingImagePicker = true
                    },
                    .cancel()
                ])
            }
            .onAppear{
                loadImageFromUserProfile()
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        
        if let imageUrl = saveImageToFileSystem(inputImage) {
            // Сохраняем относительный путь к изображению в профиле
            userProfile.photoURL = imageUrl.lastPathComponent
        }
    }
    
    func saveImageToFileSystem(_ image: UIImage) -> URL? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
        
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filename = documentsDirectory.appendingPathComponent(UUID().uuidString + ".jpeg")
        
        do {
            try imageData.write(to: filename)
            return filename
        } catch {
            print("Ошибка сохранения изображения: \(error)")
            return nil
        }
    }
    
    func loadImageFromUserProfile() {
        // загружаем фото, соединив относительный и абсолютный пути
        if let relativePath = userProfile.photoURL{
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fullPath = documentsDirectory.appendingPathComponent(relativePath)
            if let uiImage = UIImage(contentsOfFile: fullPath.path ) {
                image = Image(uiImage: uiImage)
            }
        }
    }
}

