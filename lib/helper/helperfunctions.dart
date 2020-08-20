import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = 'ISLOGGEDIN';
  static String sharedPreferenceUserNameKey = 'USERNAMEKEY';
  static String sharedPreferenceUserEmailKey = 'USEREMAILKEY';

  //saving data to shared preference
  static Future<bool> saveUserLoggedinSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String username) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(sharedPreferenceUserNameKey, username);
  }

  static Future<bool> saveEmailSharedPreference(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(sharedPreferenceUserEmailKey, email);
  }

  //Getting the Data
  static Future<bool> getUserLoggedinSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserNameSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getEmailSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getString(sharedPreferenceUserEmailKey);
  }
}
