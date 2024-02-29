import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:synergy_client_flutter/src/synergy_client_flutter_controller.dart';
import 'package:synergy_client_flutter/src/widgets/multi_hit_stack.dart';
import 'package:synergy_client_flutter/synergy_client_flutter.dart';

class ConnectPage extends GetView<SynergyClientController> {
  ConnectPage({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiHitStack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Synergy Client'),
            actions: [
              Obx(
                () => controller.logs.isEmpty
                    ? const SizedBox()
                    : IconButton(
                        onPressed: () {
                          controller.logs.clear();
                        },
                        icon: const Icon(Icons.clear_all),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Obx(() => Icon(
                      Icons.circle,
                      color: controller.isConnected.value
                          ? Colors.green
                          : Colors.red,
                    )),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.serverIpController,
                    decoration: const InputDecoration(
                      labelText: 'Server IP',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter server IP';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.serverPortController,
                    decoration: const InputDecoration(
                      labelText: 'Server Port',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter server port';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid port number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.clientNameController,
                    decoration: const InputDecoration(
                      labelText: 'Screen Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter screen name';
                      }
                      return null;
                    },
                  ),
                  Obx(() => Card(
                        child: SwitchListTile.adaptive(
                            title: const Text('Auto Connect'),
                            value: controller.autoConnect.value,
                            onChanged: (value) {
                              controller.setAutoConnect(value);
                            }),
                      )),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() == false) return;
                          controller.connect();
                        },
                        child: const Text('Connect'),
                      ),
                      ElevatedButton(
                          onPressed: controller.disconnect,
                          child: const Text('Disconnect')),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        itemCount: controller.logs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(controller.logs[index]);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const CursorWidget(),
      ],
    );
  }
}
