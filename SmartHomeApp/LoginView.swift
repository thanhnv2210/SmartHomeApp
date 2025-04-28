//
//  LoginView.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import SwiftUI
//import Firebase
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    
    var onLoginSuccess: (String) -> Void // Closure to call on successful login

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: loginUser) {
                Text("Login")
            }
            .padding()

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }

    private func loginUser() {
        print("Login user with email: \(email)")
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            // User is signed in successfully
            print("User signed in: \(String(describing: authResult?.user.uid))")
            // User is signed in successfully
            if let userId = authResult?.user.uid {
                print("User signed in: \(userId)")
                onLoginSuccess(userId) // Call the login success closure with the UID
            }
        }
    }
}
