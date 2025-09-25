import { Drawer } from 'expo-router/drawer';
import { Ionicons } from '@expo/vector-icons';
import { DrawerToggleButton } from '@react-navigation/drawer';

export default function DrawerLayout() {
  return (
    <Drawer
      screenOptions={{
        drawerActiveTintColor: '#007AFF',
        // Add the "hamburger" menu button to the header of all screens
        headerLeft: () => <DrawerToggleButton tintColor="#007AFF" />,
      }}
    >
      <Drawer.Screen
        name="(tabs)" // This screen contains our nested Tab Navigator
        options={{
          title: 'Home',
          drawerIcon: ({ color, size }) => (
            <Ionicons name="home-outline" size={size} color={color} />
          ),
        }}
      />
      <Drawer.Screen
        name="settings" // This is a standalone screen
        options={{
          title: 'Settings',
          drawerIcon: ({ color, size }) => (
            <Ionicons name="settings-outline" size={size} color={color} />
          ),
        }}
      />
    </Drawer>
  );
}