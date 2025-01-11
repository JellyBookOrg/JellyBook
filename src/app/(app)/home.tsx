import { View, FlatList, Text, ActivityIndicator } from "react-native";
import { useEffect } from "react";
import { MediaCard } from "../../components/MediaCard";
import { router } from "expo-router";
import { useLibraryItems } from "../../hooks/useLibraryItems";

export default function Home() {
  const {
    items,
    isLoading,
    isLoadingMore,
    error,
    loadInitial,
    loadMore
  } = useLibraryItems();

  useEffect(() => {
    loadInitial().catch((err) => {
      if (err.message === 'Not authenticated') {
        router.replace('/(auth)/login');
      }
    });
  }, [loadInitial]);

  const renderFooter = () => {
    if (!isLoadingMore) return null;

    return (
      <View className="py-4 justify-center items-center">
        <ActivityIndicator />
      </View>
    );
  };

  if (error) {
    return (
      <View className="flex-1 justify-center items-center">
        <Text className="text-red-500">{error}</Text>
      </View>
    );
  }

  if (isLoading) {
    return (
      <View className="flex-1 justify-center items-center">
        <Text>Loading...</Text>
      </View>
    );
  }

  return (
    <View className="flex-1 bg-white">
      <FlatList
        data={items}
        renderItem={({ item }) => (
          <MediaCard
            item={item}
            onPress={() => router.push(`/(app)/${item.Id}`)}
          />
        )}
        numColumns={2}
        className="p-2"
        onEndReached={loadMore}
        onEndReachedThreshold={0.5}
        ListFooterComponent={renderFooter}
        keyExtractor={item => item.Id || Math.random().toString()}
      />
    </View>
  );
}
