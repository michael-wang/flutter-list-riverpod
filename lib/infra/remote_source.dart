import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/item.dart';

part 'remote_source.g.dart';

@riverpod
FutureOr<List<Item>> remoteSource(RemoteSourceRef ref,
    {required int start, int limit = 20}) async {
  await Future.delayed(const Duration(milliseconds: 250));
  return List<Item>.generate(
    limit,
    (index) => Item(title: 'Item #${start + index}'),
  );
}
