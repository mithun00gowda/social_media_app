import 'package:flutter/material.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository);

  final AuthRepository _repository;
  AuthState _state = AuthState.initial();

   AuthState get state => _state;
  Future<void> login(String email,String password) async{
    _state = _state.copyWith(status: AuthStatus.loading);
    notifyListeners();
    try{
      final user = await _repository.login(email, password);
      _state = state.copyWith(status: AuthStatus.authenticated,user: user);
    }catch(e){
  _state = _state.copyWith(status: AuthStatus.error,errorMessage: e.toString());
    }
    notifyListeners();
  }

  void logOut(){
    _state = const AuthState.initial();
    notifyListeners();
  }
}