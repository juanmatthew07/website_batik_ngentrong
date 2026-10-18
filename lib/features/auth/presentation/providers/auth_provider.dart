import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/user_profile.dart';

class AuthState {
  final bool isAuthenticated;
  final UserProfile? currentUser;
  final bool isLoading;

  const AuthState({
    this.isAuthenticated = false,
    this.currentUser,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserProfile? currentUser,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  static const List<UserProfile> availableMockUsers = [
    UserProfile(
      id: 'usr_google_01',
      name: 'Budi Santoso',
      email: 'budi.santoso@gmail.com',
      phoneNumber: '0812-3456-7890',
      defaultAddress:
          'Jl. Pemuda No. 45, RT 03 RW 01, Kel. Ngantru, Kec. Trenggalek, Kab. Trenggalek, Jawa Timur 66311',
    ),
    UserProfile(
      id: 'usr_google_02',
      name: 'Siti Rahmawati',
      email: 'siti.rahmawati@gmail.com',
      phoneNumber: '0857-9876-5432',
      defaultAddress:
          'Dusun Krajan RT 02 RW 01, Desa Ngentrong, Kec. Karangan, Kab. Trenggalek, Jawa Timur 66361',
    ),
  ];

  Future<void> signInWithGoogle([UserProfile? user]) async {
    state = state.copyWith(isLoading: true);
    // Simulasi delay autentikasi Google ~500ms
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final selectedUser = user ?? availableMockUsers.first;
    state = AuthState(
      isAuthenticated: true,
      currentUser: selectedUser,
      isLoading: false,
    );
  }

  void signOut() {
    state = const AuthState(
      isAuthenticated: false,
      currentUser: null,
      isLoading: false,
    );
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

