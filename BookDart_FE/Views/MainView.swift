//
//  MainView.swift
//  SpringTest
//
//  Created by 김민준 on 1/15/26.
//

import SwiftUI


struct MainView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        VStack {
            Text("메인")
            
            Button (action: {
                router.toNamed("/login")
            }){
                Text("로그인")
            }
        }
        
        
        
        
        
    }
}
