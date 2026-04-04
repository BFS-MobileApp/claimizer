import 'package:Cliamizer/base/presenter/base_presenter.dart';
import 'package:Cliamizer/ui/user/forgot_password_screen/ForgotPasswordScreen.dart';

import '../../../app_widgets/success_bottom_sheet.dart';
import '../../../network/api/network_api.dart';
import '../../../network/network_util.dart';
import 'ResetPasswordResponse.dart';

class ForgotPasswordPresenter
    extends BasePresenter<ForgotPasswordScreenState> {

  Future resetPasswordApiCall(Map<String, dynamic> bodyParams) async {
    view.showProgress(isDismiss: false);

    await requestFutureData<ResetPasswordResponse>(
      Method.post,
      endPoint: Api.resetPasswordApiCall,
      params: bodyParams,
      onSuccess: (data) {
        view.closeProgress();
        // Show success bottom sheet instead of toast
        SuccessBottomSheet.show(
          view.context,
          message: "We have e-mailed your\npassword reset link!",
          buttonText: "Done",
          onDone: () {
            // Optional: navigate back or to login after Done is tapped
            // Navigator.of(view.context).pop();
          },
        );
      },
      onError: (code, msg) {
        view.closeProgress();
        view.showToasts(msg ?? "Something went wrong", "Error");
      },
    );
  }
}