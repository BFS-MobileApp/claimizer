import 'dart:io';
import 'package:flutter/material.dart';

class RenewModel {
  TextEditingController _contractNo = TextEditingController();
  File _contractImage = File('');
  File _identifyImage = File('');
  TextEditingController _descriptionController = TextEditingController();
  String _startDate = '';
  String _endDate = '';

  // Getters
  TextEditingController get contractNo => _contractNo;
  File get contractImage => _contractImage;
  File get identifyImage => _identifyImage;
  TextEditingController get descriptionController => _descriptionController;
  String get startDate => _startDate;
  String get endDate => _endDate;
  String get getContractNumber => _contractNo.text;

  String get getDescription => _descriptionController.text;

  // Setters
  set contractNo(TextEditingController value) {
    _contractNo = value;
  }

  set setContractNumber(String value) {
    _contractNo.text = value;
  }

  set setContractImage(File value) {
    _contractImage = value;
  }

  set setIdentifyImage(File value) {
    _identifyImage = value;
  }

  set identifyImage(File value) {
    _identifyImage = value;
  }

  set descriptionController(TextEditingController value) {
    _descriptionController = value;
  }

  set startDate(String value) {
    _startDate = value;
  }

  set endDate(String value) {
    _endDate = value;
  }
}
