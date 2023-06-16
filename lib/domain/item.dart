import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';

@freezed
class Item with _$Item {
  // Call Item.create so you don't have to deal with updatedTimestamp.
  factory Item({
    required String title,
    required bool checked,
    // Save DateTime's millisecondsSinceEpoch because DateTime does not has const
    required int updatedTimestamp,
  }) = _Item;

  // In order to have method need private constructor.
  const Item._();

  // Factory to hide 'how updated work'.
  factory Item.create(String title) {
    return Item(
      title: title,
      checked: false,
      updatedTimestamp: _ts(),
    );
  }

  // Getter to hide 'how updated work'.
  DateTime get updated => DateTime.fromMillisecondsSinceEpoch(updatedTimestamp);

  Item toggleChecked() => copyWith(
        checked: !this.checked,
        updatedTimestamp: _ts(),
      );

  static int _ts() => DateTime.now().millisecondsSinceEpoch;
}
