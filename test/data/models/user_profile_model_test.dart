import 'package:fintrack/features/settings/data/models/user_profile_model.dart';
import 'package:fintrack/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfileModel', () {
    test('should create UserProfileModel with all fields', () {
      // Arrange & Act
      final model = UserProfileModel(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
        avatar: 'https://example.com/avatar.png',
      );

      // Assert
      expect(model.id, equals('user-123'));
      expect(model.name, equals('John Doe'));
      expect(model.email, equals('john@example.com'));
      expect(model.avatar, equals('https://example.com/avatar.png'));
    });

    test('should create UserProfileModel with null fields', () {
      // Arrange & Act
      final model = UserProfileModel();

      // Assert
      expect(model.id, isNull);
      expect(model.name, isNull);
      expect(model.email, isNull);
      expect(model.avatar, isNull);
    });

    test('should create UserProfileModel without avatar', () {
      // Arrange & Act
      final model = UserProfileModel(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
      );

      // Assert
      expect(model.id, equals('user-123'));
      expect(model.name, equals('John Doe'));
      expect(model.email, equals('john@example.com'));
      expect(model.avatar, isNull);
    });

    test('fromEntity should create model from UserProfile', () {
      // Arrange
      const entity = UserProfile(
        id: 'user-456',
        name: 'Jane Smith',
        email: 'jane@example.com',
        avatar: 'https://example.com/jane.png',
      );

      // Act
      final model = UserProfileModel.fromEntity(entity);

      // Assert
      expect(model.id, equals('user-456'));
      expect(model.name, equals('Jane Smith'));
      expect(model.email, equals('jane@example.com'));
      expect(model.avatar, equals('https://example.com/jane.png'));
    });

    test('fromEntity should handle null avatar', () {
      // Arrange
      const entity = UserProfile(
        id: 'user-789',
        name: 'Bob Wilson',
        email: 'bob@example.com',
      );

      // Act
      final model = UserProfileModel.fromEntity(entity);

      // Assert
      expect(model.id, equals('user-789'));
      expect(model.name, equals('Bob Wilson'));
      expect(model.email, equals('bob@example.com'));
      expect(model.avatar, isNull);
    });

    test('toEntity should convert to UserProfile with defaults', () {
      // Arrange
      final model = UserProfileModel(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
        avatar: 'https://example.com/avatar.png',
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.id, equals('user-123'));
      expect(entity.name, equals('John Doe'));
      expect(entity.email, equals('john@example.com'));
      expect(entity.avatar, equals('https://example.com/avatar.png'));
    });

    test('toEntity should use empty strings for null values', () {
      // Arrange
      final model = UserProfileModel();

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.id, equals(''));
      expect(entity.name, equals(''));
      expect(entity.email, equals(''));
      expect(entity.avatar, isNull);
    });

    test('round-trip conversion should preserve data', () {
      // Arrange
      const original = UserProfile(
        id: 'user-999',
        name: 'Alice Brown',
        email: 'alice@example.com',
        avatar: 'https://example.com/alice.png',
      );

      // Act
      final model = UserProfileModel.fromEntity(original);
      final result = model.toEntity();

      // Assert
      expect(result.id, equals(original.id));
      expect(result.name, equals(original.name));
      expect(result.email, equals(original.email));
      expect(result.avatar, equals(original.avatar));
    });

    test('round-trip conversion should preserve null avatar', () {
      // Arrange
      const original = UserProfile(
        id: 'user-000',
        name: 'Charlie Davis',
        email: 'charlie@example.com',
      );

      // Act
      final model = UserProfileModel.fromEntity(original);
      final result = model.toEntity();

      // Assert
      expect(result.id, equals(original.id));
      expect(result.name, equals(original.name));
      expect(result.email, equals(original.email));
      expect(result.avatar, isNull);
    });

    test('toJson should serialize correctly', () {
      // Arrange
      final model = UserProfileModel(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
        avatar: 'https://example.com/avatar.png',
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['id'], equals('user-123'));
      expect(json['name'], equals('John Doe'));
      expect(json['email'], equals('john@example.com'));
      expect(json['avatar'], equals('https://example.com/avatar.png'));
    });
  });
}
