import 'package:Cliamizer/base/presenter/base_presenter.dart';
import '../../CommonUtils/preference/Prefs.dart';
import '../../generated/l10n.dart';
import 'MainScreen.dart';

class MainPresenter extends BasePresenter<MainScreenState> {
  Future<bool> getLoginStatus() async {
    final bool value = await Prefs.isLogin;
    view.pr.isUserLoggedIn = value;
    print('login status: $value');
    return value;
  }


  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      view.showToasts(S.of(view.context)!.backAgainToCloseApp, 'status');
      return Future.value(false);
    }
    return Future.value(true);
  }
}
