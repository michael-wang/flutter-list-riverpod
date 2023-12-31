import 'package:flutter_list_riverpod/domain/photo.dart';
import 'package:flutter_list_riverpod/infra/data_source.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_repo.freezed.dart';
part 'data_repo.g.dart';

@freezed
class Paginated<T> with _$Paginated<T> {
  factory Paginated({
    required List<T> items,
    required int pageIndex,
    required int pageSize,
  }) = _Paginated<T>;
}

@riverpod
class DataRepo extends _$DataRepo {
  static const pageSize = 20;

  Future<List<Photo>> _fetch(int start, int limit) async {
    return await ref
        .read(dataSourceProvider(start: start, limit: limit).future);
  }

  @override
  FutureOr<Paginated<Photo>> build() async {
    final photos = await _fetch(0, pageSize);
    return Paginated<Photo>(items: photos, pageIndex: 0, pageSize: pageSize);
  }

  Future<void> loadPage() async {
    update((prev) async {
      final pageIndex = prev.pageIndex + 1;
      final start = pageIndex * prev.pageSize;
      final photos = await _fetch(start, pageSize);

      return prev.copyWith(
        items: [...prev.items, ...photos],
        pageIndex: pageIndex,
      );
    });
  }

  void toggleSelected(int index) {
    update((prev) {
      final item = prev.items[index];
      return prev.copyWith(
          items: List<Photo>.from(prev.items)..[index] = item.toggleSelected());
    });
  }

  Future<void> reload() async {
    final photos = await _fetch(0, pageSize);

    update((prev) {
      return Paginated<Photo>(
        items: photos,
        pageIndex: 0,
        pageSize: pageSize,
      );
    });
  }
}
