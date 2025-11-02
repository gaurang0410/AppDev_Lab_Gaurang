// firebase.ts
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
    apiKey: "AIzaSyAob8OAi0WFek-wd0gSLqv_icrdl-azrsk",
  authDomain: "my-expo-app-73e70.firebaseapp.com",
  projectId: "my-expo-app-73e70",
  storageBucket: "my-expo-app-73e70.firebasestorage.app",
  messagingSenderId: "837084110479",
  appId: "1:837084110479:web:cf309d45432d20b7f11afa",
  measurementId: "G-C9B3BEYQQL"
  
};

// Initialize Firebase only once
const app = initializeApp(firebaseConfig);

// Export initialized services
export const auth = getAuth(app);
export const db = getFirestore(app);
export default app;
