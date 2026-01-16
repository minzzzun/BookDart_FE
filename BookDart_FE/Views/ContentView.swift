//
//  ContentView.swift
//  SpringTest
//
//  Created by 김민준 on 1/15/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router = NavigationRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            MainView()
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
    }
}
