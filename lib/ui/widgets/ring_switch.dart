import 'package:flutter/material.dart';
import '../../constants/my_custom_icons.dart';
import '../../managers/poem_style_manager.dart';

class RingSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final MyColorScheme colorScheme;

  const RingSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: SizedBox(
        width: 60, // Larger switch width
        height: 60, // Larger switch height
        child: Stack(
          children: [
            // Background
            AnimatedContainer(
              duration: const Duration(milliseconds: 1200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: value ? colorScheme.switchOff : colorScheme.switchOn,
              ),
            ),
            // Thumb
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: 5,
              top: 5,
              bottom: 5,
              right: 5,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      value ? MyCustomIcons.letterM : MyCustomIcons.letterN,
                      key: ValueKey<bool>(value), // Unique key for each state
                      size: 24, // Larger icon size
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
