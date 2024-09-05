//
//  ProfileView.swift
//  FindMyPet
//
//  Created by Jan Schnetger on 12.11.23.
//

import SwiftUI
import CoreLocation

struct ProfileView: View {
    
    @State private var id: Int = 0
    @State private var lastName: String = ""
    @State private var firstName: String = ""
    @State private var eMail: String = ""
    @State private var phoneNumber: String = ""
    @State private var password: String = "*************"

    @State private var successfullReports: String = ""
    @State private var shouldNavigateToEditProfile = false
    @State private var deleteprofile = false
    
    @State private var editProfile = false
    
    @State private var showingDeleteAlert = false
    
    
    
    var receivedToken: String?
    // var receivedToken:String?

    @State private var activeReports: Int = 0



    
    
    var body: some View {
        
     
        
        NavigationView{
            
            Form {
                
                //user datas
                Section(header:Text("Your Information")){
                    
                    
                    //users last name
                    HStack{
                        Text("Last Name: ")
                        Spacer()
                        
                        Text(lastName)
                    }
                    //users first name
                    HStack{
                        Text("First Name: ")
                        Spacer()
                        Text(firstName)
                    }
                    //users email
                    HStack{
                        Text("E-Mail: ")
                        Spacer()
                        Text(eMail)
                    }
                    //users phone number
                    HStack{
                        Text("Phone Number: ")
                        Spacer()
                        Text(phoneNumber)
                    }
                    
                    
                }
                .onAppear(){
                    
                    Task {
                        //load userprofile data with function
                        await loadUserData()
                    }
                }
                
                
                //users reports
                Section(header: Text("Your Reports")){
                    
                    HStack{
                        Text("Active reports: ")
                        Spacer()
                        Text("\(activeReports)")
                    }
                }
                
                
              
                
                //Actionbuttons
                Section(header: Text("")){
                    
                    //change password button
                  //  Button {
                      //  Task {
                      //      await changePassword()
                      //  }
                   // } label: {
                   //     HStack {
                   //         Spacer()
                  //          Text("Change Password")
                 //               .foregroundColor(.white)
                  //              .fontWeight(.bold)
                  //          Spacer()
                  //      }
                  //      .padding()
                  //      .background(Color.purple)
                  //      .cornerRadius(10)
                 //   }
                 //   .listRowBackground(Color.clear)
                    
                    if(shouldNavigateToEditProfile){
                        NavigationLink(destination: EditProfileView(receivedToken: receivedToken), isActive: $editProfile) {
                            EmptyView()
                       }
                        .isDetailLink(false)
                       .hidden()
                   }
                 
                   
                    //edit profile button
                    Button {

                        editProfileFunc()

                    } label: {
                        HStack {
                            Spacer()
                            Text("Edit Profile")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                    }
                    .listRowBackground(Color.clear)
                    
                    
                    
                    //delete profile button
                    Button {
                        showingDeleteAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete Profile")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                    }
                    .listRowBackground(Color.clear)
                    .alert(isPresented: $showingDeleteAlert) {
                        Alert(
                            title:  Text("Delete Profile"),
                            message: Text("Are you sure you want to delete your profile? This action cannot be undone."),
                            primaryButton: .destructive(Text("Delete")) {
                                // Call your deleteProfile function here
                                Task {
                                    await deleteProfile()
                                    deleteprofile = true
                                }
                            },
                            secondaryButton: .cancel(Text("Cancel"))
                        )
                    }
                    
                }
                                        
                }
                .navigationTitle("Profile")
                
            
            
          
           
            }
        }

        
        
        //function to edit profile
        func editProfileFunc() {
            shouldNavigateToEditProfile = true
            
            
            editProfile = true
           
            
            print("Went to EditProfileView")
            
        }
        
        //function to delete a profile
        func deleteProfile() async {
            
            
            
            
            let urlString = "\(AppConfig.baseURL)/users"
            
            let userDetail = UserDetail (
                id: id,
                firstname: firstName,
                lastname: lastName,
                email: eMail,
                password: password,
                phoneNumber: phoneNumber
            )
            
            print(userDetail)
            do{
                try await deleteUser(urlString: urlString, userDetail: userDetail, token: receivedToken!)
                print("Successfully")
                
                exit(0)
                
                
            }
            catch{
                print("Error\(error)")
            }
            
            // deleteUser(url,UserDetail)
            
        }
        
        //function to create a report
        func createReport() {
            
            print("Create Report")
        }
        
        

    
    
    
    //function to change a a password
    func changePassword() async {
       
    }
    
    //function to load userdata
    func loadUserData() async{
        let urlString = "\(AppConfig.baseURL)/whoAmI"
        let urlString2 = "\(AppConfig.baseURL)"
        
        do{
            
            let userDetail = try await whoAmI(urlString: urlString, token: receivedToken!)
            
            id = userDetail.id ?? 0
            lastName = userDetail.lastname
            firstName = userDetail.firstname
            eMail = userDetail.email
            phoneNumber = userDetail.phoneNumber ?? ""
            password = userDetail.password ?? ""
            
            try await Task {
                do {
                    let petReports = try await getUserPetReports(urlString: urlString2, userID: userDetail.id ?? 0)
                    
                    let numberOfPetReports=petReports.count
                    activeReports=numberOfPetReports
                    
                    // Handle the fetched petReports here
                    print("Fetched Pet Reports: \(petReports)")
                    
                    // Set the fetched pet reports to a @State variable if needed
                    // ...
                } catch {
                    print("Error fetching pet reports: \(error)")
                    // Handle or propagate the error as needed
                }
            }
            
            
            print("Userdetail: ", userDetail)
        }catch{
            print("UI-error: ",error)
            
        }
    }
        //function to load userdata
   
        
        //function to replace a string with stars (for password)
        func replaceWithStars(originalString: String) -> String {
            let stars = String(repeating: "*", count: originalString.count)
            return stars
        }
    
   
    }




    
    #Preview {
        ProfileView()
    }
