import 'dart:convert';

import 'package:flutter_list_riverpod/domain/photo.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_source.g.dart';

@riverpod
FutureOr<List<Photo>> remoteSource(RemoteSourceRef ref,
    {required int start, int limit = 20}) async {
  final resp = await http.get(Uri.parse(
      'https://jsonplaceholder.typicode.com/photos?_start=$start&_limit=$limit'));
  if (resp.statusCode != 200) {
    AsyncValue.error(Exception(resp.reasonPhrase), StackTrace.current);
    return <Photo>[];
  }

  final photos = Photo.fromJsonList(jsonDecode(resp.body));
  return photos;
}
