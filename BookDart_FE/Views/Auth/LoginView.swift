//
//  LoginView.swift
//  SpringTest
//
//  Created by 김민준 on 1/15/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        VStack {
            Text("로그인 뷰")
            Button(action: {
                router.toNamed("/")
            }) {
                
            }
        }
    }
}
