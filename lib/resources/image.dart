/// Sample PG accommodation images
const List<String> pgSampleImages = [
  "assets/images/Comfert.png",
  "assets/images/GreenVally.png",
  "assets/images/metro.png",
  "assets/images/royal.png",
  "assets/images/Shanti.png",
  "assets/images/Sunshine.png",
];

const String introBannerImage = "assets/images/intro.png";
const String appLogo = "assets/images/logo.png";

// Backward compatibility aliases
@Deprecated('Use pgSampleImages instead')
List<String> get i1 => List<String>.from(pgSampleImages);

@Deprecated('Use introBannerImage instead')
const String i2 = introBannerImage;
