import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:plugin_codelab/plugin_codelab.dart';

enum _KeyType { Black, White }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;
    try {
      platformVersion = await PluginCodelab.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void _onKeyDown(int key) {
    log("key down:$key");
    PluginCodelab.onKeyDown(key).then((value) => print(value));
  }

  void _onKeyUp(int key) {
    log("key up:$key");
    PluginCodelab.onKeyUp(key).then((value) => print(value));
  }

  Widget _makeKey({@required _KeyType? keyType, @required int? key}) {
    return AnimatedContainer(
      height: 200,
      width: 44,
      duration: const Duration(seconds: 2),
      curve: Curves.easeIn,
      child: Material(
        color: keyType == _KeyType.White
            ? Colors.white
            : const Color.fromARGB(255, 60, 60, 80),
        child: InkWell(
          onTap: () => _onKeyUp(key ?? 0),
          onTapDown: (details) => _onKeyDown(key ?? 0),
          onTapCancel: () => _onKeyUp(key ?? 0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 30, 0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _makeKey(keyType: _KeyType.White, key: 10),
                  _makeKey(keyType: _KeyType.Black, key: 21),
                  _makeKey(keyType: _KeyType.White, key: 32),
                  _makeKey(keyType: _KeyType.Black, key: 43),
                  _makeKey(keyType: _KeyType.White, key: 54),
                  _makeKey(keyType: _KeyType.White, key: 65),
                  _makeKey(keyType: _KeyType.Black, key: 76),
                  _makeKey(keyType: _KeyType.White, key: 87),
                  _makeKey(keyType: _KeyType.Black, key: 98),
                  _makeKey(keyType: _KeyType.White, key: 109),
                  _makeKey(keyType: _KeyType.Black, key: 120),
                  _makeKey(keyType: _KeyType.White, key: 130),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
