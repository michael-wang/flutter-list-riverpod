import 'package:flutter_list_riverpod/domain/photo.dart';
import 'package:flutter_list_riverpod/infra/remote_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_source.g.dart';

@riverpod
FutureOr<(List<Photo>, Object? err)> dataSource(DataSourceRef ref,
    {required int start, int limit = 20}) async {
  // TODO read from local source.
  // TODO if local source has no data, get from remote source.
  // TODO save data in local source.
  return await ref
      .watch(remoteSourceProvider(start: start, limit: limit).future);
}
