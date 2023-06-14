import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final bool checked;
  final String title;

  const Item({this.checked = false, required this.title});

  @override
  List<Object?> get props => [checked, title];

  Item copyWith({String? title, bool? checked}) {
    return Item(
      title: title ?? this.title,
      checked: checked ?? this.checked,
    );
  }
}
