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
        // Pull to refresh is accomplished by RefreshIndicator and onRefresh
        // call repo.reload() which reloads data (and clear checked states).
        return RefreshIndicator(
          onRefresh: () async {
            await repo.reload();
          },
          child: ListView.builder(
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
                subtitle: Text(item.updated.readableTime()),
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

extension on DateTime {
  String readableTime() {
    String h = _twoDigits(hour);
    String min = _twoDigits(minute);
    String sec = _twoDigits(second);
    String ms = _threeDigits(millisecond);
    return '$h : $min : $sec . $ms';
  }

  static String _threeDigits(int n) {
    if (n >= 100) return "$n";
    if (n >= 10) return "0$n";
    return "00$n";
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
