import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upload_download_app/controllers/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  final ThemeMode mode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context, listen: false);

    final nameController = TextEditingController(text: settingsController.url);

    void saveData() {
      settingsController.setUrl(nameController.text);
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            ElevatedButton(
              //style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () {
                saveData();
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
            // IconButton(
            //   icon: const Icon(Icons.save_rounded),
            //   onPressed: () {},
            // ),
          ],
          title: const Text('Second Route'),
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(16),
              child: Consumer<SettingsController>(builder: (context, settings, child) {
                return TextField(
                  controller: nameController,
                  // decoration: const InputDecoration(
                  //   border: OutlineInputBorder(),
                  //   hintText: 'Enter a search term',
                  //   labelText: "API Url",
                  // ),
                );
              }),
            ),
            const Text("Theme"),
            Consumer<SettingsController>(builder: (context, settings, child) {
              return SegmentedButton<ThemeMode>(
                  selected: <ThemeMode>{settings.thememode},
                  onSelectionChanged: (Set<ThemeMode> newSelection) {
                    settings.setThemeMode(newSelection.first);
                  },
                  segments: const [
                    ButtonSegment<ThemeMode>(value: ThemeMode.system, label: Text('System')),
                    ButtonSegment<ThemeMode>(value: ThemeMode.light, label: Text('Light')),
                    ButtonSegment<ThemeMode>(value: ThemeMode.dark, label: Text('Dark'))
                  ]);
            }),
          ],
        ));
  }
}
