import 'dart:convert';

import 'package:flutter_list_riverpod/domain/photo.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_source.g.dart';

@riverpod
FutureOr<(List<Photo>, Object? err)> dataSource(DataSourceRef ref,
    {required int start, int limit = 20}) async {
  final resp = await http.get(Uri.parse(
      'http://jsonplaceholder.typicode.com/photos?_start=$start&_limit=$limit'));
  if (resp.statusCode != 200) {
    return (<Photo>[], Exception(resp.reasonPhrase));
  }

  final photos = Photo.fromJsonList(jsonDecode(resp.body));
  return (photos, null);
}
