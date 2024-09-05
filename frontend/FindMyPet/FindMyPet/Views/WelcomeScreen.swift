
//  WelcomeScreen.swift
//  register
//
//  Created by Berkay Aksu on 08.11.23.
//

import SwiftUI
// compiler gains access to SwiftUI elements such as Views


struct WelcomeScreen: View {


    //body
    var body: some View {
        
        //manage navigation in app. allows back buttons, navigation links to a view
        NavigationView{
            VStack{
                
                //Logo
                Image("hundLogo2")
                    .resizable()
                    .frame(width:180,height:150)
                    .padding(.top,200)
                
                //header
                Text("Find My Pet")
                    .font(.largeTitle)
                    .shadow(radius: 7)
                    .bold()
                    .foregroundStyle(.purple)
                
                Spacer()
                //example of navigation link
                //Button
                NavigationLink(destination: LoginView()) {
                    Text("Log In")
                        .foregroundColor(.purple)
                        .font(.title2.bold())
                        .frame(width: 299, height: 50)
                        .background(Color.white)
                        .cornerRadius(1)
                        .border(Color.purple)
                }
                
                //example of navigation Link
                //Button
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .font(.title2.bold())
                        .frame(width: 300, height: 50)
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                
                
                
            }

            // disable the navigation bar //upper area
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

}

