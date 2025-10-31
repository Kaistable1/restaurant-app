#!/bin/bash
# Script to patch google_maps_cluster_manager to fix Cluster class conflict
# Run this after every 'flutter pub get' or 'flutter pub upgrade'

echo "Patching google_maps_cluster_manager..."

PACKAGE_DIR="$HOME/.pub-cache/hosted/pub.dev/google_maps_cluster_manager-3.1.0/lib/src"

if [ ! -d "$PACKAGE_DIR" ]; then
    echo "✗ google_maps_cluster_manager-3.1.0 not found in pub cache"
    echo "  Run 'flutter pub get' first"
    exit 1
fi

# List of files to patch
FILES=(
    "cluster_manager.dart"
    "cluster.dart"
    "common.dart"
    "geohash.dart"
    "cluster_item.dart"
)

PATCHED_COUNT=0
ALREADY_PATCHED=0

for FILE in "${FILES[@]}"; do
    FILE_PATH="$PACKAGE_DIR/$FILE"
    
    if [ -f "$FILE_PATH" ]; then
        # Check if already patched
        if grep -q "hide Cluster, ClusterManager" "$FILE_PATH"; then
            ALREADY_PATCHED=$((ALREADY_PATCHED + 1))
        elif grep -q "hide Cluster" "$FILE_PATH"; then
            # Update existing patch to include ClusterManager
            sed -i '' 's|hide Cluster;|hide Cluster, ClusterManager;|g' "$FILE_PATH"
            PATCHED_COUNT=$((PATCHED_COUNT + 1))
            echo "  ✓ Updated patch for $FILE"
        else
            # Apply the patch
            sed -i '' 's|import '\''package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'\'';|import '\''package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'\'' hide Cluster, ClusterManager;|g' "$FILE_PATH"
            PATCHED_COUNT=$((PATCHED_COUNT + 1))
            echo "  ✓ Patched $FILE"
        fi
    fi
done

if [ $PATCHED_COUNT -gt 0 ]; then
    echo "✓ Successfully patched $PATCHED_COUNT file(s)"
elif [ $ALREADY_PATCHED -gt 0 ]; then
    echo "✓ All files already patched ($ALREADY_PATCHED file(s))"
else
    echo "⚠ No files were patched"
fi

