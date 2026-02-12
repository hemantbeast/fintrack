import 'package:fintrack/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfile', () {
    test('should create UserProfile with all fields', () {
      // Arrange & Act
      const profile = UserProfile(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
        avatar: 'https://example.com/avatar.png',
      );

      // Assert
      expect(profile.id, equals('user-123'));
      expect(profile.name, equals('John Doe'));
      expect(profile.email, equals('john@example.com'));
      expect(profile.avatar, equals('https://example.com/avatar.png'));
    });

    test('should create UserProfile without avatar', () {
      // Arrange & Act
      const profile = UserProfile(
        id: 'user-456',
        name: 'Jane Smith',
        email: 'jane@example.com',
      );

      // Assert
      expect(profile.id, equals('user-456'));
      expect(profile.name, equals('Jane Smith'));
      expect(profile.email, equals('jane@example.com'));
      expect(profile.avatar, isNull);
    });

    test('should create UserProfile with minimal fields', () {
      // Arrange & Act
      const profile = UserProfile(
        id: '',
        name: '',
        email: '',
      );

      // Assert
      expect(profile.id, equals(''));
      expect(profile.name, equals(''));
      expect(profile.email, equals(''));
      expect(profile.avatar, isNull);
    });

    test('should handle long names', () {
      // Arrange & Act
      const profile = UserProfile(
        id: 'user-789',
        name: 'John Jacob Jingleheimer Schmidt',
        email: 'john@example.com',
      );

      // Assert
      expect(profile.name, equals('John Jacob Jingleheimer Schmidt'));
    });

    test('should handle various email formats', () {
      // Arrange & Act
      const email1 = UserProfile(
        id: '1',
        name: 'Test',
        email: 'simple@example.com',
      );
      const email2 = UserProfile(
        id: '2',
        name: 'Test',
        email: 'user.name@example.co.uk',
      );
      const email3 = UserProfile(
        id: '3',
        name: 'Test',
        email: 'user+tag@example.com',
      );

      // Assert
      expect(email1.email, equals('simple@example.com'));
      expect(email2.email, equals('user.name@example.co.uk'));
      expect(email3.email, equals('user+tag@example.com'));
    });

    test('should handle various avatar URLs', () {
      // Arrange & Act
      const profile1 = UserProfile(
        id: '1',
        name: 'Test',
        email: 'test@example.com',
        avatar: 'https://example.com/avatar.png',
      );
      const profile2 = UserProfile(
        id: '2',
        name: 'Test',
        email: 'test@example.com',
        avatar: 'http://example.com/avatar.jpg',
      );
      const profile3 = UserProfile(
        id: '3',
        name: 'Test',
        email: 'test@example.com',
        avatar: 'https://gravatar.com/avatar/abc123',
      );

      // Assert
      expect(profile1.avatar, equals('https://example.com/avatar.png'));
      expect(profile2.avatar, equals('http://example.com/avatar.jpg'));
      expect(profile3.avatar, equals('https://gravatar.com/avatar/abc123'));
    });

    test('should be immutable', () {
      // Arrange
      const profile = UserProfile(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
      );

      // Assert - Since all fields are final, we can't modify them
      expect(profile.id, equals('user-123'));
      // Any attempt to change fields would be a compile-time error
    });

    test('should support equality', () {
      // Arrange
      const profile1 = UserProfile(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
      );
      const profile2 = UserProfile(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
      );
      const profile3 = UserProfile(
        id: 'user-456',
        name: 'Jane Doe',
        email: 'jane@example.com',
      );

      // Assert
      expect(profile1, equals(profile2));
      expect(profile1, isNot(equals(profile3)));
    });
  });
}
