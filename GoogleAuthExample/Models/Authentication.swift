//
//  Authentication.swift
//  GoogleAuthExample
//
//  Created by 한현민 on 2023/08/09.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var credential: AuthCredential? = nil
    
    func signInGoogle() async throws {
        // 로그인 버튼 만들기
        guard let topVC = GoogleLoginButton.shared.topViewController() else {
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
