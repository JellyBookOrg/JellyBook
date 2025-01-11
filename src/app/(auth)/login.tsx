import { View, TextInput, Button, Text } from "react-native";
import { useState } from "react";
import { useJellyfin } from "../../hooks/useJellyfin";
import { router } from "expo-router";

export default function Login() {
  const [serverUrl, setServerUrl] = useState("");
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const { login, error } = useJellyfin();

  const handleLogin = async () => {
    const success = await login(serverUrl.toLowerCase(), username, password);
    if (success) {
      router.replace("/(app)/home");
    }
  };

  return (
    <View className="flex-1 justify-center p-4">
      <TextInput
        className="border p-2 rounded mb-4"
        placeholder="Server URL"
        value={serverUrl}
        onChangeText={setServerUrl}
        inputMode="url"
      />
      <TextInput
        className="border p-2 rounded mb-4"
        placeholder="Username"
        value={username}
        onChangeText={setUsername}
      />
      <TextInput
        className="border p-2 rounded mb-4"
        placeholder="Password"
        value={password}
        onChangeText={setPassword}
        secureTextEntry
      />
      <Button title="Login" onPress={handleLogin} />
      {error && (
        <Text className="text-red-500 mt-2">
          {error}
        </Text>
      )}
    </View>
  );
}
