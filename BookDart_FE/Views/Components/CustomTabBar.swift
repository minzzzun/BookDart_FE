//
//  CustomTabBar.swift
//  BookDart_FE
//
//  Created by 김민준 on 1/19/26.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            TabBarButton(
                tab: .home,
                selectedTab: $selectedTab,
                icon: "book.fill",
                title: "책 목록"
            )
            
            TabBarButton(
                tab: .notice,
                selectedTab: $selectedTab,
                icon: "megaphone.fill",
                title: "공지사항"
            )
            
            TabBarButton(
                tab: .myPage,
                selectedTab: $selectedTab,
                icon: "person.fill",
                title: "마이페이지"
            )
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: -4)
        )
    }
}

struct TabBarButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    let icon: String
    let title: String
    
    private var isSelected: Bool {
        selectedTab == tab
    }
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                Text(title)
                    .font(.system(size: 11, weight: isSelected ? .medium : .regular))
            }
            .foregroundColor(isSelected ? .accentColor : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}

