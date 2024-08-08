import 'package:Cliamizer/base/provider/base_provider.dart';
import 'package:Cliamizer/network/models/emergency_model.dart';

class MoreProvider<T> extends BaseProvider<T> {
  bool _receiveNotification = true;

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

  String _language = '';
  String get language => _language;

  set language(String value) {
    _language = value;
    notifyListeners();
  }

  List<Company> _companies = [];
  String _company = '';
  String _availableFrom = '';
  String _availableTo = '';

  set companiesList(List<Company> list){
    _companies = list;
    notifyListeners();
  }

  set companyName(String value){
    _company = value;
    notifyListeners();
  }

  set availableFromDate(String value){
    _availableFrom = value;
    notifyListeners();
  }

  set availableToDate(String value){
    _availableTo = value;
    notifyListeners();
  }

  List<Company> get getCompanies => _companies;

  String get getCompany =>_company;

  String get getAvailableFrom =>_availableFrom;

  String get getAvailableTo =>_availableTo;
}
