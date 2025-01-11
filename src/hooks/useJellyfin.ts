import { useState, useCallback } from "react";
import { AuthService } from "../lib/auth";

export const useJellyfin = () => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const login = useCallback(async (serverUrl: string, username: string, password: string) => {
    try {
      await AuthService.login(serverUrl, username, password);
      setIsAuthenticated(true);
      return true;
    } catch (err) {
      setError(err instanceof Error ? err.message : "Unknown error occurred");
      return false;
    }
  }, []);

  return { isAuthenticated, error, login };
};
