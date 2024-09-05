//
//  ProfileView.swift
//  FindMyPet
//
//  Created by Jan Schnetger on 12.11.23.
//

import SwiftUI
import CoreLocation

struct EditProfileView: View {
    
    @State private var id: Int = 0
    @State private var lastName: String = ""
    @State private var firstName: String = ""
    @State private var eMail: String = ""
    @State private var phoneNumber: String = ""
    @State private var password: String = "*************"
    @State private var successfullReports: String = ""
    
    
    @State private var lastNameNew: String = ""
    @State private var firstNameNew: String = ""
    @State private var phoneNumberNew: String = ""
    
    
    @State private var editProfile=false
    
    @State private var showingEditAlert = false
    
    var receivedToken: String?
    // var receivedToken:String?
    
    
    var body: some View {
        
        NavigationView{
            
            Form {
                //user datas
                Section(header:Text("Your Profile data")){
                    
                    //users last name
                    HStack{
                        Text("Last name: ")
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
                        Text("Phone number: ")
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
                
                
                
                Section(header: Text("Edit your profile data")){
                    
                    
                    
                    //users last name
                    HStack{
                        Text("Last name: ")
                        Spacer()
                        
                        TextField("Last name",text: $lastNameNew)
                            .padding()
                            .frame(width: 148, height: 50)
                            .background(Color.purple.opacity(0.05))
                            .cornerRadius(10)
                            .foregroundColor(.purple)
                    }
                    //users first name
                    HStack{
                        Text("First Name: ")
                        Spacer()
                        TextField("First name",text: $firstNameNew)
                            .padding()
                            .frame(width: 148, height: 50)
                            .background(Color.purple.opacity(0.05))
                            .cornerRadius(10)
                            .foregroundColor(.purple)
                    }
                    
                    
                    
                    //users phone number
                    HStack{
                        Text("Phone number: ")
                        Spacer()
                        TextField("Phone number",text: $phoneNumberNew)
                            .padding()
                            .frame(width: 148, height: 50)
                            .background(Color.purple.opacity(0.05))
                            .cornerRadius(10)
                            .foregroundColor(.purple)
                    }

                }
            
                
                
                //Actionbuttons
                Section(header: Text("")){
                    
                   
                    //edit profile button
                    Button {
                        showingEditAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Edit profile")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                    }
                    .listRowBackground(Color.clear)
                    .alert(isPresented: $showingEditAlert) {
                        Alert(
                            title:  Text("Edit Profile"),
                            message: Text("Are you sure you want to edit your profile?"),
                            primaryButton: .destructive(Text("Edit")) {
                                // Call your deleteProfile function here
                                Task {
                                    await editProfile()
                                    editProfile = true
                                }
                            },
                            secondaryButton: .cancel(Text("Cancel"))
                        )
                    }
                }
                                        
                }
                .navigationTitle("Edit profile")
                
            }
        }
    
    
    
    
    
   
        
        
       
        
        //function to delete a profile
        func editProfile() async {
            
            let urlString = "\(AppConfig.baseURL)"
            
            
            //change : get values
            
            
            let userDetail = UserDetail (
                id: id,
                firstname: firstNameNew,
                lastname: lastNameNew,
                email: eMail,
                password: password,
                phoneNumber: phoneNumberNew
            )
            print("UserDetail EditProfile:")
            print(userDetail)
            
            
            do{
                try await editUser(urlString: urlString, userDetail: userDetail, token: receivedToken!)
                
                
                
                
                await loadUserData()
                
                print("Successfully")
                 
                //exit(0)
                
            }
            catch{
                print("Error\(error)")
            }
            
            // deleteUser(url,UserDetail)
            
        }
        
        
        
        
        
        
        //function to load userdata
        func loadUserData() async{
            let urlString = "\(AppConfig.baseURL)/whoAmI"
            do{
                
                let userDetail = try await whoAmI(urlString: urlString, token: receivedToken!)
                
                // Setze die empfangenen Daten in die @State-Variablen
                id = userDetail.id ?? 0
                lastName = userDetail.lastname
                firstName = userDetail.firstname
                eMail = userDetail.email
                phoneNumber = userDetail.phoneNumber ?? ""
                password = userDetail.password ?? ""
                
                
                lastNameNew=userDetail.lastname
                firstNameNew=userDetail.firstname
                phoneNumberNew=userDetail.phoneNumber
                
                print("Userdetail: ", userDetail)
            }catch{
                print("UI-error: ",error)
            }
            print("Userdata loaded succesful ")
        }
        
        
    }
    
    #Preview {
        ProfileView()
    }


