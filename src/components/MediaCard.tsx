import { View, Text, Pressable } from "react-native";
import { Image } from "expo-image";
import { BaseItemDto, ImageType } from "@jellyfin/sdk/lib/generated-client";
import { useState, useEffect } from "react";
import { getImageUrl } from "../utils/imageUrl";

interface MediaCardProps {
  item: BaseItemDto;
  onPress?: (item: BaseItemDto) => void;
}

export const MediaCard = ({ item, onPress }: MediaCardProps) => {
  const [imageUrl, setImageUrl] = useState<string | null>(null);

  useEffect(() => {
    const loadImage = async () => {
      const url = await getImageUrl(item, ImageType.Primary);
      setImageUrl(url);
    };

    loadImage();
  }, [item]);

  return (
    <Pressable
      className="w-[46%] m-2 rounded-lg overflow-hidden bg-gray-100"
      onPress={() => onPress?.(item)}
    >
      {imageUrl && (
        <Image
          source={{ uri: imageUrl }}
          style={{ width: '100%', aspectRatio: 2 / 3 }}
          contentFit="fill"
          contentPosition="left"
        />
      )}
      <View className="p-2">
        <Text className="font-medium text-sm">{item.Name}</Text>
      </View>
    </Pressable>
  );
};
