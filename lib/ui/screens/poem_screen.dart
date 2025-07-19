import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majnusparrot/constants/my_custom_icons.dart';

import '../../managers/poem_manager.dart';
import '../../providers/poem_providers.dart';
import '../widgets/TextInputDialog.dart';
import '../widgets/ring_switch.dart';

class PoemScreen extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  PoemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// For Reading
    final poemText = ref.watch(poemTextProvider);
    final recommendation =
        ref.watch(poemManagerProvider); // Now we watch PoemManager's state
    final isModifyMode = ref.watch(isModifyModeProvider);
    final poemContext = ref.watch(poemContextProvider);

    /// For Writing
    final poemTextNotifier = ref.read(poemTextProvider.notifier);
    final isModifyModeNotifier = ref.read(isModifyModeProvider.notifier);
    final poemContextNotifier = ref.read(poemContextProvider.notifier);

    /// utilities
    final poemManager =
        ref.read(poemManagerProvider.notifier); // Access to PoemManager methods

    /// Theme Modes
    final themeModeNotifier = ref.read(colorSchemeProvider.notifier);

    /// Fields
    final colorScheme = ref.watch(colorSchemeProvider);

    _controller.addListener(() => _checkSelection(ref, poemManager));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 50,
        leadingWidth: 100,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 4.0,
        leading: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          IconButton(
            icon: const Icon(Icons.invert_colors),
            tooltip: 'Color Scheme',
            onPressed: () {
              colorScheme.themeType == 'Light'
                  ? themeModeNotifier.updateTheme('Dark')
                  : themeModeNotifier.updateTheme('Light');
              print('Switched Color Scheme');
            },
          ),
          IconButton(
            iconSize: 30,
            icon: const Icon(
              MyCustomIcons.parrotContext,
              size: 30.0,
            ),
            tooltip: 'Add Context',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => TextInputDialog(
                  onSubmitted: (text) {
                    // Handle the submitted text here
                    if (text.isNotEmpty) {
                      String finalPrompt =
                          'First here is some context\n$text\nFinally ,now Here is the poem:-\n$poemText';
                      poemContextNotifier.state = text;
                      poemManager.updateRecommendation(
                          finalPrompt, isModifyMode, true);
                    }
                  },
                  value: poemContext,
                ),
              );
            },
          ),
        ]),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            colorScheme.themeType == 'Light'
                ? 'assets/center.jpeg'
                : 'assets/center-dark.jpg',
          ),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 35),

              /// Toggle Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RingSwitch(
                    value: isModifyMode,
                    onChanged: (value) {
                      isModifyModeNotifier.state = value;
                      final isModifyMode = ref.read(isModifyModeProvider);
                      if (poemContext.isNotEmpty) {
                        String finalPrompt =
                            'First here is some context\n$poemContext\nFinally ,now Here is the poem:-\n$poemText';
                        poemManager.updateRecommendation(
                            finalPrompt, isModifyMode, true);
                      } else {
                        poemManager.updateRecommendation(
                            poemText, isModifyMode, true);
                      }
                    },
                    colorScheme: colorScheme,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              /// Content Area
              Expanded(
                child: Row(
                  children: [
                    /// Left Screen: Text Editor
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.editorBackground,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Write your poem here:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.headerTextColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: colorScheme.textFieldBackground,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  hintText: 'Type your poem...',
                                ),
                                onChanged: (text) {
                                  poemTextNotifier.state = text;
                                  if (poemContext.isNotEmpty) {
                                    String finalPrompt =
                                        'First here is some context\n$poemContext\nFinally ,now Here is the poem:-\n$text';
                                    poemManager.updateRecommendation(
                                        finalPrompt, isModifyMode, false);
                                  } else {
                                    poemManager.updateRecommendation(
                                        text, isModifyMode, false);
                                  }
                                },
                                maxLines: null,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colorScheme.bodyTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// Right Screen: AI Recommendations
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.recommendationBackground,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Recommendations:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.headerTextColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  recommendation.isNotEmpty
                                      ? recommendation
                                      : "Majnu's parrot can sometimes fly...",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: colorScheme.bodyTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkSelection(WidgetRef ref, PoemManager poemManager) {
    final isModifyMode = ref.read(isModifyModeProvider);
    poemManager.checkSelection(_controller.text, _controller.selection.start,
        _controller.selection.end, isModifyMode);
  }
}
