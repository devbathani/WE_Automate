import 'package:antonx_flutter_template/core/models/reponses/base_responses/base_response.dart';

class ResetPasswordResponse extends BaseResponse {
  String? message;

  /// Default constructor
  ResetPasswordResponse(succes, {error, this.message})
      : super(succes, error: error);

  /// Named Constructor
  ResetPasswordResponse.fromJson(json) : super.fromJson(json) {
    if (json['body'] != null) this.message = json['body']['message'];
  }
}
