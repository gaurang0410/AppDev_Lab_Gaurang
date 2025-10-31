import { Redirect } from 'expo-router';

export default function Index() {
  // This component will automatically redirect the user.
  //
  // 1. If the user is logged OUT:
  //    - It redirects to '/home'.
  //    - Your '_layout.tsx' guard will catch this, see they aren't signed in,
  //      and redirect them to '/login'.
  //
  // 2. If the user is logged IN:
  //    - It redirects to '/home'.
  //    - Your '_layout.tsx' guard will see they are signed in and
  //      allow them to see the 'home' screen.
  
  return <Redirect href="/home" />;
}