import 'package:flutter/material.dart';

class Constants {
  // Assets
  static const logoPath = 'assets/images/logo.png';
  static const loginEmotePath = 'assets/images/loginEmote.png';
  static const googlePath = 'assets/images/google.png';

  // Defaults Avator/Banners
  static const bannerDefault =
      'https://www.redditinc.com/assets/images/blog/hangoutsscreen_1-1-1.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  // Icons
  static const IconData up = IconData(
    0xe800,
    fontFamily: 'MyFlutterApp',
    fontPackage: null,
  );
  static const IconData down = IconData(
    0xe801,
    fontFamily: 'MyFlutterApp',
    fontPackage: null,
  );

  // Awards Logo
  static const awardsPath = 'assets/images/awards';
  static const awards = {
    'awesomeAns': '${Constants.awardsPath}/awesomeanswer.png',
    'gold': '${Constants.awardsPath}/gold.png',
    'platinum': '${Constants.awardsPath}/platinum.png',
    'helpful': '${Constants.awardsPath}/helpful.png',
    'plusone': '${Constants.awardsPath}/plusone.png',
    'rocket': '${Constants.awardsPath}/rocket.png',
    'thankyou': '${Constants.awardsPath}/thankyou.png',
    'til': '${Constants.awardsPath}/til.png',
  };
}
