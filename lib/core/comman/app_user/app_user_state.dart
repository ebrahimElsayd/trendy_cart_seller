// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../entitys/user_model.dart';

enum AppUserStates {
  initial,
  loading,
  success,
  faliureGetData,
  saveDataInLocalStorage,
  gettedDataFromLocalStorage,
  saveUserDataInSupabase,
  failureSaveUserDataInSupabase,
  failure,
  updateUserPhoneNumberInSupabase,
  updateUserPhoneNumberInLocalStorage,
  notLoggedIn,
  loggedIn,
  signOut,
  installed,
  notInstalled,
  gettedData,
  failureSaveData,
  clearUserData,
}

extension AppUserStateX on AppUserRiverpodState {
  bool isInitial() => state == AppUserStates.initial;

  bool isLoading() => state == AppUserStates.loading;

  bool isSuccess() => state == AppUserStates.success;

  bool isError() => state == AppUserStates.failure;

  bool isLoggedIn() => state == AppUserStates.loggedIn;

  bool isNotLoggedIn() => state == AppUserStates.notLoggedIn;

  bool isSignOut() => state == AppUserStates.signOut;

  bool isInstalled() => state == AppUserStates.installed;

  bool isNotInstalled() => state == AppUserStates.notInstalled;

  bool isGettedData() => state == AppUserStates.gettedData;

  bool isFailureSaveData() => state == AppUserStates.failureSaveData;

  bool isClearUserData() => state == AppUserStates.clearUserData;

  bool isFailureGetData() => state == AppUserStates.faliureGetData;

  bool isUpdateUserPhoneNumberInSupabase() =>
      state == AppUserStates.updateUserPhoneNumberInSupabase;

  bool isUpdateUserPhoneNumberInLocalStorage() =>
      state == AppUserStates.updateUserPhoneNumberInLocalStorage;

  bool isGettedDataFromLocalStorage() =>
      state == AppUserStates.gettedDataFromLocalStorage;

  bool isSaveUserDataInSupabase() =>
      state == AppUserStates.saveUserDataInSupabase;

  bool isFailureSaveUserDataInSupabase() =>
      state == AppUserStates.failureSaveUserDataInSupabase;

  bool isSaveDataInLocalStorage() =>
      state == AppUserStates.saveDataInLocalStorage;
}

class AppUserRiverpodState {
  final AppUserStates state;
  final UserModel? user;
  final String? userInitialRoute;
  final String? errorMessage;

  AppUserRiverpodState({
    required this.state,
    this.user,
    this.userInitialRoute,
    this.errorMessage,
  });

  factory AppUserRiverpodState.initial() {
    return AppUserRiverpodState(state: AppUserStates.initial);
  }

  AppUserRiverpodState copyWith({
    AppUserStates? state,
    UserModel? user,
    String? errorMessage,
    String? userInitialRoute,
  }) {
    return AppUserRiverpodState(
      state: state ?? this.state,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      userInitialRoute: userInitialRoute ?? this.userInitialRoute,
    );
  }

  @override
  String toString() =>
      'AppUserRiverpodState(state: $state, user: $user, errorMessage: $errorMessage)';

  @override
  bool operator ==(covariant AppUserRiverpodState other) {
    if (identical(this, other)) return true;

    return other.state == state &&
        other.user == user &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => state.hashCode ^ user.hashCode ^ errorMessage.hashCode;
}
