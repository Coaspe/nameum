import 'package:firebase_custom/firebase_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nameum/custom_toast/bloc/toast_alarm_bloc.dart';
import 'package:nameum_types/nameum_types.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  State<SignupPage> createState() => _AndroidLoginPageState();
}

class _AndroidLoginPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passworodController = TextEditingController();
  bool _enableObscure = true;
  String? _errorTextEmail;
  String? _errorTextPassword;
  String? _checkEmail(String str) {
    RegExp reg = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    String? ret;
    if (!reg.hasMatch(str)) {
      ret = "이메일 형식으로 입력해주세요";
    }
    setState(() {
      _errorTextEmail = ret;
    });
    return ret;
  }

  String? _checkPassword(String str) {
    RegExp reg = RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]');
    String? ret;
    if (str.length < 8) {
      ret = "8자 이상으로 설정해야합니다";
    } else if (!reg.hasMatch(str)) {
      ret = "특수문자가 1개 이상 포함해야합니다";
    }
    setState(() {
      _errorTextPassword = ret;
      print(ret);
    });
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // actions: [],
          ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300, maxHeight: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Image.asset('images/NamEum-logos_transparent.png'),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    // Email text field
                    TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 50,
                        onChanged: (value) {
                          if (value.isEmpty || value.length == 1) {
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                            suffixIcon: _emailController.text.isNotEmpty
                                ? GestureDetector(
                                    onTap: (() => setState(() {
                                          _emailController.text = "";
                                        })),
                                    child: const Icon(Icons.cancel))
                                : null,
                            errorText: _errorTextEmail,
                            hintText: "이메일",
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ))),
                    const SizedBox(
                      height: 20,
                    ),
                    // Password text field
                    TextField(
                        onChanged: ((value) {
                          if (value.isEmpty || value.length == 1) {
                            setState(() {});
                          }
                        }),
                        obscureText: _enableObscure,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: _passworodController,
                        maxLength: 20,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            errorText: _errorTextPassword,
                            suffixIcon: _passworodController.text.isNotEmpty
                                ? GestureDetector(
                                    onTap: (() => setState(() {
                                          _enableObscure = !_enableObscure;
                                        })),
                                    child: const Icon(
                                        Icons.remove_red_eye_outlined))
                                : null,
                            helperText: "8자 이상, 특수문자 한 개 이상 포함",
                            hintText: "패스워드",
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ))),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    String? checkE = _checkEmail(_emailController.text);
                    String? checkP = _checkPassword(_passworodController.text);

                    if (checkE == null && checkP == null) {
                      try {
                        await FireStoreMethods.signUpWithoutFirebase(
                                _emailController.text,
                                _emailController.text.split('@')[0],
                                _passworodController.text)
                            .then((_) => Navigator.of(context).pop([
                                  _emailController.text,
                                  _passworodController.text
                                ]));
                      } on DuplicatedEmail catch (e) {
                        setState(() {
                          _errorTextEmail = e.message!;
                        });
                        BlocProvider.of<ToastAlarmBloc>(context).add(
                            ToastAlarmAdded(WarningToast(message: e.message!)));
                      } catch (e) {}
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(width: 1, color: Colors.black)),
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    "확인",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "GowunBatang",
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
