**JoyFlow**
App that is in development that I make in my free time.

JoyFlow is an iOS application designed to manage and schedule tasks for streamers and their managers. The app is built using SwiftUI and integrates with Firebase and Realm for authentication and data storage. The application supports various roles, including streamers and managers, and provides features for creating, editing, and deleting tasks, as well as viewing schedules in different formats such as day, week, and month views.

**Features**
  User Authentication: Supports email/password authentication, and integration with TikTok and YouTube via Firebase.
  Role-Based Views: Different views and functionalities for streamers and managers.
  Task Management: Create, edit, and delete tasks with task details, date, and time.
  Schedule Views: View tasks by day, week, and month.
  Task Synchronization: Synchronize tasks between Firebase Firestore and Realm.
  FaceID and Passcode Authentication: Plan to add for session renewal.
**Dependencies**
  Firebase: Authentication, Firestore, Storage
  Realm: Local database storage with encryption
  Alamofire: Networking requests
  GoogleSignIn: Google authentication
  TikTokOpenAuthSDK: TikTok authentication
  GoogleAPIClientForREST/YouTube: YouTube API integration
