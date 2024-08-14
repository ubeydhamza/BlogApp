import 'package:bloc/bloc.dart';
import 'package:blog_app_project/core/usecase/usecase.dart';
import 'package:blog_app_project/features/auth/domain/entities/user.dart';
import 'package:blog_app_project/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app_project/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app_project/features/auth/domain/usecases/user_sign_up.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser curentUser,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _currentUser = curentUser,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        print(r.email);
        emit(AuthSuccess(r));
      },
    );
  }

  //Auth SignUP
  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) {
        emit(AuthSuccess(user));
      },
    );
  }

  //Auth SignIN
  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignIn(
      UserSignInParams(
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) {
        emit(AuthSuccess(user));
      },
    );
  }
}
