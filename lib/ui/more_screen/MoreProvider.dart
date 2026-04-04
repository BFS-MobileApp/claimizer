import 'package:Cliamizer/base/provider/base_provider.dart';
import 'package:Cliamizer/network/models/emergency_model.dart';

import 'MorePresenter.dart';

class MoreProvider<T> extends BaseProvider<T> {
  MoreProvider(){
    print("MoreProvider CREATED");
  }
  bool _receiveNotification = true;
  bool _isLoaded = false;
  bool get receiveNotification => _receiveNotification;

  set receiveNotification(bool value) {
    _receiveNotification = value;
    notifyListeners();
  }


  bool _isDateLoaded = false;
  bool _internetStatus = true;


  bool get internetStatus => _internetStatus;

  set internetStatus(bool value) {
    _internetStatus = value;
    notifyListeners();
  }

  bool get isDateLoaded => _isDateLoaded;

  set isDateLoaded(bool value) {
    _isDateLoaded = value;
    notifyListeners();
  }
  Future<void> loadProfile(MorePresenter presenter) async {
    if (_isLoaded) return;

    _isLoaded = true;
    await presenter.getProfileData();
  }

  String _language = '';
  String get language => _language;

  set language(String value) {
    _language = value;
    notifyListeners();
  }
}
