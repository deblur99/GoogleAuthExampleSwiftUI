//
//  ContentView.swift
//  GoogleAuthExample
//
//  Created by 한현민 on 2023/08/09.
//

import SwiftUI
import GoogleSignInSwift

struct ContentView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    @State var isShowingLogoutCheckAlert: Bool = false
    @State var isShowingLogoutConfirmAlert: Bool = false

    var body: some View {
        NavigationStack {
            // credential을 nil로 바꾸면 로그아웃 상태로 만들어버릴 수 있지 않을까? (추측)
            if viewModel.credential == nil {
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .wide, state: .normal)) {
                    Task {
                        do {
                            try await viewModel.signInGoogle()
//                            isLoggedIn.toggle()
                        } catch {
                            debugPrint("error")
                        }
                    }
                }
                .padding()
            } else {
                VStack{
                    Text("Logged In!")
                    Button("Log out") {
                        isShowingLogoutCheckAlert.toggle()
                    }
                }
            }
        }
        .alert("로그아웃", isPresented: $isShowingLogoutCheckAlert) {
            Button("네", role: .destructive) {
                viewModel.credential = nil
                isShowingLogoutCheckAlert.toggle()
                isShowingLogoutConfirmAlert.toggle()
            }
            
            Button("아니요", role: .cancel) {
                isShowingLogoutCheckAlert.toggle()
            }
        } message: {
            Text("정말 로그아웃하시겠어요?")
        }
        .alert("로그아웃", isPresented: $isShowingLogoutConfirmAlert) {
            Button("확인") {
                isShowingLogoutConfirmAlert.toggle()
            }
        } message: {
            Text("로그아웃되었습니다.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showSignInView: .constant(false))
    }
}
