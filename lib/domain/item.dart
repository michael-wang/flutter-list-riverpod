import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String title;
  final bool checked;
  // Save DateTime's millisecondsSinceEpoch because DateTime does not has const
  // constructor...
  final int _updated;

  const Item({
    required this.title,
    this.checked = false,
    int? updated,
  }) : _updated = updated ?? 0;

  factory Item.create(String title) {
    return Item(title: title, updated: DateTime.now().millisecondsSinceEpoch);
  }

  @override
  List<Object?> get props => [title, checked, _updated];

  DateTime get updated => DateTime.fromMillisecondsSinceEpoch(_updated);

  Item copyWith({String? title, bool? checked}) {
    return Item(
      title: title ?? this.title,
      checked: checked ?? this.checked,
      updated: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
