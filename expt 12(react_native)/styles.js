import { StyleSheet } from 'react-native';

export const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    padding: 20,
    backgroundColor: '#f5f5f5',
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    textAlign: 'center',
    marginBottom: 20,
  },
  input: {
    height: 50,
    width: '100%',
    borderColor: 'gray',
    borderWidth: 1,
    borderRadius: 8,
    marginBottom: 15,
    paddingHorizontal: 15,
    backgroundColor: '#ffffff',
  },
  // Used for displaying auth errors [cite: 3, 5]
  errorText: {
    color: 'red',
    textAlign: 'center',
    marginBottom: 10,
  },
  // Used for success messages (like password reset)
  successText: {
    color: 'green',
    textAlign: 'center',
    marginBottom: 10,
  },
  buttonSpacer: {
    height: 10,
  },
  // For the protected home screen 
  homeContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  emailText: {
    fontSize: 16,
    marginVertical: 20,
  },
  displayNameText: {
    fontSize: 18,
    fontWeight: 'bold',
  }
});