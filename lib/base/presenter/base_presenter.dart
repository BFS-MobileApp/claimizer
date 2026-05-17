import 'package:Cliamizer/CommonUtils/preference/Prefs.dart';
import 'package:Cliamizer/generated/l10n.dart';
import 'package:Cliamizer/network/exception/error_status.dart';
import 'package:Cliamizer/network/network_util.dart';
import 'package:Cliamizer/res/colors.dart';
import 'package:Cliamizer/ui/user/login_screen/LoginScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../CommonUtils/logmanager.dart';
import '../view/i_base_view.dart';
import 'i_presenter.dart';

class BasePresenter<V extends IBaseView> extends IPresenter {
  late V view;

  // Cancel network request
  late CancelToken _cancelToken;

  void attachView(V view) {
    this.view = view;
  }

  BasePresenter() {
    _cancelToken = CancelToken();
    LogoutManager.register(_cancelToken);
  }

  @override
  void deactivate() {}

  @override
  void didChangeDependencies() {}

  @override
  void didUpdateWidget<W>(W oldWidget) {}

  @override
  void dispose() {
    LogoutManager.unregister(_cancelToken);
    if (_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
  }

  @override
  void initState() {

  }

  Future<void> requestFutureData<T>(Method method,
      {String? endPoint,
        bool isShow = true,
        bool isClose = true,
        void Function(T t)? onSuccess,
        void Function(List<T> list)? onSuccessList,
        void Function(int code, dynamic msg)? onError,
        dynamic params,
        Map<String, dynamic>? queryParams,
        CancelToken? cancelToken,
        Options? options,
        bool isList = false}) async {
    await DioUtils.instance.requestDataFuture<T>(method, endPoint!,
        params: params,
        queryParameters: queryParams ?? {},
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
        onSuccess: (data) {
          if (_cancelToken.isCancelled) return;
          try {
            if (!view.mounted) return;
            if (onSuccess != null) onSuccess(data);
          } catch (_) {
            return;
          }
        }, onSuccessList: (data) {
          if (_cancelToken.isCancelled) return;
          final element = view.getContext() as Element;
          if (!element.mounted) return;
          if (isClose) // view.closeProgress();
            if (onSuccessList != null) onSuccessList(data);
        }, onError: (code, msg) {
          if (code == 1005 || _cancelToken.isCancelled) {
            view.closeProgress();
            return;
          }
          try {
            if (!view.mounted) return;
            if (isClose) _onError(code, msg, onError);
          } catch (_) {
            return;
          }
          if (isClose) // view.closeProgress();
            _onError(code, msg, onError);
          if (code == ErrorStatus.FORBIDDEN) {
            Prefs.clearExpectLanguage();
            Navigator.pushReplacement(
                view.getContext(),
                MaterialPageRoute(
                    builder: (context) => LoginScreen()));
          } else if (code == ErrorStatus.UNKNOWN_ERROR ||
              code == ErrorStatus.TIMEOUT_ERROR ||
              code == ErrorStatus.NETWORK_ERROR) {
            final context = view.getContext();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 3),
                content: Text("${S.of(context)!.checkYourInternet}"),
                backgroundColor: MColors.error_color));
          } else if (code == ErrorStatus.SERVER_ERROR) {
            final context = view.getContext();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 3),
                content: Text(S.of(context)!.anErrorOccurredTryAgainLater),
                backgroundColor: MColors.error_color));
          } else if (code == ErrorStatus.UNAUTHORIZED) {
            final context = view.getContext();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 3),
                content: Text(S.of(context)!.sessionTimeoutPleaseLogin),
                backgroundColor: MColors.error_color));
            // showDialog(context: context, builder: (context) => LoginRequiredDialog(message:S.of(context).sessionTimeoutPleaseLogin));
          }
        });
  }

  void cancelRequests() {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel('User logged out');
    }
  }


  void requestDataFromNetwork<T>(Method method,
      {String? url,
        bool isShow = true,
        bool isClose = true,
        void Function(T t)? onSuccess,
        void Function(List<T> list)? onSuccessList,
        void Function(int code, dynamic msg)? onError,
        dynamic params,
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
        required Options options,
        bool isList = false}) {
    // Display loading circle
    DioUtils.instance.requestData<T>(method, url!,
        params: params,
        queryParameters: queryParameters ?? {},
        cancelToken: cancelToken ?? _cancelToken,
        options: options,
        isList: isList, onSuccess: (data) {
          // Request data successfully
          // view.closeProgress();
          if (onSuccess != null) {
            onSuccess(data);
          }

          // Request list successful
        }, onSuccessList: (data) {
          if (isClose) // view.closeProgress();
            if (onSuccessList != null) {
              onSuccessList(data);
            }

          /// Request error
        }, onError: (code, msg) {
          if (isClose) // view.closeProgress();
            _onError(code, msg, onError);
        });
  }

  void _onError(
      int code, dynamic msg, void Function(int code, dynamic msg)? onError) {
    // view.closeProgress();
    // Prevent using context after widget disposed
    final context = view.getContext();
    if (context == null || !(context as Element).mounted) return;

    if (onError != null) {
      onError(code, msg);
    }
    if (code == ErrorStatus.FORBIDDEN) {
      Prefs.clearExpectLanguage();
      Navigator.pushReplacement(
          view.getContext(),
          MaterialPageRoute(
              builder: (context) =>  LoginScreen()));
    } else if (code == ErrorStatus.UNKNOWN_ERROR ||
        code == ErrorStatus.TIMEOUT_ERROR ||
        code == ErrorStatus.NETWORK_ERROR) {
      final context = view.getContext();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 3),
          content: Text("${S.of(context)!.checkYourInternet}"),
          backgroundColor: MColors.error_color));
    } else if (code == ErrorStatus.SERVER_ERROR) {
      final context = view.getContext();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(S.of(context)!.anErrorOccurredTryAgainLater),
          backgroundColor: MColors.error_color));
    } else if (code == ErrorStatus.UNAUTHORIZED) {
      final context = view.getContext();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(S.of(context)!.sessionTimeoutPleaseLogin),
          backgroundColor: MColors.error_color));
      // showDialog(context: context, builder: (context) => LoginRequiredDialog(message:S.of(context).sessionTimeoutPleaseLogin));
    }
  }
}
