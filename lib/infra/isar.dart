import 'package:flutter_list_riverpod/infra/photo_record.dart';
import 'package:flutter_list_riverpod/main.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isar.g.dart';

@Riverpod(keepAlive: true)
FutureOr<Isar> isar(IsarRef ref) async {
  final dir = await getApplicationDocumentsDirectory();
  log.w('Isar init, directory: ${dir.path}');
  return await Isar.open(
    [PhotoRecordSchema],
    directory: dir.path,
  );
}
