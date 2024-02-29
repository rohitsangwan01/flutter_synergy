import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:synergy_client_flutter/synergy_client_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const SynergyClientFlutter(
      enabled: true,
      child: MaterialApp(
        title: "Synergy Client",
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Synergy client example'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Server IP',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              log('Button pressed');
            },
            child: const Text('Press me!'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 50,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    log('Item $index tapped');
                  },
                  title: Text('Item $index'),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
