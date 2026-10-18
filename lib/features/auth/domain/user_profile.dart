class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String phoneNumber;
  final String defaultAddress;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.phoneNumber,
    required this.defaultAddress,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    String? defaultAddress,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      defaultAddress: defaultAddress ?? this.defaultAddress,
    );
  }
}

