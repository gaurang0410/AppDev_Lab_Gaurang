import React, { useState } from 'react';
import { View, Text, TextInput, Button, ActivityIndicator, Platform } from 'react-native';
import auth from '@react-native-firebase/auth';
import { styles } from '../styles';
import { router } from 'expo-router';

export default function ForgotPasswordScreen() {
  const [email, setEmail] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(null);

  // Password Reset Email [cite: 2]
  const handlePasswordReset = async () => {
    if (email === '') {
      setError('Please enter your email address.');
      return;
    }
    setLoading(true);
    setError(null);
    setSuccess(null);
    try {
      await auth().sendPasswordResetEmail(email);
      setSuccess('Password reset email sent! Check your inbox.');
    } catch (err) {
      // Handle common auth errors [cite: 3]
      if (err.code === 'auth/user-not-found') {
        setError('No user found with this email address.');
      } else if (err.code === 'auth/invalid-email') {
        setError('That email address is invalid!');
      } else {
        setError('An error occurred.');
        console.error(err);
      }
    }
    setLoading(false);
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
      <Text style={styles.title}>Reset Password</Text>
      <Text style={{textAlign: 'center', margin: 10}}>
        Enter your email and we'll send you a link to reset your password.
      </Text>
      <TextInput
        style={styles.input}
        placeholder="Email"
        value={email}
        onChangeText={setEmail}
        keyboardType="email-address"
        autoCapitalize="none"
      />

      {error && <Text style={styles.errorText}>{error}</Text>}
      {success && <Text style={styles.successText}>{success}</Text>}

      {loading ? (
        <ActivityIndicator size="large" color="#0000ff" />
      ) : (
        <>
          <Button title="Send Reset Email" onPress={handlePasswordReset} />
          <View style={styles.buttonSpacer} />
          <Button title="Back to Sign In" onPress={() => router.push('/login')} />
        </>
      )}
    </View>
  );
}