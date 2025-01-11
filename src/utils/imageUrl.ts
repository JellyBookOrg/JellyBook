import AsyncStorage from '@react-native-async-storage/async-storage';
import { BaseItemDto, ImageType } from "@jellyfin/sdk/lib/generated-client";

export const getImageUrl = async (item: BaseItemDto, imageType: ImageType = ImageType.Primary) => {
  try {
    if (!item.ImageTags?.[imageType]) return `https://via.placeholder.com/150`;

    const authDataStr = await AsyncStorage.getItem('auth');
    if (!authDataStr) return `https://via.placeholder.com/150`;

    const { serverUrl, accessToken } = JSON.parse(authDataStr);


    // Construct the image URL using the Jellyfin API format
    return `${serverUrl}/Items/${item.Id}/Images/${imageType}?tag=${item.ImageTags[imageType]}&api_key=${accessToken}`;
  } catch {
    return `https://via.placeholder.com/150`;
  }
};
