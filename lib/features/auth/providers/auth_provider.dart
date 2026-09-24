import 'package:flutter/material.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required this._repository}){
    _checkSavedUser();
  }

  final AuthRepository _repository;
  AuthState _state = AuthState.initial();

   AuthState get state => _state;
  Future<void> login(String email,String password) async{
    _state = _state.copyWith(status: AuthStatus.loading);
    notifyListeners();
    try{
      final user = await _repository.login(email, password);
      await _repository.saveUserLocally(user);
      _state = state.copyWith(status: AuthStatus.authenticated,user: user);
      
    }catch(e){
  _state = _state.copyWith(status: AuthStatus.error,errorMessage: e.toString());
    }
    notifyListeners();
  }

  Future<void> _checkSavedUser() async{
    final savedUser = await  _repository.getSavedUser();
    if(savedUser != null){
      _state = _state.copyWith(status: AuthStatus.authenticated,user: savedUser);
      notifyListeners();
    }
  }

  void logOut(){
    _state = const AuthState.initial();
    notifyListeners();
  }
}