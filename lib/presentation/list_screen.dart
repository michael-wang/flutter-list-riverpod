import 'package:flutter/material.dart';
import 'package:flutter_list_riverpod/domain/data_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(dataRepoProvider);
    final repo = ref.read(dataRepoProvider.notifier);
    return list.when(
      data: (data) {
        return ListView.builder(
          itemCount: data.items.length + 1,
          itemBuilder: (context, index) {
            if (index >= data.items.length) {
              // last item: show loading spinner as we load more data
              repo.loadPage();
              return const Center(child: CircularProgressIndicator());
            }
            final item = data.items[index];
            return CheckboxListTile(
              value: item.checked,
              onChanged: (checked) {
                repo.toggleItemChecked(index);
              },
              title: Text(item.title),
            );
          },
        );
      },
      error: (err, _) => ErrorWidget(err),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
