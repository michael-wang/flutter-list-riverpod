import 'package:flutter/material.dart';
import 'package:flutter_list_riverpod/domain/data_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paginated = ref.watch(dataRepoProvider);
    final repo = ref.read(dataRepoProvider.notifier);
    return paginated.when(
      data: (page) {
        // Pull to refresh is accomplished by RefreshIndicator and onRefresh
        // call repo.reload() which reloads data (and clear checked states).
        return RefreshIndicator(
          onRefresh: () async {
            await repo.reload();
          },
          child: ListView.builder(
            itemCount: page.items.length + 1,
            itemBuilder: (context, index) {
              if (index >= page.items.length) {
                // last item: show loading spinner as we load more data
                repo.loadPage();
                return const Center(child: CircularProgressIndicator());
              }
              final photo = page.items[index];
              return CheckboxListTile(
                value: photo.selected,
                onChanged: (_) => repo.toggleSelected(index),
                title: Text(photo.url),
                secondary: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    photo.thumbnailUrl,
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        );
      },
      error: (err, _) => ErrorWidget(err),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
