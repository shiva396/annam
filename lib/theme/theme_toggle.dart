import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme_provider.dart';
import '../utils/color_data.dart';
import '../utils/custom_icon.dart';
import '../utils/size_data.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<ThemeMode, Color> themeMap = ref.watch(themeProvider);
    ThemeProviderNotifier notifier = ref.read(themeProvider.notifier);

    bool isDark = themeMap.keys.first == ThemeMode.dark;

    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double aspectRatio = sizeData.aspectRatio;
    return GestureDetector(
      onTap: () {
        notifier.toggleThemeMode(!isDark);
      },
      child: Align(
        alignment: Alignment.topRight,
        child: CustomIcon(
          size: aspectRatio * 80,
          icon: isDark ? Icons.light_mode_rounded : Icons.nights_stay_rounded,
          color: colorData.fontColor(.8),
        ),
      ),
    );
  }
}
