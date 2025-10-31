import React, { useState } from 'react';
import { View, Text, TextInput, Button, ActivityIndicator, Platform } from 'react-native';
import auth from '@react-native-firebase/auth';
import { styles } from '../styles';
import { router } from 'expo-router';

export default function SignUpScreen() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // Email/Password Sign-up [cite: 2]
  const handleEmailSignUp = async () => {
    if (email === '' || password === '') {
      setError('Please enter both email and password.'); // Validation 
      return;
    }
    setLoading(true);
    setError(null);
    try {
      await auth().createUserWithEmailAndPassword(email, password);
      // Observer in App.js will handle navigation
    } catch (err) {
      // Handle common auth errors [cite: 3, 5]
      if (err.code === 'auth/email-already-in-use') {
        setError('That email address is already in use!');
      } else if (err.code === 'auth/invalid-email') {
        setError('That email address is invalid!');
      } else if (err.code === 'auth/weak-password') {
        setError('Password is too weak. Must be at least 6 characters.');
      } else {
        setError('An unknown error occurred.');
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
      <Text style={styles.title}>Create Account</Text>
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
        placeholder="Password (min. 6 chars)"
        value={password}
        onChangeText={setPassword}
        secureTextEntry
      />

      {error && <Text style={styles.errorText}>{error}</Text>}

      {loading ? (
        <ActivityIndicator size="large" color="#0000ff" />
      ) : (
        <>
          <Button title="Sign Up" onPress={handleEmailSignUp} />
          <View style={styles.buttonSpacer} />
          <Button
            title="Already have an account? Sign In"
            onPress={() => router.push('/login')}
          />
        </>
      )}
    </View>
  );
}