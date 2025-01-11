import '../global.css';
import { Stack, useRouter } from "expo-router";
import { useEffect } from "react";
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useJellyfin } from "../hooks/useJellyfin";

export default function RootLayout() {
  const router = useRouter();

  useEffect(() => {
    checkAuth();
  }, []);

  const checkAuth = async () => {
    const authData = await AsyncStorage.getItem('auth');
    if (authData) {
      router.replace('/(app)/home');
    } else {
      router.replace('/(auth)/login');
    }
  };

  return (
    <Stack>
      <Stack.Screen
        name="(auth)"
        options={{
          headerShown: false,
        }}
      />
      <Stack.Screen
        name="(app)"
        options={{
          headerShown: true,
        }}
      />
    </Stack>
  );
}
