import SwiftUI
import CoreLocation
import Photos

struct PetReportView: View {
    // State variables to store information about the pet and the report.
    @State private var petName = ""
    @State private var losingDate = Date()
    @State private var petType = ""
    @State private var breed = ""
    @State private var gender = true
    @State private var description = ""
    @State private var picture: Image?
    @State private var base64ImageString: String = ""
    @State private var showingImagePicker = false // Controls visibility of the image picker
    @State private var inputImage: UIImage? // The image selected by the user
    @State private var locationAdded = false // Flag to indicate if the location is added
    @State private var showingActionSheet = false // Controls visibility of the action sheet for choosing image source
    @State private var location = "" // Stores the last known location of the pet
    
    // State variables for image picking source and user contact information.
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    // ViewModel instances for handling location and camera functionalities.
    @StateObject private var locationViewModel = LocationViewModel()
    @StateObject private var cameraViewModel = CameraViewModel()
    
    // Environment variable to handle the view's presentation mode.
    @Environment(\.presentationMode) var presentationMode
    
    // Hardcoded user contact information.
    @State private var loadedUserId = 0
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    
    
    var receivedToken:String?
    
    var body: some View {
        NavigationView{
            Form {
                // Section for entering pet information.
                Section(header: Text("Pet Information").font(.headline).foregroundColor(.purple)) {
                    // Input fields for pet's name, date lost, type, and breed.
                    TextField("Pet Name", text: $petName)
                    DatePicker("Date Lost", selection: $losingDate, in: ...Date(), displayedComponents: .date)
                        .foregroundColor(.purple)
                    TextField("Pet Type", text: $petType)
                    TextField("Breed", text: $breed)
                    
                    // Toggle for selecting pet's gender.
                    Toggle(isOn: $gender) {
                        Text(gender ? "Male" : "Female")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: gender ? Color.purple : Color.pink))
                }
                
                // Section for entering a description of the pet.
                Section(header: Text("Description")) {
                    // A text editor for inputting a detailed description.
                    ZStack(alignment: .topLeading) {
                        if description.isEmpty {
                            Text("Description")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                                .padding(.top, 12)
                        }
                        TextEditor(text: $description)
                            .frame(minHeight: 100)
                            .padding(4)
                    }
                }
                
                // Section for uploading a photo of the pet.
                Section(header: Text("Pet Photo")) {
                    // Tap to show action sheet for photo source selection.
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(picture != nil ? Color.clear : Color.clear)
                        
                        if let picture = picture {
                            picture
                                .resizable()
                                .scaledToFit()
                        } else {
                            Text("Upload picture")
                                .foregroundColor(.purple)
                        }
                    }
                    .onTapGesture {
                        self.showingActionSheet = true
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 16))
                }
                
                // Section for adding the last known location of the pet.
                Section(header: Text("Last Location")) {
                    // Button to add the current location using the locationViewModel.
                    if locationAdded {
                        Text("Location added: \(locationViewModel.location?.latitude ?? 0), \(locationViewModel.location?.longitude ?? 0)")
                            .foregroundColor(.green)
                        
                    } else {
                        Button("Add my current location") {
                            locationViewModel.requestPermission()
                            locationViewModel.fetchCurrentLocation()
                            location = "\(locationViewModel.location?.latitude), \(locationViewModel.location?.longitude)"
                        }
                        .foregroundColor(.purple)
                    }
                }
                
                // Section for displaying the contact information of the user.
                Section(header: Text("Contact Information")) {
                    // Displaying full name, phone number, and email.
                    HStack {
                        Text("Full Name: ")
                            .bold()
                        Spacer()
                        Text("\(firstName) \(lastName)")
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    
                    HStack {
                        Text("Phone Number: ")
                            .bold()
                        Spacer()
                        Text(phoneNumber)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    
                    HStack {
                        Text("Email: ")
                            .bold()
                        Spacer()
                        Text(email)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
                .onAppear(){
                    Task {
                        await loadUserData()
                    }
                }
                .disabled(true)
                
                // Section with a button to submit the pet report.
                Section {
                    // Button for submitting the report, with handling in the submitPetReport function.
                    Button(action: {
                        Task {
                            await submitPetReport()
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Submit")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                    }
                    .listRowBackground(Color.clear)
                }
                
                .navigationTitle("Report Missing Pet")
                .navigationBarBackButtonHidden(true)
//                .navigationBarItems(leading: Button(action: {
//                    self.presentationMode.wrappedValue.dismiss()
//                }) {
//                    Image(systemName: "arrow.left")
//                        .foregroundColor(.blue)
//                })
                .actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(title: Text("Select Photo"), message: Text("Choose a source"), buttons: [
                        .default(Text("Camera")) {
                            cameraViewModel.checkCameraAuthorization { status in
                                if status == .authorized {
                                    self.sourceType = .camera
                                    self.showingImagePicker = true
                                } else {
                                    // Handle case where permission denied
                                }
                            }
                        },
                        .default(Text("Photo Library")) {
                            cameraViewModel.checkPhotoLibraryAuthorization { status in
                                if status == .authorized {
                                    self.sourceType = .photoLibrary
                                    self.showingImagePicker = true
                                } else {
                                    // Handle case where permission denied
                                }
                            }
                        },
                        .cancel()
                    ])
                }
                
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$inputImage, sourceType: self.sourceType)
                }
                
                .onAppear {
                    locationViewModel.checkIfLocationServicesIsEnabled()
                    locationAdded = locationViewModel.location != nil
                    locationViewModel.onLocationUpdate = { newLocation in
                        self.location = newLocation
                    }
                }
            }
            .navigationTitle("Add a Report")
        }
    }
    
    // Function to load the selected image and convert it to a base64 string.
    func loadImage(){
        // Resizing and compressing the image before converting it to base64.
        
        // Ensure the input image is available, else return.
        guard let inputImage = self.inputImage else { return }
        
        // Resize the image to a specified target size.
        let resizedImage = resizeImage(image: inputImage, targetSize: CGSize(width: 100, height: 100))
        
        // Compress the resized image to reduce its file size.
        // The compression quality is set to 0.5, indicating a moderate level of compression.
        let compressedImageData = resizedImage.jpegData(compressionQuality: 0.5)!
        
        // Convert the compressed image data to a base64 encoded string.
        // The encoding options specify that the base64 output should be split into lines of 64 characters each.
        let strBase64 = compressedImageData.base64EncodedString(options: .lineLength64Characters)
        
        // Store the base64 encoded string in a property for further use.
        self.base64ImageString = strBase64
        
        // Convert the resized image to an Image view and store it for display.
        self.picture = Image(uiImage: resizedImage)
    }
    
    func loadUserData() async{
        let urlString = "\(AppConfig.baseURL)/whoAmI"
        do{
            
            
            let userDetail = try await whoAmI(urlString: urlString, token: receivedToken!)
                    
                    // Setze die empfangenen Daten in die @State-Variablen
                    loadedUserId = userDetail.id!
                    lastName = userDetail.lastname
                    firstName = userDetail.firstname
                    email = userDetail.email
                    phoneNumber = userDetail.phoneNumber ?? ""
                   
                    
                    print("Userdetail: ", userDetail)
        }catch{
            print("UI-error: ",error)
        }
        print("Userdata loaded succesful ")
    }
    
    // Function to resize an image to a target size.
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        // Logic for resizing the image.
        
        // Get the current size of the image.
        let size = image.size

        // Calculate the width and height ratios to scale the image.
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Determine the new size of the image.
        var newSize: CGSize
        if widthRatio > heightRatio {
            // If width ratio is greater than height ratio, scale the image by the height ratio.
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            // If height ratio is greater or equal to the width ratio, scale the image by the width ratio.
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // Define the rectangle area to draw the new image in.
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Create a new image context with the new size and scale factor.
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect) // Draw the original image into the scaled rectangle.
        let newImage = UIGraphicsGetImageFromCurrentImageContext() // Extract the resized image from the context.
        UIGraphicsEndImageContext() // Close the image context.

        // Return the resized image.
        return newImage!
    }
        
    // Function for submitting the pet report.
        func submitPetReport() async {
            // URL string for the pet report submission endpoint.
            let urlString = "\(AppConfig.baseURL)/pet-reports"
            
            // Set up a closure to update the location when the locationViewModel gets new data.
            locationViewModel.onLocationUpdate = { newLocation in
                self.location = newLocation // Update the current location with the new location data.
            }

            // Create a reportDetail object with all the necessary details about the pet.
            let reportDetail = ReportDetail (
                petName: petName,
                petType: petType,
                petBreed: breed,
                petDescription: description,
                petGender: gender,
                dateReported: Int(losingDate.timeIntervalSince1970),
                petPicture: base64ImageString,
                isFound: false,
                location: location,
                userId: loadedUserId
            )
            
            // Try to submit the pet report using a POST request.
            do {
                try await postReport(urlString: urlString, reportDetail: reportDetail, token: receivedToken!) // Asynchronous call to post the report.
                print("Pet report successfully submitted") // Log message on successful submission.
            } catch {
                print("Error \(error)") // Log any errors encountered during the submission process.
            }
        }
        
    // ViewModel for managing the location services.
        class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
            // Properties and functions for handling location updates and permissions.
            @Published var location: CLLocationCoordinate2D?
            var onLocationUpdate: ((String) -> Void)?
            private let locationManager = CLLocationManager()
            
            // Initializes the ViewModel, sets up the location manager.
            override init() {
                super.init()
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            }
            
            // Checks if location services are enabled on the device.
            func checkIfLocationServicesIsEnabled() {
                if CLLocationManager.locationServicesEnabled() {
                    checkLocationAuthorization()
                } else {
                    print("Location services are not enabled")
                }
            }
            
            // Requests the user's permission for using location services when the app is in use.
            func requestPermission() {
                locationManager.requestWhenInUseAuthorization()
            }
            
            // Delegate method called when the location is updated.
            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                guard let location = locations.last else { return }
                DispatchQueue.main.async {
                    self.location = location.coordinate
                    let locationString = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
                    self.onLocationUpdate?(locationString)
                }
            }
            
            // Delegate method called when location authorization status changes.
            func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
                checkLocationAuthorization()
            }
            
            // Checks the current authorization status and acts accordingly.
            private func checkLocationAuthorization() {
                switch locationManager.authorizationStatus {
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                case .restricted, .denied:
                    // Handle denied case
                    print("Location not authorized")
                case .authorizedWhenInUse, .authorizedAlways:
                    fetchCurrentLocation() // trigger location fetching
                default:
                    break
                }
            }
            
            // Initiates a single request for the current location.
            func fetchCurrentLocation() {
                locationManager.requestLocation() // requests the location once
            }
            
            // Delegate method to handle failure in location updates.
            func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                print("Failed to find user's location: \(error.localizedDescription)")
            }
        }
        
    // ViewModel for managing camera and photo library access.
        class CameraViewModel: NSObject, ObservableObject {
            // Functions for checking camera and photo library authorization status.
            // Check camera permission (see Info.plist)
            func checkCameraAuthorization(completion: @escaping (_ status: AVAuthorizationStatus) -> Void) {
                switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        DispatchQueue.main.async {
                            completion(granted ? .authorized : .denied)
                        }
                    }
                case .authorized:
                    DispatchQueue.main.async {
                        completion(.authorized)
                    }
                case .denied, .restricted:
                    DispatchQueue.main.async {
                        completion(.denied)
                    }
                @unknown default:
                    DispatchQueue.main.async {
                        completion(.denied)
                    }
                }
            }
            
            // Check photo library permission (see Info.plist)
            func checkPhotoLibraryAuthorization(completion: @escaping (_ status: PHAuthorizationStatus) -> Void) {
                let status = PHPhotoLibrary.authorizationStatus()
                switch status {
                case .notDetermined:
                    PHPhotoLibrary.requestAuthorization { newStatus in
                        DispatchQueue.main.async {
                            completion(newStatus)
                        }
                    }
                case .authorized:
                    DispatchQueue.main.async {
                        completion(.authorized)
                    }
                case .denied, .restricted:
                    DispatchQueue.main.async {
                        completion(.denied)
                    }
                @unknown default:
                    DispatchQueue.main.async {
                        completion(.denied)
                    }
                }
            }
        }
        
    // A UIViewControllerRepresentable for integrating UIImagePickerController into SwiftUI.
    // Define a struct `ImagePicker` that conforms to `UIViewControllerRepresentable`.
    // This enables using UIKit's UIImagePickerController in SwiftUI.
    struct ImagePicker: UIViewControllerRepresentable {
        // Environment variable to manage the presentation mode of this view.
        @Environment(\.presentationMode) var presentationMode

        // A binding to an optional UIImage to store the selected image.
        @Binding var image: UIImage?

        // Source type for the image picker (camera, photo library, etc.)
        var sourceType: UIImagePickerController.SourceType

        // Function to create a coordinator for handling delegate callbacks.
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        // Creates the actual UIViewController (UIImagePickerController) to be presented.
        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType  // Set the source type (camera, photo library, etc.)
            picker.delegate = context.coordinator  // Set the delegate to the coordinator.
            picker.allowsEditing = false  // Disable editing in the picker.
            return picker
        }

        // Required by UIViewControllerRepresentable, but not used in this case.
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}

        // Coordinator class to act as a bridge for the UIImagePickerControllerDelegate and UINavigationControllerDelegate.
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            // Reference to the parent ImagePicker.
            let parent: ImagePicker

            // Initializer accepting the parent ImagePicker.
            init(_ parent: ImagePicker) {
                self.parent = parent
            }

            // Delegate method called when an image is picked.
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                // Extract the image from the picker and assign it to the parent's binding.
                if let uiImage = info[.originalImage] as? UIImage {
                    parent.image = uiImage
                }
                // Dismiss the picker.
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct PetReport_Previews: PreviewProvider {
    static var previews: some View {
        PetReportView()
    }
}
