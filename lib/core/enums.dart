enum ThemeMode {
  light,
  dark,
}

enum UserKarma {
  comment(1),
  postText(2),
  postLink(2),
  postImage(2),
  postAward(4),
  postDelete(-2);

  final int karma;
  const UserKarma(this.karma);
}
