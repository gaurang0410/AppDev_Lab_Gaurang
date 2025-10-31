import { GoogleSignin } from '@react-native-google-signin/google-signin';

export const configureGoogleSignIn = () => {
  GoogleSignin.configure({
    // Get this from your google-services.json file 
    webClientId: '514828497551-mtkfjvnccanhvp057h1ej31b49c5dvt6.apps.googleusercontent.com',
  });
};