import React, { useState } from 'react';
import { View, Text, TextInput, Button, Alert, ActivityIndicator, Platform } from 'react-native';
import auth from '@react-native-firebase/auth';
import { GoogleSignin, statusCodes } from '@react-native-google-signin/google-signin';
import { styles } from '../styles'; // Import shared styles
import { router } from 'expo-router';

export default function LoginScreen() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // Email/Password Sign-in [cite: 2]
  const handleEmailLogin = async () => {
    if (email === '' || password === '') {
      setError('Please enter both email and password.'); // Validation 
      return;
    }
    setLoading(true);
    setError(null);
    try {
      await auth().signInWithEmailAndPassword(email, password);
      // Observer in App.js will handle navigation
    } catch (err) {
      // Handle common auth errors [cite: 3]
      if (err.code === 'auth/user-not-found' || err.code === 'auth/wrong-password') {
        setError('Invalid email or password.');
      } else if (err.code === 'auth/invalid-email') {
        setError('That email address is invalid!');
      } else {
        setError('An unknown error occurred.');
        console.error(err);
      }
      setLoading(false);
    }
  };

  // Google Sign-in [cite: 3, 5]
  const handleGoogleSignIn = async () => {
    setLoading(true);
    setError(null);
    try {
      await GoogleSignin.hasPlayServices();
      const { idToken } = await GoogleSignin.signIn();
      const googleCredential = auth.GoogleAuthProvider.credential(idToken);
      await auth().signInWithCredential(googleCredential);
      // Observer in App.js will handle navigation
    } catch (err) {
      if (err.code === statusCodes.SIGN_IN_CANCELLED) {
        setError('Google Sign-in was cancelled.');
      } else if (err.code === statusCodes.IN_PROGRESS) {
        setError('Google Sign-in is already in progress.');
      } else {
        setError('An error occurred during Google Sign-in.');
        console.error(err);
      }
      setLoading(false);
    }
  };

  if (Platform.OS === 'web') {
    return (
      <View style={styles.container}>
        <Text style={styles.title}>Unsupported on Web</Text>
        <Text style={styles.emailText}>Run on Android/iOS with Expo Dev Client.</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Sign In</Text>
      <TextInput
        style={styles.input}
        placeholder="Email"
        value={email}
        onChangeText={setEmail}
        keyboardType="email-address"
        autoCapitalize="none"
      />
      <TextInput
        style={styles.input}
        placeholder="Password"
        value={password}
        onChangeText={setPassword}
        secureTextEntry
      />

      {error && <Text style={styles.errorText}>{error}</Text>}

      {loading ? (
        <ActivityIndicator size="large" color="#0000ff" />
      ) : (
        <>
          <Button title="Sign In" onPress={handleEmailLogin} />
          <View style={styles.buttonSpacer} />
          <Button title="Sign In with Google" onPress={handleGoogleSignIn} />
          <View style={styles.buttonSpacer} />
          <Button
            title="Need an account? Sign Up"
            onPress={() => router.push('/signup')}
          />
          <View style={styles.buttonSpacer} />
          <Button
            title="Forgot Password?"
            onPress={() => router.push('/forgot-password')}
          />
        </>
      )}
    </View>
  );
}