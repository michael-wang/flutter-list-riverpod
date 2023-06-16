import 'package:flutter_list_riverpod/domain/photo.dart';
import 'package:flutter_list_riverpod/infra/local_source.dart';
import 'package:flutter_list_riverpod/infra/remote_source.dart';
import 'package:flutter_list_riverpod/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_source.g.dart';

@riverpod
FutureOr<List<Photo>> dataSource(DataSourceRef ref,
    {required int start, int limit = 20}) async {
  // 1. Try to read from local source.
  final localSource = ref.watch(localSourceProvider.notifier);
  var photos = await localSource.read(start: start, limit: limit);
  log.w('start: $start, limit: $limit\nlocal photos: ${photos.length}');
  if (photos.isNotEmpty) {
    return photos;
  }

  // 2. Cache missed, get from remote source.
  photos =
      await ref.watch(remoteSourceProvider(start: start, limit: limit).future);
  log.w('start: $start, limit: $limit\nremote photos: ${photos.length}');

  // 3. Save to local source.
  await localSource.write(photos);

  return photos;
}
