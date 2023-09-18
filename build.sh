#!/usr/bin/env bash
# Function to display a green checkmark
print_checkmark() {
	tput setaf 2           # Set text color to green
	echo -e "\xE2\x9C\x94" # Green checkmark Unicode character
	tput sgr0              # Reset text color
}

# Function to display a progress bar
print_progress_bar() {
	local progress=$1
	local length=50
	local fill=""
	local empty=""
	local i

	for ((i = 0; i < length * progress / 100; i++)); do fill+="█"; done
	for ((i = 0; i < length - i; i++)); do empty+=" "; done

	echo -ne "[$fill$empty] $progress%\r"
}

# Get file version
version=$(yq eval '.version' pubspec.yaml)

# Make directory
mkdir -p $version

# Build iOS
# release
echo "Building iOS release IPA..."
flutter build ipa --release >/dev/null 2>&1
print_checkmark
# Add to the folder
cp build/ios/ipa/jellybook.ipa $version/JellyBook-Release.ipa
# print on the same line
echo -ne "\rComplete release IPA\n"

# debug
echo "Building iOS debug IPA..."
flutter build ipa --debug
print_checkmark
# Add to the folder
cp build/ios/ipa/jellybook.ipa $version/JellyBook-Debug.ipa
echo "Complete debug IPA"

# Build Android
## Apk
# release
echo "Building Android release APK..."
flutter build apk --release
print_checkmark
# Add to the folder
cp build/app/outputs/flutter-apk/app-release.apk $version/JellyBook-Release.apk

echo "Complete release APK"

# Split apk by abi
echo "Building Android release APK (split by ABI)..."
flutter build apk --split-per-abi --release
cp build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk $version/JellyBook-Release-arm32.apk
cp build/app/outputs/flutter-apk/app-arm64-v8a-release.apk $version/JellyBook-Release-arm64.apk
cp build/app/outputs/flutter-apk/app-x86_64-release.apk $version/JellyBook-Release-x86_64.apk
print_checkmark
echo "Complete release APK (split by ABI)"

# debug
echo "Building Android debug APK..."
flutter build apk --debug
print_checkmark
cp build/app/outputs/flutter-apk/app-debug.apk $version/JellyBook-Debug.apk
echo "Complete debug APK"

# Split apk by abi
echo "Building Android debug APK (split by ABI)..."
flutter build apk --split-per-abi --debug
print_checkmark
cp build/app/outputs/flutter-apk/app-armeabi-v7a-debug.apk $version/JellyBook-Debug-arm32.apk
cp build/app/outputs/flutter-apk/app-arm64-v8a-debug.apk $version/JellyBook-Debug-arm64.apk
cp build/app/outputs/flutter-apk/app-x86_64-debug.apk $version/JellyBook-Debug-x86_64.apk
echo "Complete debug APK (split by ABI)"

# Build appbundle
# release
echo "Building Android release App Bundle..."
flutter build appbundle --release
print_checkmark
cp build/app/outputs/bundle/release/app-release.aab $version/JellyBook-Release.aab
echo "Complete release App Bundle"

# debug
echo "Building Android debug App Bundle..."
flutter build appbundle --debug
print_checkmark
cp build/app/outputs/bundle/debug/app-debug.aab $version/JellyBook-Debug.aab
echo "Complete debug App Bundle"

# Print a list of their sha1 hashes
echo "
<details>
<summary>SHA1</summary>
<ul>"
for file in "$version"/*; do
	hash=$(sha1sum "$file" | awk '{print $1}')
	file=$(basename "$file")
	echo "<li><code>$file</code>: <code>$hash</code></li>"
done
echo "</ul>
</details>
"
