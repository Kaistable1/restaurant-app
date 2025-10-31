# Package Patch Documentation

## google_maps_cluster_manager Fix

### Issue
The `google_maps_cluster_manager` package version 3.1.0 has a naming conflict with `google_maps_flutter_platform_interface`. Both packages export a `Cluster` class, causing a build error:

```
Error: 'Cluster' is imported from both 'package:google_maps_cluster_manager/src/cluster.dart' 
and 'package:google_maps_flutter_platform_interface/src/types/cluster.dart'.
```

### Solution
We've created a patch that modifies the import statement in the `google_maps_cluster_manager` package to hide the conflicting `Cluster` class from `google_maps_flutter_platform_interface`.

### How to Apply the Patch

**Automatic Method (Recommended):**

Run the patch script after any `flutter pub get` or `flutter pub upgrade`:

```bash
./patch_cluster_manager.sh
```

This will automatically patch all 5 required files in the package.

**Manual Method:**

If the script doesn't work, manually edit these files in `~/.pub-cache/hosted/pub.dev/google_maps_cluster_manager-3.1.0/lib/src/`:

1. `cluster_manager.dart`
2. `cluster.dart`
3. `common.dart`
4. `geohash.dart`
5. `cluster_item.dart`

For each file, find:
```dart
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
```

Change it to:
```dart
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart' hide Cluster;
```

After patching, run:
```bash
flutter clean
flutter pub get
```

### When to Apply
- After initial setup
- After running `flutter pub get`
- After running `flutter pub upgrade`
- After switching branches that change dependencies
- After cleaning the pub cache

### Note
This patch modifies the cached package files. It's a temporary workaround until the package maintainers release an official fix. The patch is safe and only prevents the naming conflict without affecting functionality.

### Alternative Solutions
If this patch causes issues, you can:
1. Wait for an official update to `google_maps_cluster_manager`
2. Use an alternative clustering solution
3. Fork the package and maintain your own version

---

**Last Updated:** October 31, 2025

