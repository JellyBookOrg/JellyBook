import { Stack } from "expo-router";

export default function AppLayout() {
  return (
    <Stack>
      <Stack.Screen
        name="home"
        options={{
          title: "Home",
        }}
      />
      <Stack.Screen
        name="[id]"
        options={{
          title: "Details",
        }}
      />
    </Stack>
  );
}
