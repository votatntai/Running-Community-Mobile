import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:running_community_mobile/utils/get_it.dart';

import '../../domain/repositories/user_repo.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState>{
  UserCubit() : super(UserState());
  final UserRepo _userRepo = getIt.get<UserRepo>();
  Future<void> login({required String username, required String password}) async {
    emit(LoginLoadingState());
    try {
      await _userRepo.login(username: username, password: password);
      emit(LoginSuccessState());
    } catch (e) {
      emit(LoginFailedState(e.toString()));
    }
  }

  Future<void> getUserProfile() async {
    emit(UserProfileLoadingState());
    try {
      final user = await _userRepo.getUserProfile();
      emit(UserProfileSuccessState(user));
    } catch (e) {
      emit(UserProfileFailedState(e.toString()));
    }
  }

  Future<void> signUp({required String name, required String phone, required String password}) async {
    emit(SignUpLoadingState());
    try {
      await _userRepo.signUp(name: name, phone: phone, password: password);
      emit(SignUpSuccessState());
    } catch (e) {
      emit(SignUpFailedState(e.toString()));
    }
  }
}