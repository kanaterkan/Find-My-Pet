//
//  SignUpView.swift
//  register
//
//  Created by Berkay Aksu on 07.11.23.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var email = ""
    @State private var firstname = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var showErrorLabel = false // New State for showing error label
    @State private var isRegistrated = false

    @State private var token: String?
    @State private var user: UserDetail?
    
    
    //container for view
    var body: some View {
        
    
        // bottom layer
        ZStack{
            //Design
            Color.purple
                .ignoresSafeArea()
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            Circle()
                .scale(1.35)
                .foregroundColor(.white)
            Image("hundLogo2")
                .resizable()
                .frame(width:180,height:150)
                .padding(.top,-310)
                .padding(.bottom,10)
          
            
            
                .padding()
            //2nd layer
            ZStack{
                
                VStack{
                    Text("Sign-Up")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top,30)
                        .foregroundColor(.purple)
                    
                    
                    
                    //INPUTS
                    HStack{
                        TextField("Firstname",text: $firstname)
                            .padding()
                            .frame(width: 148, height: 50)
                            .background(Color.purple.opacity(0.05))
                            .cornerRadius(10)
                            .foregroundColor(.purple)
                        
                        
                        TextField("Lastname",text: $lastName)
                            .padding()
                            .frame(width: 148, height: 50)
                            .background(Color.purple.opacity(0.05))
                            .cornerRadius(10)
                            .foregroundColor(.purple)
                    }
                    
                    TextField("Mobile",text: $phoneNumber)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.purple.opacity(0.05))
                        .cornerRadius(10)
                        .foregroundColor(.purple)
                    
                    TextField("E-Mail",text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.purple.opacity(0.05))
                        .cornerRadius(10)
                        .foregroundColor(.purple)
                        .padding(.bottom,10)
                    
                    
                    
                    ZStack() {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(Color.purple.opacity(0.05))
                                .cornerRadius(10)
                                .foregroundColor(.purple)
                                .padding(.bottom,8)
                            
                        } else {
                            SecureField("Password", text: $password)
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(Color.purple.opacity(0.05))
                                .cornerRadius(10)
                                .foregroundColor(.purple)
                                .padding(.bottom,8)
                            
                            
                            
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.purple)
                            
                        }
                        .padding(.leading,-185)
                    }
                    
                    NavigationLink(destination: ContentView(receivedToken: token, user: user), isActive: $isRegistrated) {
                        EmptyView()
                    }
                    
                    .hidden()
                    
                    
                    //Button to sign up
                    
                    Button("Sign Up"){
                        Task {
                            do {
                                token = try await signUp()
                                user = try await loadUserData(token: token!)
                                
                                
                                print("ui token :" ,token!)
                                isRegistrated=true
                                
                            } catch {
                                showErrorLabel=true
                                print("Error \(error)")
                            }
                        }
                    }
                    
                    .foregroundColor(.white)
                    .font(.title2.bold())
                    .frame(width:300, height: 50)
                    .background(Color.purple)
                    .cornerRadius(10)
                    
                    HStack{
                        Text("Already have an account?")
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                            .font(.system(size: 17))
                        
                        
                        NavigationLink(destination:LoginView()) {
                            Text("LOGIN")
                                .font(.system(size: 17))
                                .foregroundColor(.purple)
                                .fontWeight(.bold)
                            
                            
                        }
                        
                        
                        .frame(height: 0)
                        .frame(minWidth: 0, maxWidth: 95)
                        .background(Color(.white))
                        .frame(alignment: .bottom)
                        
                        
                    }
                    if showErrorLabel {
                        Text("Please fill out all fields correctly!")
                            .foregroundColor(.red)
                            .padding()
                            .bold()
                    }
                }
                
            }
        }
        .navigationBarHidden(true)
        
        
        
    }
    
    
    
    // FUNCTIONS
    
    func signUp() async throws -> String {
        // Implement action when submit button is tapped
        let urlString = "\(AppConfig.baseURL)/signup"
        
        
        let userDetail = UserDetail (
            firstname: firstname,
            lastname: lastName,
            email: email,
            password: password,
            phoneNumber: phoneNumber
        )
        
        if(firstname.isEmpty || lastName.isEmpty || phoneNumber.isEmpty){
            throw RequestError.missingData
        }
        
        
        
        do {
            token = try await postUser(urlString: urlString, userDetail: userDetail)
            print("Pet report successfully submitted")
            
            isRegistrated=true
            
          
            
        
            
        }catch RequestError.missingData{
            print("Error \(RequestError.missingData)")
            print(userDetail)
            throw RequestError.missingData
        }catch {
            print("Error \(error)")
            print(userDetail)
        }
        return token!
    }
    
    func loadUserData(token: String) async throws -> UserDetail {
        let urlString = "\(AppConfig.baseURL)/whoAmI"
        
        //let userDetail = try await whoAmI(urlString: urlString, token: token)
        
        return try await whoAmI(urlString: urlString, token: token)
    }
}
