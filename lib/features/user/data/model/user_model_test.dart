// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class userModelTest {
  int id;
  String name;
  String phone;

  userModelTest({required this.id, required this.name, required this.phone});

  userModelTest copyWith({int? id, String? name, String? phone}) {
    return userModelTest(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'phone': phone};
  }

  factory userModelTest.fromMap(Map<String, dynamic> map) {
    return userModelTest(
      id: map['id'] as int,
      name: map['name'] as String,
      phone: map['phone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory userModelTest.fromJson(String source) =>
      userModelTest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'userModel(id: $id, name: $name, phone: $phone)';

  @override
  bool operator ==(covariant userModelTest other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.phone == phone;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ phone.hashCode;
}
