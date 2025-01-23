import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_search/components/ActionButton.dart';
import 'package:word_search/components/AppBarTitle.dart';
import 'package:word_search/components/CustomSwitch.dart';
import 'package:word_search/providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _brightnessController = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    _brightnessController.value = ref.read(settingsThemeBrightnessProvider);
    _brightnessController.addListener(() {
      setState(() {
        if (_brightnessController.value) {
          ref.read(settingsThemeBrightnessProvider.notifier).setDark();
        } else {
          ref.read(settingsThemeBrightnessProvider.notifier).setLight();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        title: Row(
          children: <Widget>[
            ActionButton(
              onTap: () {
                Navigator.pop(context);
              },
              iconData: Icons.arrow_back,
            ),
            const Spacer(),
            const AppBarTitle(title: 'SETTINGS'),
            const Spacer(),
            ActionButton(
              onTap: () {},
              iconData: Icons.abc,
              isVisible: false,
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'Theme',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: <Widget>[
                ColorButton(ref, Colors.blue),
                ColorButton(ref, Colors.red),
                ColorButton(ref, Colors.green),
                ColorButton(ref, Colors.yellow),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: <Widget>[
                ColorButton(ref, Colors.purple),
                ColorButton(ref, Colors.orange),
                ColorButton(ref, Colors.pink),
                ColorButton(ref, Colors.teal),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Ensures space between Text and Switch
              children: [
                Text(
                  'Dark mode',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                CustomSwitch(
                    controller: _brightnessController,
                    activeText: "ON",
                    inactiveText: "OFF")
              ],
            ),
          ),
          // SwitchListTile(
          //   title: const Text('Dark mode'),
          //   value: ref.watch(
          //       settingsThemeBrightnessProvider), // Watch the current theme state
          //   onChanged: (bool isDark) {
          //     if (isDark) {
          //       ref
          //           .read(settingsThemeBrightnessProvider.notifier)
          //           .setDark(); // Set dark mode
          //     } else {
          //       ref
          //           .read(settingsThemeBrightnessProvider.notifier)
          //           .setLight(); // Set light mode
          //     }
          //   },
          // ),
        ],
      )),
    );
  }
}

Widget ColorButton(WidgetRef ref, Color color) => Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: GestureDetector(
          onTap: () {
            ref
                .read(settingsThemeSeedColorProvider.notifier)
                .setSeedColor(color);
          },
          child: Container(
            color: color,
            height: 48,
          ),
        ),
      ),
    );
