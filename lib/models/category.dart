import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String description;
  final int departmentId;

  Category({this.id, this.name, this.description, this.departmentId});

  Category copyWith({
    int id,
    String name,
    String description,
    int departmentId,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      departmentId: departmentId ?? this.departmentId,
    );
  }

  @override
  List<Object> get props => [id, name, description, departmentId];

  @override
  String toString() => "Category {id:$id, name: $name} ";
}
