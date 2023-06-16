import 'package:flutter_list_riverpod/domain/photo.dart';
import 'package:isar/isar.dart';

part 'photo_record.g.dart';

@collection
class PhotoRecord {
  @Index()
  Id? id;

  String? title;
  String? url;
  String? thumbnailUrl;

  Photo toDomainObject() {
    return Photo(
      id: id ?? 0,
      title: title ?? '',
      url: url ?? '',
      thumbnailUrl: thumbnailUrl ?? '',
    );
  }

  static PhotoRecord fromDomain(Photo photo) {
    final o = PhotoRecord();
    o.id = photo.id;
    o.title = photo.title;
    o.url = photo.url;
    o.thumbnailUrl = photo.thumbnailUrl;
    return o;
  }

  static List<PhotoRecord> fromDomainList(List<Photo> photos) {
    return List.unmodifiable(photos.map((e) => PhotoRecord.fromDomain(e)));
  }
}
