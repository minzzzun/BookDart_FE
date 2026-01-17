//
//  ContentView.swift
//  SpringTest
//
//  Created by 김민준 on 1/15/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router = NavigationRouter()
    @StateObject var authState = AuthStateViewModel()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if (authState.isLoggedIn){
                    MainView()
                } else {
                    LoginView()
                }
            }
                .navigationDestination(for: Route.self) { route in
                    switch route.name {
                    case "/":
                        MainView()
                    case "/login":
                        LoginView()
                    case "/signup":
                        SignUpView()
                        
                    default:
                        Text("알 수 없는 경로 : \(route.name) ")
                    }
                }
        }
        .environmentObject(router)
        .environmentObject(authState)
    }
}
