import 'package:equatable/equatable.dart';
import 'package:flutter_list_riverpod/domain/item.dart';
import 'package:flutter_list_riverpod/infra/remote_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_repo.g.dart';

class Paginated<T> extends Equatable {
  final List<T> items;
  final int pageIndex;
  final int pageSize;

  const Paginated({
    this.items = const [],
    required this.pageIndex,
    required this.pageSize,
  });

  @override
  List<Object?> get props => [items, pageIndex, pageSize];

  Paginated<T> copyWith({
    List<T>? items,
    int? pageIndex,
    int? pageSize,
  }) {
    return Paginated<T>(
      items: items ?? [],
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

@riverpod
class DataRepo extends _$DataRepo {
  static const pageSize = 15;

  Future<List<Item>> _fetch(int start, int limit) async {
    return await ref
        .read(remoteSourceProvider.call(start: start, limit: limit).future);
  }

  @override
  FutureOr<Paginated<Item>> build() async {
    final items = await _fetch(0, pageSize);
    return Paginated<Item>(items: items, pageIndex: 0, pageSize: pageSize);
  }

  Future<void> loadPage() async {
    update((prev) async {
      final pageIndex = prev.pageIndex + 1;
      final start = pageIndex * prev.pageSize;
      final list = await _fetch(start, pageSize);
      return prev.copyWith(
        items: [...prev.items, ...list],
        pageIndex: pageIndex,
      );
    });
  }

  void toggleItemChecked(int index) {
    update((prev) {
      final item = prev.items[index];
      return prev.copyWith(
          items: List<Item>.from(prev.items)
            ..[index] = item.copyWith(checked: !item.checked));
    });
  }

  Future<void> reload() async {
    final items = await _fetch(0, pageSize);
    update((prev) {
      return Paginated<Item>(
        items: items,
        pageIndex: 0,
        pageSize: pageSize,
      );
    });
  }
}
