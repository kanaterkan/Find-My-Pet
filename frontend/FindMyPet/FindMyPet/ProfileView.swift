//
//  ProfileView.swift
//  FindMyPet
//
//  Created by Jan Schnetger on 08.11.23.
//

import SwiftUI

struct ProfileView: View {
    @State private var lastname = "test"
    @State private var firstname = "test"
    @State private var userID = "test"
    @State private var eMail = "test"
    @State private var password = "test"
    @State private var phoneNumber = "test"
    
    var body: some View {
        NavigationView{
            
            Form{
        
                VStack{
                    
                    HStack{
                        Button(action: {}, label: {
                            Text("Log out")
                        })
                        Spacer()
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("Edit profile")
                        })
                        Spacer()
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("Delete Profile")
                        })
                    }
                    Section(header: Text("Contact Information"))
                    {
                        
                        HStack {
                            Text("User ID: ")
                                .bold()
                            Spacer()
                            Text(userID)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        HStack {
                            Text("First name:")
                                .bold()
                            Spacer()
                            Text(firstname)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        HStack {
                            Text("Last name:")
                                .bold()
                            Spacer()
                            Text(lastname)
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
                            Text("E-Mail: ")
                                .bold()
                            Spacer()
                            Text(eMail)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        HStack {
                            Text("Password: ")
                                .bold()
                            Spacer()
                            Text(password)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                    .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    
                }
        }
            .navigationTitle("Report Missing Pet")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
            //   self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.blue)
            })
         

          
        }
     
      
        
    }
        
}

#Preview {
    ProfileView()
}
