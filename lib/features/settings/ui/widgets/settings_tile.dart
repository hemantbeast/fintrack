import 'package:fintrack/core/extensions/context_extensions.dart';
import 'package:fintrack/core/extensions/string_extensions.dart';
import 'package:fintrack/themes/colors.dart';
import 'package:fintrack/themes/custom_theme.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.onTap,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final VoidCallback onTap;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: semiboldTextStyle(
          color: context.theme.textTheme.bodyLarge?.color,
          fontSize: 14,
        ),
      ),
      subtitle: !subtitle.isNullOrEmpty()
          ? Text(
              subtitle!,
              style: defaultTextStyle(
                color: gray98,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            )
          : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
