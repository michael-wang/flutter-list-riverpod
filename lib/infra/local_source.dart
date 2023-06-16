import 'package:flutter_list_riverpod/domain/photo.dart';
import 'package:flutter_list_riverpod/infra/isar.dart';
import 'package:flutter_list_riverpod/infra/photo_record.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_source.g.dart';

@riverpod
class LocalSource extends _$LocalSource {
  FutureOr<List<Photo>> read({required int start, required int limit}) async {
    final isar = await ref.watch(isarProvider.future);
    final records = await isar.photoRecords
        .filter()
        .idBetween(start, start + limit)
        .limit(limit)
        .findAll();
    return records.toDomain();
  }

  FutureOr<void> write(List<Photo> photos) async {
    final isar = await ref.watch(isarProvider.future);
    await isar.writeTxn(() async {
      await isar.photoRecords.putAll(PhotoRecord.fromDomainList(photos));
    });
  }

  @override
  FutureOr<List<Photo>> build() async {
    return <Photo>[];
  }
}

extension on List<PhotoRecord> {
  List<Photo> toDomain() {
    return List.unmodifiable(map((e) => e.toDomainObject()));
  }
}
