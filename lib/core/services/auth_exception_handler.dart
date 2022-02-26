/// A [FirebaseAuthException] maybe thrown with the following error code:
/// - **invalid-email**:
///  - Thrown if the email address is not valid.
/// - **user-disabled**:
///  - Thrown if the user corresponding to the given email has been disabled.
/// - **user-not-found**:
///  - Thrown if there is no user corresponding to the given email.
/// - **wrong-password**:
///  - Thrown if the password is invalid for the given email, or the account
///    corresponding to the email does not have a password set.
class AuthExceptionHandler {
  static generateExceptionMessage(e) {
    print(e.code);
    String errorMessage;
    switch (e.code) {
      case "invalid-email":
        errorMessage = "Your email address appears to be invalid/malformed.";
        break;
      case "wrong-password":
        errorMessage = "Your password is wrong.";
        break;
      case "user-disabled":
        errorMessage = "User with this email has been disable.";
        break;
      case "user-not-found":
        errorMessage = "User with this email not found";
        break;
      // case "ERROR_TOO_MANY_REQUESTS":
      //   errorMessage = "Too many requests. Try again later.";
      //   break;
      // case "ERROR_OPERATION_NOT_ALLOWED":
      //   errorMessage = "Signing in with Email and Password is not enabled.";
      //   break;
      // case "ERROR_EMAIL_ALREADY_IN_USE":
      //   errorMessage =
      //       "The email has already been registered. Please login or reset your password.";
      //   break;

      //Todo: Handle no internet exception as well.

      default:
        errorMessage = "An undefined Error happened.";
    }
    return errorMessage;
  }
}
