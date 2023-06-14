import 'package:flutter/material.dart';
import 'package:flutter_list_riverpod/domain/data_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(pageProvider);
    final repo = ref.read(pageProvider.notifier);
    return ListView.builder(
      itemCount: page.list.length + 1,
      itemBuilder: (context, index) {
        if (index >= page.list.length) {
          // last item: show loading spinner as we load more data
          repo.fetchNextPage();
          return const Center(child: CircularProgressIndicator());
        }
        final item = page.list[index];
        return CheckboxListTile(
          value: item.checked,
          onChanged: (checked) {
            repo.toggleItemChecked(index);
          },
          title: Text(item.title),
        );
      },
    );
  }
}
