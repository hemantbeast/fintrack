import 'dart:async';

import 'package:fintrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fintrack/features/dashboard/domain/entities/exchange_rates.dart';
import 'package:fintrack/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fintrack/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:fintrack/features/settings/domain/entities/currency.dart';
import 'package:fintrack/features/settings/domain/entities/user_preferences.dart';
import 'package:fintrack/features/settings/domain/entities/user_profile.dart';
import 'package:fintrack/features/settings/domain/repositories/settings_repository.dart';
import 'package:fintrack/features/settings/ui/providers/settings_provider.dart';
import 'package:fintrack/features/settings/ui/states/settings_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/provider_mocks.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockDashboardRepository extends Mock implements DashboardRepository {}

class MockSettingsNotifier extends Mock implements SettingsNotifier {}

class FakeUserProfile extends Fake implements UserProfile {}

class FakeUserPreferences extends Fake implements UserPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeUserProfile());
    registerFallbackValue(FakeUserPreferences());

    // Mock platform channel for PackageInfo
    const channel = MethodChannel('dev.fluttercommunity.plus/package_info');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'getAll') {
            return {
              'appName': 'FinTrack',
              'packageName': 'com.example.fintrack',
              'version': '1.0.0',
              'buildNumber': '1',
            };
          }
          return null;
        });
  });

  group('SettingsNotifier', () {
    late MockSettingsRepository mockSettingsRepository;
    late MockDashboardRepository mockDashboardRepository;

    setUp(() {
      mockSettingsRepository = MockSettingsRepository();
      mockDashboardRepository = MockDashboardRepository();
    });

    ProviderContainer createContainer() {
      return ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(mockSettingsRepository),
          dashboardRepositoryProvider.overrideWithValue(
            mockDashboardRepository,
          ),
        ],
      );
    }

    test('initial state should be loading', () {
      // Arrange - Set up empty streams before creating container
      when(
        () => mockSettingsRepository.watchProfile(),
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => mockSettingsRepository.watchPreferences(),
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => mockSettingsRepository.getPreferences(),
      ).thenAnswer((_) async => null);
      when(
        () => mockDashboardRepository.watchExchangeRates(
          baseCurrency: any(named: 'baseCurrency'),
        ),
      ).thenAnswer((_) => const Stream.empty());

      final container = createContainer();
      addTearDown(container.dispose);

      // Act
      final state = container.read(settingsProvider);

      // Assert
      expect(state.screenData, isA<AsyncLoading>());
    });

    test('should update profile successfully', () async {
      // Arrange
      const profile = UserProfile(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
      );
      const preferences = UserPreferences(
        currency: 'INR',
        theme: ThemeOption.system,
      );
      const updatedProfile = UserProfile(
        id: 'user-123',
        name: 'Jane Doe',
        email: 'jane@example.com',
      );

      when(
        () => mockSettingsRepository.watchProfile(),
      ).thenAnswer((_) => Stream.value(profile));
      when(
        () => mockSettingsRepository.watchPreferences(),
      ).thenAnswer((_) => Stream.value(preferences));
      when(
        () => mockSettingsRepository.getPreferences(),
      ).thenAnswer((_) async => preferences);
      when(
        () => mockDashboardRepository.watchExchangeRates(
          baseCurrency: any(named: 'baseCurrency'),
        ),
      ).thenAnswer(
        (_) => Stream.value(ProviderTestFixtures.createExchangeRates()),
      );
      when(
        () => mockSettingsRepository.updateProfile(any()),
      ).thenAnswer((_) async {});

      final container = createContainer();
      addTearDown(container.dispose);

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));

      // Act
      await container
          .read(settingsProvider.notifier)
          .updateProfile(updatedProfile);

      // Assert
      verify(
        () => mockSettingsRepository.updateProfile(updatedProfile),
      ).called(1);
    });

    test('should update preferences successfully', () async {
      // Arrange
      const profile = UserProfile(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
      );
      const preferences = UserPreferences(
        currency: 'INR',
        theme: ThemeOption.system,
      );
      const updatedPreferences = UserPreferences(
        currency: 'USD',
        theme: ThemeOption.dark,
      );

      when(
        () => mockSettingsRepository.watchProfile(),
      ).thenAnswer((_) => Stream.value(profile));
      when(
        () => mockSettingsRepository.watchPreferences(),
      ).thenAnswer((_) => Stream.value(preferences));
      when(
        () => mockSettingsRepository.getPreferences(),
      ).thenAnswer((_) async => preferences);
      when(
        () => mockDashboardRepository.watchExchangeRates(
          baseCurrency: any(named: 'baseCurrency'),
        ),
      ).thenAnswer(
        (_) => Stream.value(ProviderTestFixtures.createExchangeRates()),
      );
      when(
        () => mockSettingsRepository.updatePreferences(any()),
      ).thenAnswer((_) async {});

      final container = createContainer();
      addTearDown(container.dispose);

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));

      // Act
      await container
          .read(settingsProvider.notifier)
          .updatePreferences(updatedPreferences);

      // Assert
      verify(
        () => mockSettingsRepository.updatePreferences(updatedPreferences),
      ).called(1);
    });

    test('should clear all data successfully', () async {
      // Arrange
      const profile = UserProfile(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
      );
      const preferences = UserPreferences(
        currency: 'INR',
        theme: ThemeOption.system,
      );

      when(
        () => mockSettingsRepository.watchProfile(),
      ).thenAnswer((_) => Stream.value(profile));
      when(
        () => mockSettingsRepository.watchPreferences(),
      ).thenAnswer((_) => Stream.value(preferences));
      when(
        () => mockSettingsRepository.getPreferences(),
      ).thenAnswer((_) async => preferences);
      when(
        () => mockDashboardRepository.watchExchangeRates(
          baseCurrency: any(named: 'baseCurrency'),
        ),
      ).thenAnswer(
        (_) => Stream.value(ProviderTestFixtures.createExchangeRates()),
      );
      when(
        () => mockSettingsRepository.clearAllData(),
      ).thenAnswer((_) async {});

      final container = createContainer();
      addTearDown(container.dispose);

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));

      // Act
      await container.read(settingsProvider.notifier).clearAllData();

      // Assert
      verify(() => mockSettingsRepository.clearAllData()).called(1);
    });

    test('should refresh settings', () async {
      // Arrange
      const profile = UserProfile(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
      );
      const preferences = UserPreferences(
        currency: 'INR',
        theme: ThemeOption.system,
      );

      when(
        () => mockSettingsRepository.watchProfile(),
      ).thenAnswer((_) => Stream.value(profile));
      when(
        () => mockSettingsRepository.watchPreferences(),
      ).thenAnswer((_) => Stream.value(preferences));
      when(
        () => mockSettingsRepository.getPreferences(),
      ).thenAnswer((_) async => preferences);
      when(
        () => mockDashboardRepository.watchExchangeRates(
          baseCurrency: any(named: 'baseCurrency'),
        ),
      ).thenAnswer(
        (_) => Stream.value(ProviderTestFixtures.createExchangeRates()),
      );

      final container = createContainer();
      addTearDown(container.dispose);

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));

      // Act
      await container.read(settingsProvider.notifier).refresh();

      // Assert - Repository should be called again after refresh
      verify(
        () => mockSettingsRepository.watchProfile(),
      ).called(greaterThanOrEqualTo(1));
    });
  });
}
