//
//  ContentView.swift
//  GoogleAuthExample
//
//  Created by 한현민 on 2023/08/09.
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift // SUI
import SwiftUI

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var credential: AuthCredential? = nil
    
    func signInGoogle() async throws {
        // 로그인 버튼 만들기
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        // Client ID 생성 및 로그인 설정
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // 로그인 인증
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        // 토큰 생성
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken = gidSignInResult.user.accessToken.tokenString
//        gidSignInResult.user.
        
        // Credential 생성
        credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        print(credential?.description ?? nil)
    }
}

//extension AuthenticationManager

struct ContentView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool

    var body: some View {
        NavigationStack {
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await viewModel.signInGoogle()

                    } catch {
                        debugPrint("error")
                    }
                }
            }
            
            NavigationLink {
                NavigationStack {
                    Text(viewModel.credential?.description ?? "")
                }
            } label: {
                Text("Inner View")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showSignInView: .constant(false))
    }
}
