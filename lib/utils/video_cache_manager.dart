import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoCacheManager {
  static const key = 'customVideoCacheKey';

  static final CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 3),
      maxNrOfCacheObjects: 25,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );

  /// URLs currently being actively downloaded
  static final Set<String> _activeDownloads = {};
  static const int _maxConcurrent = 2;

  // ── Public API ────────────────────────────────────────────────────────────

  /// If the video is already cached returns its local path immediately.
  /// Otherwise downloads it, caches it, and returns the local path.
  /// Returns null only on error.
  ///
  /// This is the PRIMARY method used by [TikTokVideoWidget] to resolve
  /// a playable file path for a given URL.
  static Future<String?> cacheAndGetPath(String url) async {
    if (url.isEmpty) return null;
    try {
      // Check cache first — avoids re-downloading
      final existing = await instance.getFileFromCache(url);
      if (existing != null && existing.file.existsSync()) {
        return existing.file.path;
      }
      // Download → cache → return path
      final file = await instance.downloadFile(url);
      return file.file.path;
    } catch (_) {
      return null;
    }
  }

  /// Background pre-cache (fire-and-forget). Respects concurrency cap.
  /// Use this for videos adjacent to the current page — not for the current video.
  static Future<void> preCacheVideo(String url) async {
    if (url.isEmpty) return;
    if (_activeDownloads.contains(url)) return;

    try {
      final cached = await instance.getFileFromCache(url);
      if (cached != null && File(cached.file.path).existsSync()) return;
    } catch (_) {}

    if (_activeDownloads.length >= _maxConcurrent) return;

    _activeDownloads.add(url);
    try {
      await instance.downloadFile(url);
    } catch (_) {
    } finally {
      _activeDownloads.remove(url);
    }
  }

  /// Returns the cached path synchronously from the cache database,
  /// or null if not cached. Never downloads anything.
  static Future<String?> getCachedVideoPath(String url) async {
    if (url.isEmpty) return null;
    try {
      final fileInfo = await instance.getFileFromCache(url);
      if (fileInfo != null && fileInfo.file.existsSync()) {
        return fileInfo.file.path;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Wipe the entire cache (call only on explicit user action or low-memory
  /// system warnings).
  static Future<void> clearCache() async {
    try {
      await instance.emptyCache();
    } catch (_) {}
  }
}
