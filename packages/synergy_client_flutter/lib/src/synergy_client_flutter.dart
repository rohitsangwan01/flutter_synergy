import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:synergy_client_flutter/src/synergy_client_flutter_controller.dart';
import 'package:synergy_client_flutter/src/widgets/connect_page.dart';
import 'package:synergy_client_flutter/src/widgets/multi_hit_stack.dart';

/// SynergyClientFlutter is the main widget for Synergy Client
/// It wraps the child widget with `_SynergyClientFlutter` and auto initializes the `SynergyClientController`
/// and setup connection to the server
class SynergyClientFlutter extends StatefulWidget {
  final Widget child;
  final bool enabled;
  const SynergyClientFlutter({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<SynergyClientFlutter> createState() => _SynergyClientFlutterState();
}

class _SynergyClientFlutterState extends State<SynergyClientFlutter> {
  @override
  void initState() {
    if (widget.enabled) {
      Get.lazyPut(() => SynergyClientController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.enabled
        ? GetMaterialApp(
            debugShowCheckedModeBanner: false,
            logWriterCallback: (text, {bool? isError}) {
              // ignore logs
            },
            home: _SynergyClientFlutter(child: widget.child),
          )
        : widget.child;
  }
}

class _SynergyClientFlutter extends GetResponsiveView<SynergyClientController> {
  final Widget child;
  _SynergyClientFlutter({required this.child});

  @override
  Widget builder() {
    controller.handleShape(screen.width, screen.height);
    return Scaffold(
      body: MultiHitStack(
        children: [
          child,
          const _OpenSynergyClientWidget(),
          const CursorWidget(),
        ],
      ),
    );
  }
}

class CursorWidget extends GetView<SynergyClientController> {
  const CursorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Offset cursor = controller.mouseCursorPos.value;
      bool showCursor = controller.showCursor.value;
      return Visibility(
        visible: showCursor,
        child: Positioned(
          left: cursor.dx,
          top: cursor.dy,
          child: const Icon(Icons.circle),
        ),
      );
    });
  }
}

class _OpenSynergyClientWidget extends GetView<SynergyClientController> {
  const _OpenSynergyClientWidget();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => ConnectPage());
        },
        child: Obx(
          () => Icon(
            controller.isConnected.value
                ? Icons.network_check
                : Icons.network_locked,
            color: controller.isConnected.value ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
