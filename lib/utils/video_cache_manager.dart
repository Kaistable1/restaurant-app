import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoCacheManager {
  static const key = 'customVideoCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );

  /// Downloads and caches a video from a URL
  static Future<void> preCacheVideo(String url) async {
    try {
      await instance.downloadFile(url);
      print('Video cached: $url');
    } catch (e) {
      print('Error caching video $url: $e');
    }
  }

  /// Returns a local file link for a cached video, or null if not cached
  static Future<String?> getCachedVideoPath(String url) async {
    final fileInfo = await instance.getFileFromCache(url);
    return fileInfo?.file.path;
  }
}
