import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_provider/providers/datetime_stream.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TimeReliantStateProvider>(create: (_) => TimeReliantStateProvider())
      ],
      child: const MainApp(),
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TimeReliantStateProvider>().init(context);
    context.read<TimeReliantStateProvider>().startListener();
    return MaterialApp(
      home: Scaffold(
        body: _buildListView(
          context.watch<TimeReliantStateProvider>().objectsStateMap
        ),
      ),
    );
  }

  Widget _buildListView(Map<String, Map<int, (DateTime, DateTime)>> objMap) {
    print(objMap.toString());
    return ListView(
      children: [
      ...objMap.keys.map((key) {
        return Container(
          margin: const EdgeInsets.only(bottom: 5),
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...objMap[key]!.keys.map((code) {
                return Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: Text(objMap[key]![code].toString()),
                );
              })
            ]
            ),
        );
      })
      ],
    );
  }
}