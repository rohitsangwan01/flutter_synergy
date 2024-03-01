# Synergy Client Dart

[![synergy_client_dart version](https://img.shields.io/pub/v/synergy_client_dart?label=synergy_client_dart)](https://pub.dev/packages/synergy_client_dart)
[![synergy_client_flutter version](https://img.shields.io/pub/v/synergy_client_flutter?label=synergy_client_flutter)](https://pub.dev/packages/synergy_client_flutter)

<div align="center">
  <img src="https://github.com/rohitsangwan01/flutter_synergy/assets/59526499/faef2883-8b84-416d-9736-31d6436feb7a" height=120 />
  <h1>Flutter Synergy</h1>
</div>

**Dart Synergy Client:** A dart client implementation for synergy servers like Synergy, Barrier, InputLeap

## Get started

Disable SSL in server ( Encryption not supported yet )

To use with flutter, checkout [synergy_client_flutter](https://pub.dev/packages/synergy_client_flutter)

Create a calls extending `ScreenInterface`

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

## Note:

Inspired from [synergy-android](https://github.com/symless/synergy-android-7)

This project is in initial stage, Api's might change
