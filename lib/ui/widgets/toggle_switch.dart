import 'package:flutter/material.dart';
import 'package:majnusparrot/constants/my_custom_icons.dart';

import '../../constants/my_colors.dart';

class ToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const ToggleSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 8),
        Transform.scale(
          scale: 1.5, // Adjust this value to scale up or down
          child: Switch(
            value: value,
            onChanged: onChanged,
            inactiveTrackColor: MyColors.gold,
            thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                  (Set<WidgetState> states) {
                IconData icon = states.contains(WidgetState.selected)
                    ? MyCustomIcons.letterN
                    : MyCustomIcons.letterM;

                return Icon(
                  icon,
                  size: 15,
                  textDirection: TextDirection.ltr,
                  applyTextScaling: true,
                  opticalSize: 20,
                  weight: 2,
                );
              },
            ),
          ),

        ),
        const SizedBox(width: 8),
      ],
    );
  }
}