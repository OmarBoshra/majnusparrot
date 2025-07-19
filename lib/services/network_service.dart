// services/network_service.dart
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'dart:io';

Dio setupDio() {
  final cacheStore =
      HiveCacheStore(Directory.systemTemp.path, hiveBoxName: 'poem_responses');
  Dio dio = Dio();
  dio.interceptors.add(
    DioCacheInterceptor(
      options: CacheOptions(
        store: cacheStore,
        policy: CachePolicy.forceCache,
        maxStale: const Duration(days: 7),
        priority: CachePriority.normal,
        hitCacheOnErrorExcept: [401, 403],
        keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      ),
    ),
  );
  return dio;
}
