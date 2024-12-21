import { ExpoConfig } from 'expo/config';

export default {
  name: 'JellyBook',
  slug: 'JellyBook',
  version: '1.0.0',
  orientation: 'portrait',
  icon: "./assets/icon.png",
  userInterfaceStyle: 'light',
  splash: {
    image: './assets/splash.png',
    resizeMode: 'contain',
    backgroundColor: '#ffffff',
  },
  assetBundlePatterns: [
    '**/*',
  ],
  ios: {
    supportsTablet: true,
    bundleIdentifier: 'com.karawilson.JellyBook',
  },
  android: {
    adaptiveIcon: {
      foregroundImage: './assets/adaptive-icon.png',
      backgroundColor: '#ffffff',
    },
    package: 'com.karawilson.JellyBook',
  },
  web: {
    favicon: './assets/favicon.png',
    bundler: 'metro',
  },
  plugins: [
    'expo-secure-store',
    'expo-router'
  ],
  experiments: {
    typedRoutes: true,
    tsconfigPaths: true,
  },
} satisfies ExpoConfig;
