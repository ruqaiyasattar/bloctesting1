import 'package:flutter/foundation.dart' show immutable;

@immutable
class Person{
  final String name;
  final int age;

  const Person({required this.name, required this.age});

  Person.fromjson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;

  @override
  String toString() => 'Person (name = $name, age = $age)';
}
