import { View, Text, ScrollView, ActivityIndicator, useWindowDimensions } from "react-native";
import { useLocalSearchParams } from "expo-router";
import { useItemDetails } from "../../hooks/useItemDetails";
import { useEffect, useState } from "react";
import { getImageUrl } from "../../utils/imageUrl";
import { BaseItemDto, ImageType } from "@jellyfin/sdk/lib/generated-client";
import { Image } from "expo-image";
import RenderHtml from 'react-native-render-html';

export default function ItemDetails() {
  const { id } = useLocalSearchParams();
  const { item, isLoading, error } = useItemDetails(id as string);
  const [imageUrl, setImageUrl] = useState<string | null>(null);
  const { width } = useWindowDimensions();

  useEffect(() => {
    const loadImage = async () => {
      const url = await getImageUrl(item as BaseItemDto, ImageType.Primary);
      setImageUrl(url);
    };

    loadImage();
  }, [item]);

  if (isLoading) {
    return (
      <View className="flex-1 justify-center items-center">
        <ActivityIndicator />
      </View>
    );
  }

  if (error || !item) {
    return (
      <View className="flex-1 justify-center items-center">
        <Text className="text-red-500">{error || "Item not found"}</Text>
      </View>
    );
  }

  return (
    <ScrollView className="flex-1 bg-white p-4">
      {/* two side to side views */}
      <View className="flex-row justify-between">
        {imageUrl && (
          <View className="w-[40%] m-2 rounded-xl overflow-hidden bg-gray-100">
            <Image
              source={{ uri: imageUrl }}
              style={{ width: '100%', aspectRatio: 2 / 3 }}
              contentFit="fill"
              contentPosition="left"
            />
          </View>
        )}
        <View className="w-[55%] m-2 rounded-lg overflow-hidden">
          <Text className="text-2xl font-bold">{item.Name}</Text>
        </View>
      </View>
      {item.Overview && (
        <View className="mt-4 mw-2">
          <RenderHtml
            source={{
              html: item.Overview,
            }}
            contentWidth={width - 16}
          />
        </View>
      )}
      {/* Add more details as needed */}
    </ScrollView>
  );
}
