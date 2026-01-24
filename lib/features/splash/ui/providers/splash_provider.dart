import 'package:fintrack/features/splash/ui/states/splash_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final splashProvider = NotifierProvider.autoDispose<SplashNotifier, SplashState>(SplashNotifier.new);

class SplashNotifier extends Notifier<SplashState> {
  @override
  SplashState build() {
    Future.microtask(_getVersion);

    return const SplashState();
  }

  /// Get app version
  Future<void> _getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    state = state.copyWith(version: packageInfo.version);
  }
}
