import AsyncStorage from '@react-native-async-storage/async-storage';
import { jellyfinClient } from './jellyfin';
import { getUserApi } from '@jellyfin/sdk/lib/utils/api';

interface AuthData {
  serverUrl: string;
  accessToken: string;
  userId: string;
  username: string;
  password: string;
}

export class AuthError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'AuthError';
  }
}

export class AuthService {
  private static async refreshAuth(authData: AuthData): Promise<AuthData> {
    try {
      const api = jellyfinClient.createApi(authData.serverUrl);
      const response = await api.authenticateUserByName(authData.username, authData.password);

      if (!response.data.AccessToken || !response.data.User?.Id) {
        throw new AuthError('Failed to refresh token');
      }

      const newAuthData: AuthData = {
        ...authData,
        accessToken: response.data.AccessToken,
        userId: response.data.User.Id
      };

      await AsyncStorage.setItem('auth', JSON.stringify(newAuthData));
      return newAuthData;
    } catch (err) {
      throw new AuthError('Token refresh failed');
    }
  }

  static async login(serverUrl: string, username: string, password: string): Promise<void> {
    try {
      const api = jellyfinClient.createApi(serverUrl);
      const response = await api.authenticateUserByName(username, password);

      if (!response.data.AccessToken || !response.data.User?.Id) {
        throw new AuthError('Login failed');
      }

      const authData: AuthData = {
        serverUrl,
        accessToken: response.data.AccessToken,
        userId: response.data.User.Id,
        username,
        password
      };

      await AsyncStorage.setItem('auth', JSON.stringify(authData));
    } catch (err) {
      throw new AuthError('Login failed');
    }
  }

  static async logout(): Promise<void> {
    await AsyncStorage.removeItem('auth');
  }

  static async getAuthData(): Promise<AuthData> {
    const data = await AsyncStorage.getItem('auth');
    if (!data) {
      throw new AuthError('Not authenticated');
    }

    const authData: AuthData = JSON.parse(data);
    return authData;
  }

  static async getValidAuthData(): Promise<AuthData> {
    try {
      const authData = await this.getAuthData();

      // Try to use current token
      const api = jellyfinClient.createApi(authData.serverUrl);
      api.accessToken = authData.accessToken;

      const userApi = getUserApi(api);

      try {
        const currentUser = await userApi.getCurrentUser();
        if (currentUser.status != 200) {
          // Token is invalid, try to refresh
          return await this.refreshAuth(authData);
        }
        return authData;
      } catch (err) {
        // Token is invalid, try to refresh
        return await this.refreshAuth(authData);
      }
    } catch (err) {
      throw new AuthError('Not authenticated');
    }
  }
}
