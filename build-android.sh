#!/usr/bin/env bash

# Check if file exists
if [ -f "sha1sums.txt" ]; then
    rm sha1sums.txt
fi
touch sha1sums.txt

# Build debug version
flutter build apk --debug
flutter build apk --debug --split-per-abi

# Get the SHA1 Checksums of the APKs and save them to a file with the following format: 
# <code>filename</code>: <code>checksum</code>
declare -a fileName=( $(find build/app/outputs/flutter-apk -type f -name "*.apk") )
declare -a fileChecksum

# Build debug AAB version
flutter build appbundle --debug
fileName=$(find build/app/outputs/bundle/debug/ -type f -name "*.aab")
fileChecksum=$(sha1sum "$fileName" | awk '{print $1}')
fileName=${fileName##*/}
fileName=${fileName/app-/JellyBook-}
echo "<code>$fileName</code>: <code>$fileChecksum</code>" | tee -a sha1sums.txt

# Build release version
flutter build apk --release
flutter build apk --release --split-per-abi

declare -a fileName=( $(find build/app/outputs/flutter-apk/ -type f -name "*.apk") )
declare -a fileChecksum

for file in "${fileName[@]}"; do
  checksum=$(sha1sum "$file" | awk '{print $1}')
  fileChecksum+=("$checksum")
  file=${file##*/}
  file=${file/app-/JellyBook-}
  echo "<code>$file</code>: <code>$checksum</code>" | tee -a sha1sums.txt
done

# Build release AAB version
flutter build appbundle --release
fileName=$(find build/app/outputs/bundle/release/ -type f -name "*.aab")
fileChecksum=$(sha1sum "$fileName" | awk '{print $1}')
fileName=${fileName##*/}
fileName=${fileName/app-/JellyBook-}
echo "<code>$fileName</code>: <code>$fileChecksum</code>" | tee -a sha1sums.txt
