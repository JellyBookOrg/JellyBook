import { useState, useEffect } from 'react';
import { BaseItemDto } from "@jellyfin/sdk/lib/generated-client";
import { LibraryService } from '../services/library';

export function useItemDetails(itemId: string) {
  const [item, setItem] = useState<BaseItemDto | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchDetails = async () => {
      try {
        setIsLoading(true);
        setError(null);
        const details = await LibraryService.fetchItemDetails(itemId);
        setItem(details);
      } catch (err) {
        setError(err instanceof Error ? err.message : "Failed to fetch item details");
      } finally {
        setIsLoading(false);
      }
    };

    fetchDetails();
  }, [itemId]);

  return { item, isLoading, error };
}
