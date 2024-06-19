//
//  MainView.swift
//  JoyFlow
//
//  Created by god on 02/06/2024.
//

import SwiftUI


struct MainManagerView: View {
    @Binding var isAuthenticated: Bool
    @Binding var currentUser: User?

    var body: some View {
        TabView {
            ShiftsView()
                .tabItem {
                    Image(systemName: "person.2")
                    Text("Manage Streamers")
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


/*
struct MainManagerView: View {
   
    @Binding var isAuthenticated: Bool
    @Binding var currentUser: User?

    
    var body: some View {
        TabView {
            //ManagerDashboardView()
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
}*/

//struct MainManagerView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainManagerView()
//    }
//}

/*
 struct MainView: View {
 var body: some View {
 NavigationView {
 VStack {
 Text("JoyFlow Work")
 .font(.largeTitle)
 .padding()
 
 NavigationLink(destination: CalendarView()) {
 Text("Calendar")
 .padding()
 .background(Color.blue)
 .foregroundColor(.white)
 .cornerRadius(8)
 }
 .padding()
 
 NavigationLink(destination: ShiftsView()) {
 Text("Shifts")
 .padding()
 .background(Color.blue)
 .foregroundColor(.white)
 .cornerRadius(8)
 }
 .padding()
 
 NavigationLink(destination: ChatView()) {
 Text("Chat")
 .padding()
 .background(Color.blue)
 .foregroundColor(.white)
 .cornerRadius(8)
 }
 .padding()
 
 NavigationLink(destination: ProfileView()) {
 Text("Profile")
 .padding()
 .background(Color.blue)
 .foregroundColor(.white)
 .cornerRadius(8)
 }
 .padding()
 }
 }
 }
 }
 
 struct MainView_Previews: PreviewProvider {
 static var previews: some View {
 MainView()
 }
 }
 */

