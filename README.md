# Firebase Notes App 📝🔥

A Flutter mobile application for taking and managing notes using **Firebase Authentication** and **Cloud Firestore**. Each user can sign in, add, edit, and delete their personal notes in real time.

---

## 📱 Features

- Firebase Authentication (Email & Password)
- Cloud Firestore for storing user-specific notes
- Add,  Edit, and Delete notes
-  Timestamped notes
- Logged-in user notes are isolated
- Live updates via `StreamBuilder`

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/edith123321/firebase_notes_app.git
cd firebase_notes_app
```
### 2. Install Flutter Dependencies
Make sure you have Flutter installed. Then:
``` bash
flutter pub get
```
### 3. Set Up Firebase
- Go to Firebase Console.
- Create a new project.
- Add an Android app with your app's package name (e.g., com.example.firebase_notes_app).
- Download the google-services.json file and place it in android/app/.
- Enable Authentication > Email/Password sign-in method.
- Create Cloud Firestore and set these rules during development:

##  Running the App
Run the app by runnning this command 
``` bash
flutter run
```
