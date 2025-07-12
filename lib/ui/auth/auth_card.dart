import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/http_exception.dart';
import '../../ui/shared/dialog_utils.dart';
import 'auth_manager.dart';

enum AuthMode { signup, login }

class AuthCard extends StatefulWidget {
  const AuthCard({
    super.key,
  });

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final _isSubmitting = ValueNotifier<bool>(false);
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _isSubmitting.value = true;

    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await context.read<AuthManager>().login(
              _authData['email']!,
              _authData['password']!,
            );
      } else {
        // Sign user up
        await context.read<AuthManager>().signup(
              _authData['email']!,
              _authData['password']!,
            );
      }
    } catch (error) {
      if (context.mounted) {
        showErrorDialog(
            context,
            (error is HttpException)
                ? error.toString()
                : 'Authentication failed');
      }
    }

    _isSubmitting.value = false;
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.sizeOf(context);
    return Container(
        height: _authMode == AuthMode.signup ? 420 : 360,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.signup ? 320 : 260),
        width: deviceSize.width * 0.93,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildEmailField(),
                SizedBox(height: 8,),
                _buildPasswordField(),
                 SizedBox(height: 8,),
                if (_authMode == AuthMode.signup) _buildPasswordConfirmField(),
                const SizedBox(
                  height: 20,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _isSubmitting,
                  builder: (context, isSubmitting, child) {
                    if (isSubmitting) {
                      return const CircularProgressIndicator();
                    }
                    return _buildSubmitButton();
                  },
                ),
                SizedBox(height: 8,),
                _buildAuthModeSwitchButton(),
              ],
            ),
          ),
        ),
      );
    
  }

  Widget _buildAuthModeSwitchButton() {
    return Padding(
      padding: EdgeInsets.only(left: 60, right: 60),
      child: ElevatedButton(
        onPressed: _switchAuthMode,
        
        child: SizedBox(
          width: double.infinity,
          child: Text(
            _authMode == AuthMode.login ? 'Đăng ký' : 'Đăng nhập',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          )
          ),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: Color.fromARGB(106, 228, 226, 226),
          onPrimary: Color.fromARGB(255, 0, 0, 0),
          padding: const EdgeInsets.symmetric(vertical: 12)
        ) , 
      ),
    );
  }

  Widget _buildSubmitButton() {

    return ElevatedButton(
      onPressed: _submit,
      
      child: SizedBox(
        width: double.infinity,
        child: Text(
          _authMode == AuthMode.login ? 'Đăng nhập' : 'Đăng ký',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        )
        ),
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        primary: Color.fromARGB(255, 228, 226, 226),
        onPrimary: Color.fromARGB(255, 0, 0, 0),
        padding: const EdgeInsets.symmetric(vertical: 16)
      ) , 
    );
  }

  Widget _buildPasswordConfirmField() {
     var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white)
    );
    return TextFormField(
      enabled: _authMode == AuthMode.signup,
      decoration: InputDecoration(
        hintText: "Xác nhận mật khẩu",
        hintStyle: const TextStyle(color: Color.fromARGB(140, 255, 255, 255)),
        enabledBorder: border,
        focusedBorder: border, 
      ),
      obscureText: true,
      validator: _authMode == AuthMode.signup
          ? (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match!';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildPasswordField() {
     var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white)
    );
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Nhập mật khẩu",
        hintStyle: const TextStyle(color: Color.fromARGB(140, 255, 255, 255)),
        enabledBorder: border,
        focusedBorder: border, 
      ),
      obscureText: true,
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.length < 5) {
          return 'Mật khẩu quá ngắn!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['password'] = value!;
      },
    );
  }

  Widget _buildEmailField() {
     var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white)
    );
    return TextFormField(
     style: TextStyle(color: Colors.white),
     decoration: InputDecoration(
        hintText: "Nhập Email",
        hintStyle: const TextStyle(color: Color.fromARGB(140, 255, 255, 255)),
        enabledBorder: border,
        focusedBorder: border, 
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Email không đúng định dạng!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['email'] = value!;
      },
    );
  }
}


