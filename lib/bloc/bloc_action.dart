import 'package:bloctesting_demo/bloc/person.dart';
import 'package:flutter/foundation.dart' show immutable;

const persons1Url = 'http://192.168.2.106:8080/person1.json';
const persons2Url = 'http://192.168.2.106:8080/person2.json';

typedef PersonLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction{
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction{
  final String url;
  final PersonLoader loader;

  const LoadPersonAction({
    required this.url,
    required this.loader,
  }) : super();
}
