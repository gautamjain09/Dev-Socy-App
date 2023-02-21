class UserModel {
  final String name;
  final String profilepic;
  final String banner;
  final String uid;
  final bool isGuest;
  final int karma;
  final List<String> awards;
  UserModel({
    required this.name,
    required this.profilepic,
    required this.banner,
    required this.uid,
    required this.isGuest,
    required this.karma,
    required this.awards,
  });

  // To change any data in UserModel.copyWith UserModel.name Not allowed
  UserModel copyWith({
    String? name,
    String? profilepic,
    String? banner,
    String? uid,
    bool? isGuest,
    int? karma,
    List<String>? awards,
  }) {
    return UserModel(
      name: name ?? this.name,
      profilepic: profilepic ?? this.profilepic,
      banner: banner ?? this.banner,
      uid: uid ?? this.uid,
      isGuest: isGuest ?? this.isGuest,
      karma: karma ?? this.karma,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilepic': profilepic,
      'banner': banner,
      'uid': uid,
      'isGuest': isGuest,
      'karma': karma,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      profilepic: map['profilepic'] as String,
      banner: map['banner'] as String,
      uid: map['uid'] as String,
      isGuest: map['isGuest'] as bool,
      karma: map['karma'] as int,
      awards: List<String>.from(
        (map['awards'] as List<String>),
      ),
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, profilepic: $profilepic, banner: $banner, uid: $uid, isGuest: $isGuest, karma: $karma, awards: $awards,)';
  }
}
