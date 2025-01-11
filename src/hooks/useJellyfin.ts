import { useState, useCallback } from "react";
import { jellyfinClient } from "../lib/jellyfin";
import { storeAuthData } from "../lib/auth";

export const useJellyfin = () => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const login = useCallback(async (serverUrl: string, username: string, password: string) => {
    try {
      const api = jellyfinClient.createApi(serverUrl);
      const response = await api.authenticateUserByName(username, password);

      if (response.data.AccessToken) {
        setIsAuthenticated(true);
        await storeAuthData({
          serverUrl,
          accessToken: response.data.AccessToken,
          userId: response.data.User?.Id ?? "",
        });
        return true;
      }
      return false;
    } catch (err) {
      setError(err instanceof Error ? err.message : "Unknown error occurred");
      return false;
    }
  }, []);

  return { isAuthenticated, error, login };
};
