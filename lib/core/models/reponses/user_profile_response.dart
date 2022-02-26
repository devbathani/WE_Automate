import 'package:antonx_flutter_template/core/models/other_models/user_profile.dart';
import 'package:antonx_flutter_template/core/models/reponses/base_responses/base_response.dart';

class UserProfileResponse extends BaseResponse {
  UserProfile? profile;

  UserProfileResponse(success, {error}) : super(success, error: error);

  UserProfileResponse.fromJson(json) : super.fromJson(json) {
    if (json['body'] != null)
      this.profile = UserProfile.fromJson(json['body']['user']);
  }
}
