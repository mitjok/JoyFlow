//
//  MainStreamerView.swift
//  JoyFlow
//
//  Created by god on 14/06/2024.
//

import SwiftUI

struct MainStreamerView: View {
    @Binding var isAuthenticated: Bool
    @Binding var currentUser: User?

    
    var body: some View {
        TabView {
            
            ShiftsView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Dashboard")
                }

            ScheduleView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }

            ChatsListView(currentUser: $currentUser)
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat")
                }
            
            ProfileView(isAuthenticated: $isAuthenticated, currentUser: $currentUser)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}
