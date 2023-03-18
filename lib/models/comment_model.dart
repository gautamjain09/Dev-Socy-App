class CommentModel {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String username;
  final String uid;
  final String profilePic;
  CommentModel({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postId,
    required this.username,
    required this.uid,
    required this.profilePic,
  });

  CommentModel copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postId,
    String? username,
    String? uid,
    String? profilePic,
  }) {
    return CommentModel(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'username': username,
      'uid': uid,
      'profilePic': profilePic,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      postId: map['postId'] ?? '',
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }

  @override
  String toString() {
    return 'CommentModel(id: $id, text: $text, createdAt: $createdAt, postId: $postId, username: $username, uid: $uid, profilePic: $profilePic)';
  }
}
