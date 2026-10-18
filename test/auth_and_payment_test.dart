import 'package:batik_ngentrong/features/auth/domain/user_profile.dart';
import 'package:batik_ngentrong/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthNotifier Unit Test', () {
    test('Kondisi awal belum terautentikasi', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final auth = container.read(authNotifierProvider);
      expect(auth.isAuthenticated, isFalse);
      expect(auth.currentUser, isNull);
    });

    test('signInWithGoogle mengubah state menjadi terautentikasi', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.signInWithGoogle();

      final auth = container.read(authNotifierProvider);
      expect(auth.isAuthenticated, isTrue);
      expect(auth.currentUser, isNotNull);
      expect(auth.currentUser?.email, contains('@gmail.com'));
    });

    test('signOut mengembalikan state menjadi false', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.signInWithGoogle();
      expect(container.read(authNotifierProvider).isAuthenticated, isTrue);

      notifier.signOut();
      final auth = container.read(authNotifierProvider);
      expect(auth.isAuthenticated, isFalse);
      expect(auth.currentUser, isNull);
    });

    test('signInWithGoogle dengan custom user profile', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(authNotifierProvider.notifier);
      const custom = UserProfile(
        id: 'test_id',
        name: 'Tester Ngentrong',
        email: 'tester@gmail.com',
        phoneNumber: '0812345678',
        defaultAddress: 'Desa Ngentrong',
      );

      await notifier.signInWithGoogle(custom);
      final auth = container.read(authNotifierProvider);
      expect(auth.currentUser?.name, 'Tester Ngentrong');
      expect(auth.currentUser?.email, 'tester@gmail.com');
    });
  });
}

