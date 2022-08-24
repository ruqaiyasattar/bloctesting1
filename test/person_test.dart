import 'package:bloctesting_demo/bloc/bloc_action.dart';
import 'package:bloctesting_demo/bloc/person.dart';
import 'package:bloctesting_demo/bloc/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockedPerson1 = [
  Person(
    age: 20,
    name: 'baa',
  ),
  Person(
    age: 10,
    name: 'Hon',
  ),
];

const mockedPerson2 = [
  Person(
    age: 70,
    name: 'Sam',
  ),
  Person(
    age: 15,
    name: 'Pet',
  ),
];

Future<Iterable<Person>> mockGetPerson1(String _) =>
    Future.value(mockedPerson1);

Future<Iterable<Person>> mockGetPerson2(String _) =>
    Future.value(mockedPerson2);

void main() {
  group('Testing bloc', () {
    //write our tests
    late PersonsBloc bloc;
    setUp(() => bloc = PersonsBloc());

    blocTest<PersonsBloc,FetchResult?>(
      'Test initial State',
      build: () => bloc,
      verify: (bloc) => expect(bloc.state,null),
    );

    //fetch mock data(person1) and compare it with FetchResult
    blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving person1 rom first iterable',
        build: () => bloc,
        act: (bloc){
          bloc.add(
            const LoadPersonAction(
              url: 'dumy_url_1',
              loader: mockGetPerson1,
            ),
          );
          bloc.add(
            const LoadPersonAction(
              url: 'dumy_url_1',
              loader: mockGetPerson1,
            ),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockedPerson1,
            isRetrievedFromCache: false,
          ),
          const FetchResult(
            persons: mockedPerson1,
            isRetrievedFromCache: true,
          ),
        ]
    );

    //fetch mock data(person2) and compare it with FetchResult
    blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving person2 rom second iterable',
        build: () => bloc,
        act: (bloc){
          bloc.add(
            const LoadPersonAction(
              url: 'dumy_url_2',
              loader: mockGetPerson2,
            ),
          );
          bloc.add(
            const LoadPersonAction(
              url: 'dumy_url_2',
              loader: mockGetPerson2,
            ),
          );
        },
        expect: () =>[
          const FetchResult(
            persons: mockedPerson2,
            isRetrievedFromCache: false,
          ),
          const FetchResult(
            persons: mockedPerson2,
            isRetrievedFromCache: true,
          ),
        ]
    );
  });
}
