import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo.freezed.dart';
part 'photo.g.dart';

@freezed
class Photo with _$Photo {
  factory Photo({
    required int id,
    required String title,
    required String url,
    required String thumbnailUrl,
    @Default(false) bool selected,
  }) = _Photo;

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  static List<Photo> fromJsonList(List<dynamic> list) {
    return list.map((e) => Photo.fromJson(e)).toList();
  }

  const Photo._();

  Photo toggleSelected() => copyWith(selected: !selected);
}
