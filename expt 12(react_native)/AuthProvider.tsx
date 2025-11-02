import React, { createContext, useState, useEffect, ReactNode, useContext } from 'react';
import { 
  onAuthStateChanged, 
  signOut, 
  signInWithEmailAndPassword, 
  createUserWithEmailAndPassword, 
  updateProfile, 
  User 
} from 'firebase/auth';
import { auth } from '../../firebase'; // Make sure this path is correct
import { useRouter } from 'expo-router';
import { Alert } from 'react-native'; // Import Alert

// Define the shape of your context data
interface AuthContextType {
  user: User | null;
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  signup: (email: string, password: string, username: string) => Promise<void>;
  logout: () => Promise<void>;
}

// Create the context with default values
export const AuthContext = createContext<AuthContextType>({
  user: null,
  loading: true,
  login: async () => {},
  signup: async () => {},
  logout: async () => {},
});

// Create the provider component
export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const router = useRouter();

  // Effect to listen for auth state changes
  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (usr) => {
      setUser(usr);
      setLoading(false);
    });
    // Cleanup subscription on unmount
    return unsubscribe;
  }, []);

  // --- Sign Up Function (with Error Handling) ---
  const signup = async (email: string, password: string, username: string) => {
    // Check for empty fields
    if (email === '' || password === '' || username === '') {
      Alert.alert('Sign Up Error', 'Please fill in all fields.');
      return;
    }
    
    try {
      const userCred = await createUserWithEmailAndPassword(auth, email, password);
      // Update profile with username
      await updateProfile(userCred.user, { displayName: username });
      setUser(userCred.user); // Set user in state
      router.replace('/'); // Navigate to home
    } catch (error: any) {
      console.error('Sign Up Error:', error.code);
      if (error.code === 'auth/invalid-email') {
        Alert.alert('Sign Up Error', 'Please enter a valid email address.');
      } else if (error.code === 'auth/email-already-in-use') {
        Alert.alert('Sign Up Error', 'This email address is already in use.');
      } else if (error.code === 'auth/weak-password') {
        Alert.alert('Sign Up Error', 'Password must be at least 6 characters long.');
      } else {
        Alert.alert('Sign Up Error', 'An unexpected error occurred. Please try again.');
      }
    }
  };

  // --- Login Function (with Error Handling) ---
  const login = async (email: string, password: string) => {
    // Check for empty fields
    if (email === '' || password === '') {
      Alert.alert('Login Error', 'Please enter both email and password.');
      return;
    }

    try {
      await signInWithEmailAndPassword(auth, email, password);
      router.replace('/'); // Navigate to home
    } catch (error: any) {
      console.error('Login Error:', error.code);
      if (error.code === 'auth/invalid-email') {
        Alert.alert('Login Error', 'Please enter a valid email address.');
      } else if (error.code === 'auth/invalid-credential') {
        Alert.alert('Login Error', 'The email or password you entered is incorrect.');
      } else {
        Alert.alert('Login Error', 'An unexpected error occurred. Please try again.');
      }
    }
  };

  // --- Logout Function (with Error Handling) ---
  const logout = async () => {
    try {
      await signOut(auth);
      router.replace('/signin'); // Navigate to sign-in page
    } catch (error: any) {
      console.error('Logout Error:', error.message);
      Alert.alert('Logout Error', 'An error occurred while logging out.');
    }
  };

  // Provide the auth values to children components
  return (
    <AuthContext.Provider value={{ user, loading, login, signup, logout }}>
      {children}
    </AuthContext.Provider>
  );
};