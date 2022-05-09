import 'package:app_riverpod/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//counterprovider

abstract class websocketclient {
  Stream<int> getCounterStream([int start]);
}

class Fakewebsocketclient implements websocketclient {
  @override
  Stream<int> getCounterStream([int start = 0]) async* {
    int i = start;
    while (true) {
      yield i++;
      await Future.delayed(
        const Duration(milliseconds: 500),
      );
    }
  }
}

final websocketclientProvider = Provider<websocketclient>((ref) {
  return Fakewebsocketclient();
});

final counterProvider = StreamProvider.family<int, int>((ref, start) {
  final wsclient = ref.watch(websocketclientProvider);
  return wsclient.getCounterStream(start);
});
void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'counter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
