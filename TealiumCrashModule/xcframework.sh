# Universal Script

set -e

FRAMEWORK_NAME="$1"
OUTPUT_DIR="xcframeworks"
SIMULATOR_ARCHIVE_PATH="build/${OUTPUT_DIR}/${FRAMEWORK_NAME}-iphonesimulator.xcarchive"
DEVICE_ARCHIVE_PATH="build/${OUTPUT_DIR}/${FRAMEWORK_NAME}-iphoneos.xcarchive"

# Remove old 
if [ -d "build/${OUTPUT_DIR}" ]; then
  rm -rf "build/${OUTPUT_DIR}"
fi

if [ -d "${OUTPUT_DIR}" ]; then
  rm -rf "${OUTPUT_DIR}"
fi

if [ -d "../${FRAMEWORK_NAME}.xcframework.zip" ]; then
  rm -rf "../${FRAMEWORK_NAME}.xcframework.zip"
fi


# Simulator xcarchive
xcodebuild archive \
  -scheme ${FRAMEWORK_NAME} \
  -archivePath ${SIMULATOR_ARCHIVE_PATH} \
  -configuration Release \
  -sdk iphonesimulator \
  SKIP_INSTALL=NO

# Device xcarchive
xcodebuild archive \
  -scheme ${FRAMEWORK_NAME} \
  -archivePath ${DEVICE_ARCHIVE_PATH} \
  -sdk iphoneos \
  -configuration Release \
  SKIP_INSTALL=NO

# Create xcframework combine of all frameworks
xcodebuild -create-xcframework \
  -framework ${SIMULATOR_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework \
  -framework ${DEVICE_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework \
  -output ${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework

# Zip xcframework
if [[ -d "${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework" ]]; then
    zip -r "../${FRAMEWORK_NAME}.xcframework.zip" "${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework"
fi