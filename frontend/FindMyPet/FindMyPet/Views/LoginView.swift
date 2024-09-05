import SwiftUI

//struct LoginUser {
//    var email: String
//    var password: String
//}

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float = 0
    @State private var isPasswordVisible = false

    @State private var token: String?
    @State private var isLoggedIn = false
    @State private var showErrorLabel = false // New State for showing error label

    @State private var user: UserDetail?
  
    var body: some View {
        ZStack {
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
                .frame(width: 180, height: 150)
                .padding(.top, -310)

            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .foregroundStyle(.purple)
                    .bold()
                    .padding()

                TextField("E-mail", text: $username)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.purple.opacity(0.05))
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(wrongUsername))
                    .foregroundColor(.purple)
                    .padding(.bottom, 8)
                

                ZStack() {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.purple.opacity(0.05))
                            .cornerRadius(10)
                            .foregroundColor(.purple)
                            .padding(.bottom, 8)
                    } else {
                        SecureField("Password", text: $password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.purple.opacity(0.05))
                            .cornerRadius(10)
                            .foregroundColor(.purple)
                            .padding(.bottom, 8)
                    }

                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.purple)
                    }
                    .padding(.leading, -185)
                }

                NavigationLink(destination: ContentView(receivedToken: token, user: user), isActive: $isLoggedIn) {
                    EmptyView()
                }
                .hidden()

                Button("Login") {
                    Task {
                        do {
                            token = try await login()
                            user = try await loadUserData(token: token!)
                            print("Token: "+token!)

                          
                                isLoggedIn = true
                       
                        } catch {
                            showErrorLabel=true
                            print("Error \(error)")
                        }
                    }
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.purple)
                .cornerRadius(10)

                HStack {
                    Text("Don‘t have an account?")
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .font(.system(size: 17))

                    NavigationLink(destination: SignUpView()) {
                        Text("SIGN UP")
                            .font(.system(size: 17))
                            .foregroundColor(.purple)
                            .fontWeight(.bold)
                    }
                    .frame(height: 0)
                    .frame(minWidth: 0, maxWidth: 100)
                    .background(Color(.white))
                    .frame(alignment: .bottom)
                }
                
                if showErrorLabel {
                                  Text("Invalid Credentials")
                                      .foregroundColor(.red)
                                      .padding()
                                      .bold()
                              }
                
            }
            .navigationBarHidden(true)
        }
    }

    func login() async throws -> String {
        let urlString = "\(AppConfig.baseURL)/users/login"
        let loginUser = LoginUser(
            email: username,
            password: password
        )
        var returnToken = ""
        do {
            returnToken = try await postLogin(urlString: urlString, loginUser: loginUser)
            print("Pet report successfully submitted with Token: \n"+returnToken)
            return returnToken
        }catch RequestError.unauthorized{
            print("Error \(RequestError.unauthorized)")
            print(loginUser)
            throw RequestError.unauthorized
        } catch {
            
            print("Error \(error)")
            print(loginUser)
            
            throw RequestError.unknown
            
        }
        return returnToken
    }
 
    
    func loadUserData(token: String) async throws -> UserDetail {
        let urlString = "\(AppConfig.baseURL)/whoAmI"
        
        //let userDetail = try await whoAmI(urlString: urlString, token: token)
        
        return try await whoAmI(urlString: urlString, token: token)
    }
    
    
}


