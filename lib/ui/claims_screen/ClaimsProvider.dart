import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Cliamizer/network/models/UnitRequestResponse.dart';
import 'package:Cliamizer/network/models/buildings_response.dart';
import 'package:Cliamizer/network/models/categories_response.dart';
import 'package:Cliamizer/network/models/claim_available_time_response.dart';
import 'package:Cliamizer/network/models/claim_type_response.dart';
import 'package:Cliamizer/network/models/units_response.dart';
import '../../network/models/claims_response.dart';

class ClaimsProvider extends ChangeNotifier {
  int _selectedIndex = 1;
  DateTime? _selectedDate;
  TextEditingController _description = TextEditingController();
  int companyId = 0;
  String _selectedTimeValue = '';
  File _fileName = File('');
  int _currentStep = 0;
  bool _isStepsFinished = false;
  int _selectedBuildingIndex = 0;
  int _selectedUnitIndex = 0;
  int _selectedClaimCategoryIndex = 0;
  int _selectedClaimSubCategoryIndex = 0;
  int _selectedClaimTypeIndex = 0;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  TextEditingController _searchController = TextEditingController();
  String _searchValue = '';
  List<UnitRequestDataBean> _unitsRequestList = [];
  List<ClaimsDataBean> _claimsList = [];
  List<BuildingsDataBean> _buildingsList = [];
  List<UnitsDataBean> _unitsList = [];
  List<CategoryDataBean> _categoriesList = [];
  List<SubCategoryDataBean> _subCategoryList = [];
  List<ClaimTypeDataBean> _claimTypeList = [];
  List<ClaimAvailableTimeDataBean> _claimAvailableTimeList = [];
  File _file = File('');
  List<XFile> _imageFiles = [];
  bool _dataLoaded = false;
  String homeFilter = '';
  String selectedBuilding = '';
  String selectedUnit = '';
  String selectedCategory = '';
  String selectedSubCategory = '';
  String selectedType = '';

  // Getters and setters...

  bool get isStepsFinished => _isStepsFinished;

  set isStepsFinished(bool value) {
    _isStepsFinished = value;
    notifyListeners();
  }

  double get scrollPosition => _scrollPosition;

  set scrollPosition(double value) {
    _scrollPosition = value;
    notifyListeners();
  }

  ScrollController get scrollController => _scrollController;

  set scrollController(ScrollController value) {
    _scrollController = value;
    notifyListeners();
  }

  DateTime get selectedDate {
    return _selectedDate ?? DateTime.now();
  }

  set selectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  TextEditingController get searchController => _searchController;

  set searchController(TextEditingController value) {
    _searchController = value;
    notifyListeners();
  }

  String get searchValue => _searchValue;

  set searchValue(String value) {
    _searchValue = value;
    notifyListeners();
  }

  List<UnitRequestDataBean> get unitsRequestList => _unitsRequestList;

  set unitsRequestList(List<UnitRequestDataBean> value) {
    _unitsRequestList = value;
    notifyListeners();
  }

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;

  int get currentStep => _currentStep;

  set currentStep(int value) {
    _currentStep = value;
    notifyListeners();
  }

  int get selectedBuildingIndex => _selectedBuildingIndex;

  set selectedBuildingIndex(int value) {
    _selectedBuildingIndex = value;
    notifyListeners();
  }

  int get selectedUnitIndex => _selectedUnitIndex;

  set selectedUnitIndex(int value) {
    _selectedUnitIndex = value;
    notifyListeners();
  }

  List<ClaimsDataBean> get claimsList => _claimsList;

  set claimsList(List<ClaimsDataBean> value) {
    _claimsList = value;
    notifyListeners();
  }

  List<BuildingsDataBean> get buildingsList => _buildingsList;

  set buildingsList(List<BuildingsDataBean> value) {
    _buildingsList = value;
    notifyListeners();
  }

  List<UnitsDataBean> get unitsList => _unitsList;

  set unitsList(List<UnitsDataBean> value) {
    _unitsList = value;
    notifyListeners();
  }

  void clearUnitsList() {
    _unitsList.clear();
    notifyListeners();
  }

  List<CategoryDataBean> get categoriesList => _categoriesList;

  set categoriesList(List<CategoryDataBean> value) {
    _categoriesList = value;
    notifyListeners();
  }

  void clearCategoryList() {
    _categoriesList.clear();
    notifyListeners();
  }

  List<SubCategoryDataBean> get subCategoryList => _subCategoryList;

  set subCategoryList(List<SubCategoryDataBean> value) {
    _subCategoryList = value;
    notifyListeners();
  }

  void clearSubCategoryList() {
    _subCategoryList.clear();
    notifyListeners();
  }

  List<ClaimTypeDataBean> get claimTypeList => _claimTypeList;

  set claimTypeList(List<ClaimTypeDataBean> value) {
    _claimTypeList = value;
    notifyListeners();
  }

  void clearTypeList() {
    _claimTypeList.clear();
    notifyListeners();
  }

  List<ClaimAvailableTimeDataBean> get claimAvailableTimeList => _claimAvailableTimeList;

  set claimAvailableTimeList(List<ClaimAvailableTimeDataBean> value) {
    _claimAvailableTimeList = value;
    notifyListeners();
  }

  int get selectedClaimCategoryIndex => _selectedClaimCategoryIndex;

  set selectedClaimCategoryIndex(int value) {
    _selectedClaimCategoryIndex = value;
    notifyListeners();
  }

  int get selectedClaimTypeIndex => _selectedClaimTypeIndex;

  set selectedClaimTypeIndex(int value) {
    _selectedClaimTypeIndex = value;
    notifyListeners();
  }

  int get selectedClaimSubCategoryIndex => _selectedClaimSubCategoryIndex;

  set selectedClaimSubCategoryIndex(int value) {
    _selectedClaimSubCategoryIndex = value;
    notifyListeners();
  }

  String get selectedTimeValue => _selectedTimeValue;

  set selectedTimeValue(String value) {
    _selectedTimeValue = value;
    notifyListeners();
  }

  TextEditingController get description => _description;

  set description(TextEditingController value) {
    _description = value;
    notifyListeners();
  }

  File get fileName => _fileName;

  void updateFileName(File newFile) {
    _fileName = newFile;
    notifyListeners();
  }

  File get file => _file;

  set file(File value) {
    _file = value;
    notifyListeners();
  }

  List<XFile> get imageFiles => _imageFiles;

  set imageFiles(List<XFile> value) {
    _imageFiles = value;
    notifyListeners();
  }

  bool get dataLoaded => _dataLoaded;

  set dataLoaded(bool value) {
    _dataLoaded = value;
    notifyListeners();
  }

  // Reset method to clear the state of the provider
  void reset() {
    _selectedIndex = 1;
    _selectedDate = null;
    _description.clear();
    companyId = 0;
    _selectedTimeValue = '';
    _fileName = File('');
    _currentStep = 0;
    _isStepsFinished = false;
    _selectedBuildingIndex = 0;
    _selectedUnitIndex = 0;
    _selectedClaimCategoryIndex = 0;
    _selectedClaimSubCategoryIndex = 0;
    _selectedClaimTypeIndex = 0;
    _scrollController = ScrollController();
    _scrollPosition = 0.0;
    _searchController.clear();
    _searchValue = '';
    _unitsRequestList.clear();
    _claimsList.clear();
    _buildingsList.clear();
    _unitsList.clear();
    _categoriesList.clear();
    _subCategoryList.clear();
    _claimTypeList.clear();
    _claimAvailableTimeList.clear();
    _file = File('');
    _imageFiles.clear();
    _dataLoaded = false;
    homeFilter = '';
    selectedBuilding = '';
    selectedUnit = '';
    selectedCategory = '';
    selectedSubCategory = '';
    selectedType = '';
    notifyListeners();
  }
}
