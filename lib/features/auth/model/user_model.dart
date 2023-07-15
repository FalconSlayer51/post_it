import 'dart:convert';

class UserModel {
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;
  UserModel({
    required this.uid,
    required this.displayName,
    required this.photoUrl,
    required this.email,
  });
  

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? photoUrl,
    String? email,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      displayName: map['displayName'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, displayName: $displayName, photoUrl: $photoUrl, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.uid == uid &&
      other.displayName == displayName &&
      other.photoUrl == photoUrl &&
      other.email == email;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      displayName.hashCode ^
      photoUrl.hashCode ^
      email.hashCode;
  }
}
