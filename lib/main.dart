import 'dart:convert';
import 'dart:io';
import 'package:bloctesting_demo/bloc/bloc_action.dart';
import 'package:bloctesting_demo/bloc/person.dart';
import 'package:bloctesting_demo/bloc/persons_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

extension Log on Object{
  void log() => devtools.log(toString());
}

//optional value if value not found in iterable
extension Subscript<T> on Iterable<T>{
  T? operator [](int index) => length > index ? elementAt(index) : null;
}


Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((request) => request.close())
    .then((response) => response.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromjson(e),),);

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
          create: (_) => PersonsBloc(),
          child: const HomePage()),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: (){
                  context.read<PersonsBloc>()
                      .add(
                    const LoadPersonAction(
                      url: persons1Url,
                      loader: getPersons,
                    ),
                  );
                },
                child: const Text('Load Json # 1'),
              ),
              TextButton(
                onPressed: (){
                  context.read<PersonsBloc>()
                      .add(
                    const LoadPersonAction(
                      url: persons2Url,
                      loader: getPersons,
                    ),
                  );
                },
                child: const Text('Load Json # 2'),
              )
            ],
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
              buildWhen: (previousResult, currentResult){
                return previousResult?.persons != currentResult?.persons;
              },
              builder: (context, fetchResult){
                fetchResult?.log();
                final persons = fetchResult?.persons;
                if (persons == null) {
                  return const SizedBox();
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: persons.length,
                    itemBuilder: (context, index){
                      final person = persons[index]!;
                      return ListTile(
                        title: Text(person.name),
                        subtitle: Text('${person.age} years old'),
                      );
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }
}
