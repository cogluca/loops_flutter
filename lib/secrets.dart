import 'dart:io' show Platform;


class Secret {


  //TODO Remove from upload somehow, same way that env files are used in other projects
  static const ANDROID_CLIENT_ID = "202855683655-k0hbv05446kuu98m347j6nseep75k0sj.apps.googleusercontent.com";
  static const IOS_CLIENT_ID = "202855683655-ht2ppl3t3oppieqgnmcvnfquaktigsg0.apps.googleusercontent.com";

  static String getId() => Platform.isAndroid ? ANDROID_CLIENT_ID : IOS_CLIENT_ID;


}