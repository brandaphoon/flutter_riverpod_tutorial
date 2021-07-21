import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class IncrementNotifier extends ChangeNotifier {
  int _value = 0;
  int get value => _value;

  void increment() {
    _value++;
    notifyListeners();
  }
}

// //Declaration is global but the the value that is returns can be scoped to local.
// final greetingProvider = Provider((ref) => 'Hello Riverpod!');

final incrementProvider = ChangeNotifierProvider((ref) => IncrementNotifier());

// //First Method of consuming a provider.
// //Rebuilds the entire widget.
// class MyApp extends ConsumerWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     final greeting = watch(greetingProvider);
//     return MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: Scaffold(
//             appBar: AppBar(title: Text("Riverpod")),
//              body: Center(child: Text(greeting) ,))
//     );
//   }
// }

// //Second Method of consuming a provider
// //Rebuilds only the consumer widget.
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: Scaffold(
//             appBar: AppBar(title: Text("Riverpod")),
//             body: Center(
//               child: Consumer(
//                 builder: (context, watch, child) {
//                   final greeting = watch(greetingProvider);
//                   return Text(greeting);
//                 },
//               ),
//             )
//         )
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: Scaffold(
//             appBar: AppBar(title: Text("Riverpod")),
//             body: Center(
//               child: Consumer(
//                 builder: (context, watch, child) {
//                   final incrementNotifier = watch(incrementProvider);
//                   return Text(incrementNotifier.value.toString());
//                 },
//               ),
//             ),
//             floatingActionButton: FloatingActionButton(
//               onPressed: () {
//                 context.read(incrementProvider).increment();
//             },
//             child: Icon(Icons.add),),
//         )
//     );
//   }
// }

// final firstStringProvider = Provider((ref) => 'First');
// final secondStringProvider = Provider((ref) => 'Second');

// //Demostration of reading two values from different providers.
// class MyApp extends ConsumerWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context, ScopedReader watch) {

//     final first = watch(firstStringProvider);
//     final second = watch(secondStringProvider);

//     return MaterialApp(
//         title: 'Flutter Demo',
//         home: Scaffold(
//           body: Column(
//             children: [
//               Text(first),
//               Text(second)
//             ],)
//         )
//     );
//   }
// }

class FakeHttpClient {
  Future<String> get(String url) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Response from $url';
  }
}

final fakeHttpClientProvider = Provider((ref) => FakeHttpClient());
//Future family is for non-constant values.
//AutoDispose will reduce chances of memory leaks.
final responseProvider = FutureProvider.autoDispose.family<String, String>((ref, url) async {
  final httpClient = ref.read(fakeHttpClientProvider);
  return httpClient.get(url);
});

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(body: Center(
          child: Consumer(
            builder: (context, watch, child) {
              final responseAsyncValue = watch(responseProvider("https://hello.com"));
              return responseAsyncValue.map(
                  data: (_) => Text(_.value),
                  loading: (_) => CircularProgressIndicator(),
                  error: (_) => Text(_.error.toString(),
                      style: TextStyle(color: Colors.red)));
            },
          ),
        )));
  }
}
