# Synergy Client Flutter

[![synergy_client_dart version](https://img.shields.io/pub/v/synergy_client_dart?label=synergy_client_dart)](https://pub.dev/packages/synergy_client_dart)
[![synergy_client_flutter version](https://img.shields.io/pub/v/synergy_client_flutter?label=synergy_client_flutter)](https://pub.dev/packages/synergy_client_flutter)

<div align="center">
  <img src="https://github.com/rohitsangwan01/flutter_synergy/assets/59526499/faef2883-8b84-416d-9736-31d6436feb7a" height=120 />
  <h1>Flutter Synergy</h1>
</div>

**Flutter Synergy Client:** A flutter client implementation for synergy servers like [Synergy](https://symless.com/synergy), [Barrier](https://github.com/debauchee/barrier), [InputLeap](https://github.com/input-leap/input-leap)

## Get started

Disable SSL in server ( Encryption not supported yet )

### To use in Flutter, import [synergy_client_flutter](https://pub.dev/packages/synergy_client_flutter)

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

### To use in pure Dart, import [synergy_client_dart](https://pub.dev/packages/synergy_client_dart)

Create a class extending `ScreenInterface`

```dart
class BasicScreen extends ScreenInterface {
    // Implement all methods
}
```

Connect with synergy using this screen interface

```dart
var screen = BasicScreen();

await SynergyClientDart.connect(
    screen: screen,
    serverIp: serverIp,
    serverPort: serverPort,
    clientName: clientName,
);
```

To Disconnect

```dart
SynergyClientDart.disconnect();
```

Checkout complete [documentation](https://github.com/rohitsangwan01/flutter_synergy/tree/main)

## Demo

![flutter_synergy_demo](https://github.com/rohitsangwan01/flutter_synergy/assets/59526499/03b25072-6b7c-4a0b-9fb3-40840a88cf10)

## Note:

Inspired from [synergy-android](https://github.com/symless/synergy-android-7)

This project is in initial stage, Api's might change
