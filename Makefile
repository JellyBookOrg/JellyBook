# Define the version from pubspec.yaml
VERSION := $(shell yq eval '.version' pubspec.yaml)

# Define the output directory
OUTPUT_DIR := $(VERSION)

.DEFAULT_GOAL := all

.PHONY: all
ifeq ($(OS),Darwin)
all: ios_release ios_debug android_release android_debug app_bundle_release app_bundle_debug sha1_hashes
else
all: android_release android_debug app_bundle_release app_bundle_debug sha1_hashes
endif

.PHONY: ios
ifeq ($(OS),Darwin)
ios: ios_release ios_debug
else
ios:
	@echo "iOS builds only supported on macOS"
endif


.PHONY: android
android: android_release android_debug

.PHONY: app_bundle
app_bundle: app_bundle_release app_bundle_debug

.PHONY: release
ifeq ($(OS),Darwin)
release: ios_release android_release app_bundle_release
else
release: android_release app_bundle_release
endif

.PHONY: debug
ifeq ($(OS),Darwin)
debug: ios_debug android_debug app_bundle_debug
else
debug: android_debug app_bundle_debug
endif

.PHONY: ios_release
ios_release: create_output_dir
	@echo "Building iOS release IPA..."
	@flutter build ipa --release >/dev/null 2>&1
	@echo "Complete release IPA"
	@mv build/ios/ipa/jellybook.ipa "$(OUTPUT_DIR)/JellyBook-Release.ipa"

.PHONY: ios_debug
ios_debug: create_output_dir
	@echo "Building iOS debug IPA..."
	@flutter build ipa --debug
	@echo "Complete debug IPA"
	@mv build/ios/ipa/jellybook.ipa "$(OUTPUT_DIR)/JellyBook-Debug.ipa"

.PHONY: android_release
android_release: create_output_dir
	@echo "Building Android release APK..."
	@flutter build apk --release
	@echo "Complete release APK"
	@mv build/app/outputs/flutter-apk/app-release.apk "$(OUTPUT_DIR)/JellyBook-Release.apk"
	@echo "Building Android release APK (split by ABI)..."
	@flutter build apk --split-per-abi --release
	@echo "Complete release APK (split by ABI)"
	@mv build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk "$(OUTPUT_DIR)/JellyBook-Release-arm32.apk"
	@mv build/app/outputs/flutter-apk/app-arm64-v8a-release.apk "$(OUTPUT_DIR)/JellyBook-Release-arm64.apk"
	@mv build/app/outputs/flutter-apk/app-x86_64-release.apk "$(OUTPUT_DIR)/JellyBook-Release-x86_64.apk"

.PHONY: android_debug
android_debug: create_output_dir
	@echo "Building Android debug APK..."
	@flutter build apk --debug
	@echo "Complete debug APK"
	@mv build/app/outputs/flutter-apk/app-debug.apk "$(OUTPUT_DIR)/JellyBook-Debug.apk"
	@echo "Building Android debug APK (split by ABI)..."
	@flutter build apk --split-per-abi --debug
	@echo "Complete debug APK (split by ABI)"
	@mv build/app/outputs/flutter-apk/app-armeabi-v7a-debug.apk "$(OUTPUT_DIR)/JellyBook-Debug-arm32.apk"
	@mv build/app/outputs/flutter-apk/app-arm64-v8a-debug.apk "$(OUTPUT_DIR)/JellyBook-Debug-arm64.apk"
	@mv build/app/outputs/flutter-apk/app-x86_64-debug.apk "$(OUTPUT_DIR)/JellyBook-Debug-x86_64.apk"

.PHONY: app_bundle_release
app_bundle_release: create_output_dir
	@echo "Building Android release App Bundle..."
	@flutter build appbundle --release
	@echo "Complete release App Bundle"
	@mv build/app/outputs/bundle/release/app-release.aab "$(OUTPUT_DIR)/JellyBook-Release.aab"

.PHONY: app_bundle_debug
app_bundle_debug: create_output_dir
	@echo "Building Android debug App Bundle..."
	@flutter build appbundle --debug
	@echo "Complete debug App Bundle"
	@mv build/app/outputs/bundle/debug/app-debug.aab "$(OUTPUT_DIR)/JellyBook-Debug.aab"

.PHONY: sha1_hashes
sha1_hashes:
	@echo "\n<details>\n<summary>SHA1</summary>\n<ul>"
	@for file in "$(OUTPUT_DIR)"/*; do \
		hash=$$(sha1sum "$$file" | awk '{print $$1}'); \
		file=$$(basename "$$file"); \
		echo "<li><code>$${file}</code>: <code>$${hash}</code></li>"; \
	done
	@echo "</ul>\n</details>"

.PHONY: create_output_dir
create_output_dir:
	@mkdir -p "$(OUTPUT_DIR)"

.PHONY: clean
clean:
	@echo "Cleaning up..."
	@rm -rf "$(OUTPUT_DIR)"
	@echo "Cleaned up."

# Usage: make clean-all
.PHONY: clean-all
clean-all: clean
	@echo "Cleaning build artifacts..."
	@flutter clean
	@echo "Cleaned build artifacts."
	@echo removing the output directory
	@rm -rf "$(OUTPUT_DIR)"
	@echo "Cleaned up."


# Help target to display available targets and their descriptions
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all        : Build all (iOS and Android) releases and debugs"
	@echo "  ios        : Build iOS releases and debugs"
	@echo "  android    : Build Android releases and debugs"
	@echo "  app_bundle : Build Android App Bundles (release and debug)"
	@echo "  release    : Build release versions (iOS, Android, and App Bundles)"
	@echo "  debug      : Build debug versions (iOS, Android, and App Bundles)"
	@echo "  clean      : Clean up the output directory"
	@echo "  clean-all  : Clean up build artifacts and the output directory"
	@echo "  help       : Display this help message"
