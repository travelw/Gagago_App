class LangStrings {
  static final LangStrings _langString = LangStrings._internal();

  factory LangStrings() {
    return _langString;
  }

  LangStrings._internal();

  static const String strWelcome = "str_welcome";
  static const String strRememberMe = "str_remember_me";
  static const String strWhenYouSelectCommonDandI = "str_when_you_select_common_d_and_i";
  static const String strForgotPassword = "str_forgot_password";
  static const String strLogin = "str_login";
  static const String strDontHaveAccount = "str_dont_have_account";
}
