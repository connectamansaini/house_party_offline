import 'package:flutter/material.dart';

/// The app's page scaffold: a flat, theme-derived surface. It used to paint a
/// tinted gradient behind every screen; the name stuck because every page
/// already uses it, but the background is now deliberately plain so the
/// content — and each game's single accent — is the only thing with color.
class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = false,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: appBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      body: body,
    );
  }
}
