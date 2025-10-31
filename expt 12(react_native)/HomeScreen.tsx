import React from 'react';
import { View, Text, Button, Platform } from 'react-native';
import '@react-native-firebase/app';
import auth from '@react-native-firebase/auth';
import { GoogleSignin } from '@react-native-google-signin/google-signin';
import { styles } from '../styles';

// This is the protected home/dashboard screen 
export default function HomeScreen() {
  if (Platform.OS === 'web') {
    return (
      <View style={styles.homeContainer}>
        <Text style={styles.title}>Unsupported on Web</Text>
        <Text style={styles.emailText}>Run on Android/iOS with Expo Dev Client.</Text>
      </View>
    );
  }

  const user = auth().currentUser;

  const handleSignOut = async () => {
    try {
      // Check if the user signed in with Google
      const isGoogleUser = user.providerData.some(
        (provider) => provider.providerId === 'google.com'
      );

      // Disconnect from Google Sign-in first
      if (isGoogleUser) {
        await GoogleSignin.revokeAccess();
        await GoogleSignin.signOut();
      }

      // Sign out from Firebase
      await auth().signOut(); // [cite: 2]
      // Observer in App.js will handle navigation
    } catch (error) {
      console.error("Sign Out Error: ", error);
    }
  };

  return (
    <View style={styles.homeContainer}>
      <Text style={styles.title}>Welcome!</Text>

      {/* Profile Section  */}
      {user ? (
        <>
          <Text style={styles.displayNameText}>
            {user.displayName || 'User'}
          </Text>
          <Text style={styles.emailText}>
            Signed in as: {user.email}
          </Text>
        </>
      ) : (
        <Text style={styles.emailText}>Loading user data...</Text>
      )}

      <Button title="Sign Out" onPress={handleSignOut} />
    </View>
  );
}