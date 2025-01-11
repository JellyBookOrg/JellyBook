import { useState, useCallback, useRef } from 'react';
import { BaseItemDto } from "@jellyfin/sdk/lib/generated-client";
import { LibraryService } from '../services/library';

export const ITEMS_PER_PAGE = 10;

export function useLibraryItems() {
  const [items, setItems] = useState<BaseItemDto[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isLoadingMore, setIsLoadingMore] = useState(false);
  const [hasMoreItems, setHasMoreItems] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const startIndexRef = useRef(0);

  const loadInitial = useCallback(async () => {
    try {
      setIsLoading(true);
      setError(null);
      startIndexRef.current = 0;

      const { items: newItems, totalRecordCount } = await LibraryService.fetchItems({
        startIndex: 0,
        limit: ITEMS_PER_PAGE
      });

      setItems(newItems);
      setHasMoreItems(ITEMS_PER_PAGE < totalRecordCount);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to fetch items");
    } finally {
      setIsLoading(false);
    }
  }, []);

  const loadMore = useCallback(async () => {
    if (!hasMoreItems || isLoadingMore) return;

    try {
      setIsLoadingMore(true);
      const nextIndex = startIndexRef.current + ITEMS_PER_PAGE;

      const { items: newItems, totalRecordCount } = await LibraryService.fetchItems({
        startIndex: nextIndex,
        limit: ITEMS_PER_PAGE
      });

      setItems(current => [...current, ...newItems]);
      setHasMoreItems(nextIndex + ITEMS_PER_PAGE < totalRecordCount);
      startIndexRef.current = nextIndex;
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to fetch more items");
    } finally {
      setIsLoadingMore(false);
    }
  }, [hasMoreItems, isLoadingMore]);

  return {
    items,
    isLoading,
    isLoadingMore,
    hasMoreItems,
    error,
    loadInitial,
    loadMore
  };
}
