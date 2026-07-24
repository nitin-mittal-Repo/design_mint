
class AppAssets {


  static const String _iconBasePath = "assets/icon/";
  static const String _imagesBasePath = "assets/images/";

  static String _iconPath(String fileName) => _iconBasePath + fileName;
  static String _imagesPath(String fileName) => _imagesBasePath + fileName;



  // TODO :: Icons
  static final iconGoogle = _iconPath("google.svg");
  static final iconInfo = _iconPath("info_icon.svg");



  // TODO :: Image
  static final imgLogo = _imagesPath("app_logo.png");

}

