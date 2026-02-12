import 'package:fintrack/features/settings/data/models/user_preferences_model.dart';
import 'package:fintrack/features/settings/data/models/user_profile_model.dart';
import 'package:fintrack/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:fintrack/features/settings/domain/entities/user_preferences.dart';
import 'package:fintrack/features/settings/domain/entities/user_profile.dart';
import 'package:fintrack/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/settings_mocks.dart';

class FakeUserProfileModel extends Fake implements UserProfileModel {}

class FakeUserPreferencesModel extends Fake implements UserPreferencesModel {}

void main() {
  late SettingsRepository repository;
  late MockSettingsService mockService;
  late MockSettingsLocal mockLocal;

  setUpAll(() {
    registerFallbackValue(FakeUserProfileModel());
    registerFallbackValue(FakeUserPreferencesModel());
  });

  setUp(() {
    mockService = MockSettingsService();
    mockLocal = MockSettingsLocal();
    repository = SettingsRepositoryImpl(
      service: mockService,
      local: mockLocal,
    );
  });

  group('SettingsRepositoryImpl', () {
    group('watchProfile', () {
      test('should emit cached profile immediately when available', () async {
        // Arrange
        final cachedProfile = SettingsTestFixtures.createUserProfileModel();
        when(
          () => mockLocal.getProfile(),
        ).thenAnswer((_) async => cachedProfile);
        when(
          () => mockService.getProfile(),
        ).thenAnswer((_) async => cachedProfile);
        when(() => mockLocal.saveProfile(any())).thenAnswer((_) async {});

        // Act
        final stream = repository.watchProfile();
        final results = await stream.take(2).toList();

        // Assert
        expect(results.length, greaterThanOrEqualTo(1));
        expect(results.first.id, equals('user-123'));
        expect(results.first.name, equals('John Doe'));
        verify(() => mockLocal.getProfile()).called(1);
      });

      test('should emit fresh profile after fetching from service', () async {
        // Arrange
        final cachedProfile = SettingsTestFixtures.createUserProfileModel(
          name: 'Cached Name',
        );
        final freshProfile = SettingsTestFixtures.createUserProfileModel(
          name: 'Fresh Name',
        );

        when(
          () => mockLocal.getProfile(),
        ).thenAnswer((_) async => cachedProfile);
        when(
          () => mockService.getProfile(),
        ).thenAnswer((_) async => freshProfile);
        when(() => mockLocal.saveProfile(any())).thenAnswer((_) async {});

        // Act
        final stream = repository.watchProfile();
        final results = await stream.take(2).toList();

        // Assert
        expect(results.length, 2);
        expect(results[0].name, equals('Cached Name'));
        expect(results[1].name, equals('Fresh Name'));
      });

      test('should only emit fresh profile when no cache available', () async {
        // Arrange
        final freshProfile = SettingsTestFixtures.createUserProfileModel();

        when(() => mockLocal.getProfile()).thenAnswer((_) async => null);
        when(
          () => mockService.getProfile(),
        ).thenAnswer((_) async => freshProfile);
        when(() => mockLocal.saveProfile(any())).thenAnswer((_) async {});

        // Act
        final stream = repository.watchProfile();
        final results = await stream.toList();

        // Assert
        expect(results.length, 1);
        expect(results.first.id, equals('user-123'));
      });

      test('should throw error when no cache and service fails', () async {
        // Arrange
        when(() => mockLocal.getProfile()).thenAnswer((_) async => null);
        when(
          () => mockService.getProfile(),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => repository.watchProfile().toList(),
          throwsException,
        );
      });

      test(
        'should not throw error when service fails but cache exists',
        () async {
          // Arrange
          final cachedProfile = SettingsTestFixtures.createUserProfileModel();

          when(
            () => mockLocal.getProfile(),
          ).thenAnswer((_) async => cachedProfile);
          when(
            () => mockService.getProfile(),
          ).thenThrow(Exception('Network error'));

          // Act
          final stream = repository.watchProfile();
          final results = await stream.toList();

          // Assert
          expect(results.length, 1);
          expect(results.first.name, equals('John Doe'));
        },
      );

      test('should save fresh profile to local cache', () async {
        // Arrange
        final freshProfile = SettingsTestFixtures.createUserProfileModel();

        when(() => mockLocal.getProfile()).thenAnswer((_) async => null);
        when(
          () => mockService.getProfile(),
        ).thenAnswer((_) async => freshProfile);
        when(() => mockLocal.saveProfile(any())).thenAnswer((_) async {});

        // Act
        await repository.watchProfile().toList();

        // Assert
        verify(() => mockLocal.saveProfile(freshProfile)).called(1);
      });
    });

    group('watchPreferences', () {
      test(
        'should emit cached preferences immediately when available',
        () async {
          // Arrange
          final cachedPreferences = SettingsTestFixtures.createUserPreferencesModel();
          when(
            () => mockLocal.getPreferences(),
          ).thenAnswer((_) async => cachedPreferences);
          when(
            () => mockService.getPreferences(),
          ).thenAnswer((_) async => cachedPreferences);
          when(() => mockLocal.savePreferences(any())).thenAnswer((_) async {});

          // Act
          final stream = repository.watchPreferences();
          final results = await stream.take(2).toList();

          // Assert
          expect(results.length, greaterThanOrEqualTo(1));
          expect(results.first.currency, equals('INR'));
          expect(results.first.theme, equals(ThemeOption.system));
          verify(() => mockLocal.getPreferences()).called(1);
        },
      );

      test(
        'should emit fresh preferences after fetching from service',
        () async {
          // Arrange
          final cachedPreferences = SettingsTestFixtures.createUserPreferencesModel();
          final freshPreferences = SettingsTestFixtures.createUserPreferencesModel(
            currency: 'USD',
          );

          when(
            () => mockLocal.getPreferences(),
          ).thenAnswer((_) async => cachedPreferences);
          when(
            () => mockService.getPreferences(),
          ).thenAnswer((_) async => freshPreferences);
          when(() => mockLocal.savePreferences(any())).thenAnswer((_) async {});

          // Act
          final stream = repository.watchPreferences();
          final results = await stream.take(2).toList();

          // Assert
          expect(results.length, 2);
          expect(results[0].currency, equals('INR'));
          expect(results[1].currency, equals('USD'));
        },
      );

      test(
        'should convert theme string to ThemeOption enum correctly',
        () async {
          // Arrange
          final preferences = SettingsTestFixtures.createUserPreferencesModel(
            theme: 'dark',
          );

          when(() => mockLocal.getPreferences()).thenAnswer((_) async => null);
          when(
            () => mockService.getPreferences(),
          ).thenAnswer((_) async => preferences);
          when(() => mockLocal.savePreferences(any())).thenAnswer((_) async {});

          // Act
          final result = await repository.watchPreferences().first;

          // Assert
          expect(result.theme, equals(ThemeOption.dark));
        },
      );

      test('should handle all theme variants', () async {
        // Arrange
        final themeVariants = SettingsTestFixtures.createThemeVariants();

        for (final variant in themeVariants) {
          when(() => mockLocal.getPreferences()).thenAnswer((_) async => null);
          when(
            () => mockService.getPreferences(),
          ).thenAnswer((_) async => variant);
          when(() => mockLocal.savePreferences(any())).thenAnswer((_) async {});

          // Act
          final result = await repository.watchPreferences().first;

          // Assert
          expect(result.theme, isA<ThemeOption>());
        }
      });

      test('should throw error when no cache and service fails', () async {
        // Arrange
        when(() => mockLocal.getPreferences()).thenAnswer((_) async => null);
        when(
          () => mockService.getPreferences(),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => repository.watchPreferences().toList(),
          throwsException,
        );
      });
    });

    group('getPreferences', () {
      test('should return cached preferences when available', () async {
        // Arrange
        final cachedPreferences = SettingsTestFixtures.createUserPreferencesModel();
        when(
          () => mockLocal.getPreferences(),
        ).thenAnswer((_) async => cachedPreferences);

        // Act
        final result = await repository.getPreferences();

        // Assert
        expect(result, isNotNull);
        expect(result!.currency, equals('INR'));
      });

      test('should return null when no cached preferences', () async {
        // Arrange
        when(() => mockLocal.getPreferences()).thenAnswer((_) async => null);

        // Act
        final result = await repository.getPreferences();

        // Assert
        expect(result, isNull);
      });
    });

    group('updateProfile', () {
      test('should update profile through service and local', () async {
        // Arrange
        const profile = UserProfile(
          id: 'user-123',
          name: 'Updated Name',
          email: 'updated@example.com',
        );
        final updatedModel = SettingsTestFixtures.createUserProfileModel(
          name: 'Updated Name',
          email: 'updated@example.com',
        );

        when(
          () => mockService.updateProfile(any()),
        ).thenAnswer((_) async => updatedModel);
        when(() => mockLocal.saveProfile(any())).thenAnswer((_) async {});

        // Act
        await repository.updateProfile(profile);

        // Assert
        verify(() => mockService.updateProfile(any())).called(1);
        verify(() => mockLocal.saveProfile(any())).called(1);
      });
    });

    group('updatePreferences', () {
      test('should update preferences through service and local', () async {
        // Arrange
        const preferences = UserPreferences(
          currency: 'EUR',
          theme: ThemeOption.dark,
          notificationsEnabled: false,
          weeklySummaryEnabled: false,
        );
        final updatedModel = SettingsTestFixtures.createUserPreferencesModel(
          currency: 'EUR',
          theme: 'dark',
          notificationsEnabled: false,
        );

        when(
          () => mockService.updatePreferences(any()),
        ).thenAnswer((_) async => updatedModel);
        when(() => mockLocal.savePreferences(any())).thenAnswer((_) async {});

        // Act
        await repository.updatePreferences(preferences);

        // Assert
        verify(() => mockService.updatePreferences(any())).called(1);
        verify(() => mockLocal.savePreferences(any())).called(1);
      });

      test('should update currency preference', () async {
        // Arrange
        const preferences = UserPreferences(
          currency: 'GBP',
        );

        when(() => mockService.updatePreferences(any())).thenAnswer(
          (_) async => SettingsTestFixtures.createUserPreferencesModel(currency: 'GBP'),
        );
        when(() => mockLocal.savePreferences(any())).thenAnswer((_) async {});

        // Act
        await repository.updatePreferences(preferences);

        // Assert
        verify(() => mockService.updatePreferences(any())).called(1);
      });
    });

    group('clearAllData', () {
      test('should clear data from both service and local', () async {
        // Arrange
        when(() => mockService.clearAllData()).thenAnswer((_) async {});
        when(() => mockLocal.clearAllData()).thenAnswer((_) async {});

        // Act
        await repository.clearAllData();

        // Assert
        verify(() => mockService.clearAllData()).called(1);
        verify(() => mockLocal.clearAllData()).called(1);
      });
    });
  });
}
