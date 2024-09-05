
//
//  PetReportDetail.swift
//  FindMyPet
//
//  Created by Erkan Kanat on 08.11.23.
//
import SwiftUI
struct PetReportDetail: View {
    @State private var hasReported : Bool
    @State private var petName = "Bello"
    @State private var losingDate = Date()
    @State private var petType = "dog"
    @State private var breed = ""
    @State private var gender = true
    @State private var description = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et"
    @State private var picture: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var locationAdded = false
    @State private var showingActionSheet = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    

    @State private var showingRouteMapView = false

    @State private var showAlert = false
    @State private var isDeleteConfirmed : Bool

   
  //  @State var pet = ReportDetail(petName: "Bello", petType: "Dog", petBreed: "Dog", petDescription: "DESCRIPTIPON", petGender: false, dateReported: 2222222, petPicture: "Empty", isFound: false, location: "", userId: 100)

    @State private var showingContacts = false
    //Check -> Other users will get the buttons
  var report: ReportDetail
    var user: UserDetail
    var receivedToken: String
    
    init(report: ReportDetail, user: UserDetail, receivedToken: String = ""){
        self.report = report
        self.user = user
        self.receivedToken = receivedToken
        _hasReported = State(initialValue: user.id == report.userId)
        _isDeleteConfirmed = State(initialValue: false)
    }
    
    var body: some View {
        
      
        
        NavigationView {
        ScrollView{
        
            
            VStack {
        
             
                MapView(petReports: [ReportDetail.init(petName: report.petName, petType: report.petType, petBreed: report.petBreed, petDescription: report.petDescription, petGender: report.petGender, dateReported: 22222, petPicture: report.petPicture, isFound: report.isFound, location: report.location, userId: report.userId)])
                    .frame(height:320)
//
//                   
               
                
                
                CircleImage(report: report)
                    .offset(y:-90)
                    .padding(.bottom,-100)
            
                
                
                
                VStack(alignment: .leading) {
                    
               
                    HStack{
                        
                        //Für andere User ist es Contact
                        //Für die Ansicht hasPublished ist es dann Edit
                        if hasReported{
                            
                            NavigationLink(destination: EditReportView( report: report, receivedToken: receivedToken)){
                                Text("Edit")
                                    .font(.title2)
                            }
                        
                                .font(.title2)
                                .frame(width: 110, height: 10)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(20)
                                .shadow(color: .black, radius: 5)
                            
                        }
                           
                       Spacer()
                        
                        //FÜr die Ansicht eines anderen Users ist die mitte ein Speichern (Herz)
                        //Für die Ansicht eines hasPublished ist es dann Delete
                        
                        if hasReported {
                            Button("Delete") {
                                  showAlert = true
                              }
                              .font(.title2)
                              .frame(width: 110, height: 10)
                              .padding()
                              .background(Color.white)
                              .foregroundColor(.black)
                              .cornerRadius(20)
                              .shadow(color: .black, radius: 5)
                              .disabled(!hasReported)
                              .alert(isPresented: $showAlert) {
                                  Alert(
                                      title: Text("Confirm Deletion"),
                                      message: Text("Are you sure you want to delete the report?"),
                                      primaryButton: .destructive(Text("Delete")) {
                                          isDeleteConfirmed = true
                                      },
                                      secondaryButton: .cancel(Text("Cancel"))
                                  )
                              }
                              .onChange(of: isDeleteConfirmed) { newValue in
                                  if newValue {
                                      // Hier wird der Code ausgeführt, wenn isDeleteConfirmed true ist
                                      Task {
                                          await deleteReport(report: report, receivedToken: receivedToken)
                                          // Setze die Variable zurück, um zukünftige Löschvorgänge zu behandeln
                                          isDeleteConfirmed = false
                                      }
                                  }
                              }
                          }
                              
                                
                     else{
                         Button("Route"){showingRouteMapView = true}
                             .font(.title2)
                             .frame(width: 110, height: 10)
                             .padding()
                             .background(Color.white)
                             .foregroundColor(.black)
                             .cornerRadius(20)
                             .shadow(color: .purple, radius: 5)
                             .disabled(hasReported)
                         
                             }
                        }

                       

                    }
                    //End HSTACK
                    
                    HStack{
                        Text("\(report.petName)")
                            .font(.title)
                         
                        HStack{
                            Text("Last Seen")
                            if let formattedDate = formattedDateString(from: TimeInterval(report.dateReported)) {
                                   Text(formattedDate)
                                       .fontDesign(.monospaced)
                               }
                        }
                            
                        
                       
                     
                    }
                    
                   
                    Divider()
                  
                    NavigationView{
                        
                        Form{
                            Section(header: Text("Pet Information")){
                                
                                HStack(){
                                    Text("Name")
                                    
                                    Spacer()
                                    
                                    Text("\(report.petName)")
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                        .frame(width: 100,height: 10)
                                    
                                    
                                }
                                HStack(){
                                    Text("Type")
                                    
                                    Spacer()
                                    Text("\(report.petType)")
                                        .lineLimit(1)
                                        .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)                                       .frame(width: 100,height: 10)
                                    
                                    
                                }
                                HStack(){
                                    Text("Gender")
                                    
                                    
                                    Spacer()
                                    if(report.petGender){
                                        Text("Male")
                                            .lineLimit(1)
                                            .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                                        
                                            .padding()
                                            .frame(width: 100,height: 10)
                                        
                                    } else{
                                        Text("Female")
                                            .lineLimit(1)
                                            .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                                        
                                        
                                            .frame(width: 100,height: 10)
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                                HStack(){
                                    Text("Descripton ")
                                    
                                    
                                    
                                    Spacer()
                                    Text(report.petDescription)
                                        .lineLimit(5)
                                    //.truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                                    
                                        .padding()
                                    
                                }
                                HStack(){
                                    Text("Runs out in")
                                    if let expirationDate = Calendar.current.date(byAdding: .day, value: 30, to: Date(timeIntervalSince1970: TimeInterval(report.dateReported))) {
                                        let remainingDays = Calendar.current.dateComponents([.day], from: Date(), to: expirationDate).day ?? 0
                                        
                                        Spacer()
                                        
                                        Text("\(remainingDays) days")
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                            .padding()
                                            .frame(width: 100, height: 10)
                                    }
                                }
                                
                                HStack() {
                                    Text("Name: ")
                                    Text("\(user.firstname) \(user.lastname)")
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .padding()
                                        .frame(width: 200, height: 10)
                                }
                                HStack() {
                                    Text("Mobile: ")
                                    Text("\(user.phoneNumber)")
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .padding()
                                        .frame(width: 200, height: 10)
                                }
                                HStack() {
                                    Text("Email: ")
                                        Text("\(user.email)")
                                        .lineLimit(1)
                                        .padding()
                                        .frame(width: 200, height: 10)
                                }
                                
                                
                                
                                
                                
                                
                                
                            }
                            
                            
                            
                            
                            

                        }

               
                        
                        
                    }

                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                   
                    //END VSTACK
                }
                .padding()
               // Spacer()
                
            }
            
            
        }
        .sheet(isPresented: $showingRouteMapView) {
            RouteMapView(report: report)
        }
        
        .edgesIgnoringSafeArea(.top)
     //   .background(Color(red:0xEA/255,green: 0xF4/255,blue: 0xF4/255))
    }
    }

    func deleteReport(report: ReportDetail, receivedToken: String) async {
        let urlString = "\(AppConfig.baseURL)/pet-reports/"

        do {
            try await FindMyPet.deleteReport(urlString: urlString, reportDetail: report, token: receivedToken)
            print("Bericht erfolgreich gelöscht.")

        } catch {
            print("Fehler beim Löschen des Berichts: \(error)")
        }
    }
    
    func formattedDateString(from timestamp: TimeInterval) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = Date(timeIntervalSince1970: timestamp)
        return dateFormatter.string(from: date)
    }

    
    
    
    
    


