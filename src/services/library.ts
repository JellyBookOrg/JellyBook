import { jellyfinClient } from "../lib/jellyfin";
import { BaseItemDto, BaseItemKind, ItemSortBy } from "@jellyfin/sdk/lib/generated-client";
import { getItemsApi } from "@jellyfin/sdk/lib/utils/api";
import { getUserLibraryApi } from "@jellyfin/sdk/lib/utils/api";
import { getAuthData } from "../lib/auth";

export interface FetchItemsOptions {
  startIndex: number;
  limit: number;
}

export interface FetchItemsResponse {
  items: BaseItemDto[];
  totalRecordCount: number;
}

export class LibraryService {
  static async fetchItems({ startIndex, limit }: FetchItemsOptions): Promise<FetchItemsResponse> {
    const authData = await getAuthData();
    if (!authData) {
      throw new Error('Not authenticated');
    }

    const api = jellyfinClient.createApi(
      authData.serverUrl,
      authData.accessToken
    );
    const itemsApi = getItemsApi(api);

    const response = await itemsApi.getItems({
      userId: authData.userId,
      includeItemTypes: [BaseItemKind.Book, BaseItemKind.AudioBook],
      recursive: true,
      limit,
      startIndex,
      enableTotalRecordCount: true,
      sortBy: [ItemSortBy.IsFavoriteOrLiked, ItemSortBy.SortName]
    });

    // 

    return {
      items: response.data.Items || [],
      totalRecordCount: response.data.TotalRecordCount || 0
    };
  }
  static async fetchItemDetails(itemId: string): Promise<BaseItemDto> {
    const authData = await getAuthData();
    if (!authData) {
      throw new Error('Not authenticated');
    }

    const api = jellyfinClient.createApi(
      authData.serverUrl,
      authData.accessToken
    );

    const userLibraryApi = getUserLibraryApi(api);

    const response = await userLibraryApi.getItem({
      userId: authData.userId,
      itemId
    });

    if (!response.data) {
      throw new Error('Item not found');
    }

    return response.data;
  }
}
