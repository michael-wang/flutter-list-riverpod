import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'item.dart';

class ListState extends Equatable {
  final List<Item> list;
  final int nextPage;

  const ListState({required this.list, required this.nextPage});

  @override
  List<Object?> get props => [list, nextPage];
}

class DataRepo extends StateNotifier<ListState> {
  static const itemsPerPage = 20;

  DataRepo() : super(const ListState(list: [], nextPage: 0));

  Future<void> fetchNextPage() async {
    await Future.delayed(const Duration(milliseconds: 250));

    final start = state.nextPage * itemsPerPage;
    final list = List<Item>.generate(
      20,
      (index) => Item(title: 'Item #${start + index}'),
    );

    state = ListState(
      list: [...state.list, ...list],
      nextPage: state.nextPage + 1,
    );
  }

  void toggleItemChecked(int index) {
    final item = state.list[index];
    final newItem = item.copyWith(checked: !item.checked);
    state = ListState(
        list: List<Item>.from(state.list)..[index] = newItem,
        nextPage: state.nextPage);
  }
}

final pageProvider =
    StateNotifierProvider<DataRepo, ListState>((ref) => DataRepo());
