//
//  EditReportView.swift
//  FindMyPet
//
//  Created by Erkan Kanat on 30.12.23.
//

import SwiftUI
import CoreLocation
import UIKit


struct EditReportView: View {
    
    
    
    var report: ReportDetail
    var receivedToken: String

    
    @State private var id: Int = 0
    @State private var petname: String
    @State private var pettype: String
    @State private var petbreed: String
    @State private var petimage: String
    @State private var petdescription: String
    @State private var petgender: Bool
    
    @State private var editReport = false
    @State private var showingEditAlert = false
    @State private var isImagePickerPresented: Bool = false
    
    init(report: ReportDetail, receivedToken: String = "") {
        _id = State(initialValue: report.id ?? 0)
        _petname = State(initialValue: report.petName)
        _pettype = State(initialValue: report.petType)
        _petbreed = State(initialValue: report.petBreed)
        _petimage = State(initialValue: report.petPicture)
        _petdescription = State(initialValue: report.petDescription)
        _petgender = State(initialValue: report.petGender)
        self.report = report
        self.receivedToken = receivedToken

    }
    
    var body: some View {
        
        NavigationView{
            Form{
                
                Section(header:Text("Report Data")){
                    
                    HStack{
                        Text("Pet Name: ")
                        Spacer()
                        Text(report.petName)
                    }
                    
                    
                    HStack{
                        Text("Pet Type: ")
                        Spacer()
                        Text(report.petType)
                    }
                    
                    
                    HStack{
                        Text("Pet Gender: ")
                        Spacer()
                        if(report.petGender){
                            Text("Male")
                        } else {
                            Text("Female")
                        }
                    }
                    
                    
                    HStack{
                        Text("Pet Description: ")
                        Spacer()
                        Text(report.petDescription)
                    }
                    
                    
                    HStack{
                        Text("Pet Breed: ")
                        Spacer()
                        Text(report.petBreed)
                    }
                    
                    HStack{
                        Text("Pet Picture: ")
                        Spacer()
                        
                        if let imageData = decodeBase64ToImage(report.petPicture), let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)  // Passe die Größe nach Bedarf an
                        } else {
                            Text("No Picture Available")
                        }
                    }
                }
                
                
                Section(header: Text("Edit pet report")){
                    
                    
                    HStack{
                        Text("Pet name: ")
                        Spacer()
                        
                        TextField("Pet name",text: $petname)
                            .padding()
                            .frame(width: 148, height: 50)
                            .background(Color.purple.opacity(0.05))
                            .cornerRadius(10)
                            .foregroundColor(.purple)
                    }
                    
                    HStack{
                        Text("Pet Type: ")
                        Spacer()
                        
                        TextField("Pet type",text: $pettype)
                            .padding()
                            .frame(width: 148, height: 50)
                            .background(Color.purple.opacity(0.05))
                            .cornerRadius(10)
                            .foregroundColor(.purple)
                    }
                    
                    
                    HStack{
                        Text("Pet Breed: ")
                        Spacer()
                        
                        TextField("Pet Breed",text: $petbreed)
                            .padding()
                            .frame(width: 148, height: 50)
                            .background(Color.purple.opacity(0.05))
                            .cornerRadius(10)
                            .foregroundColor(.purple)
                    }
                    
                    
                    HStack {
                        Text("Pet Gender: ")
                        Spacer()
                        
                        Button(action: {
                            // Toggle the value of 'gender' between true and false
                            petgender.toggle()
                        }) {
                            Text(petgender ? "Male" : "Female")
                                .padding()
                                .frame(width: 100, height: 30)
                                .background(petgender ? Color.blue : Color.pink)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack{
                        Text("Pet Description: ")
                        Spacer()
                        
                        TextEditor(text: $petdescription)
                            .padding()
                            .frame(width: 148)
                            .frame(minHeight: 50)
                            .background(Color.purple.opacity(0.05))
                            .cornerRadius(10)
                            .foregroundColor(.purple)
                    }
                    
                    Section(header: Text("")){
                        
                       
                        //edit profile button
                        Button {
                            showingEditAlert = true
                        } label: {
                            HStack {
                                Spacer()
                                Text("Edit report")
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
                                title:  Text("Edit Report"),
                                message: Text("Are you sure you want to edit your report?"),
                                primaryButton: .destructive(Text("Edit")) {
                                    // Call your deleteProfile function here
                                    Task {
                                        await editReport()
                                        editReport = true
                                    }
                                },
                                secondaryButton: .cancel(Text("Cancel"))
                            )
                        }
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                
                
                
                
            }
        }
    }
    
    
    
    func editReport() async {
        let urlString = "\(AppConfig.baseURL)"
        
        let report = ReportDetail(id: id,petName: petname, petType: pettype, petBreed: petbreed, petDescription: petdescription, petGender: petgender, dateReported: report.dateReported, petPicture: petimage, isFound: report.isFound, location: report.location, userId: report.userId)
        
        print("UserDetail EditProfile:")
        print(report)
        do {
            
            try await FindMyPet.editReport(urlString: urlString, report: report, token: receivedToken)
        }
        catch {
            print("Error \(error)")
        }
    }
    
    func decodeBase64ToImage(_ base64String: String) -> Data? {
        var cleanedBase64String = base64String

        // Entferne das Präfix "data:image/jpeg;base64,"
        if let prefixRange = cleanedBase64String.range(of: "base64,") {
            cleanedBase64String.removeSubrange(cleanedBase64String.startIndex..<prefixRange.upperBound)
        }

        // Entferne Zeilenumbrüche und Leerzeichen
        cleanedBase64String = cleanedBase64String.replacingOccurrences(of: "\r\n", with: "")
        cleanedBase64String = cleanedBase64String.replacingOccurrences(of: " ", with: "")

        return Data(base64Encoded: cleanedBase64String)
    }

}
    

