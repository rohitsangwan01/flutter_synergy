# Synergy Client Flutter

[![synergy_client_dart version](https://img.shields.io/pub/v/synergy_client_dart?label=synergy_client_dart)](https://pub.dev/packages/synergy_client_dart)
[![synergy_client_flutter version](https://img.shields.io/pub/v/synergy_client_flutter?label=synergy_client_flutter)](https://pub.dev/packages/synergy_client_flutter)

<div align="center">
  <img src="https://github.com/rohitsangwan01/flutter_synergy/assets/59526499/faef2883-8b84-416d-9736-31d6436feb7a" height=120 />
  <h1>Flutter Synergy</h1>
</div>

**Flutter Synergy Client:** A flutter client implementation for synergy servers like Synergy, Barrier, InputLeap

## Get started

Disable SSL in server ( Encryption not supported yet )

To use with dart only, checkout [synergy_client_dart](https://github.com/rohitsangwan01/flutter_synergy/tree/main/packages/synergy_client_dart)

Wrap your app in SynergyClientFlutter, That's it, a floating button will appear in app
tap on it to enter details and connect to Synergy

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const SynergyClientFlutter(
      enabled: true,
      child: MaterialApp(
        ....
      ),
    ),
  );
}
```

## Demo

https://github.com/rohitsangwan01/flutter_synergy/assets/59526499/6cb086f2-b390-490a-b8e6-a95aeb5d2b17

## Note:

Inspired from [synergy-android](https://github.com/symless/synergy-android-7)
This project is in initial stage, Api's might change
