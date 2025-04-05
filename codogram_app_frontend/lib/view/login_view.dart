import 'package:flutter/material.dart';
import 'package:codogram_app_frontend/utils/routes/routes_name.dart';
import 'package:codogram_app_frontend/utils/utils.dart';
import 'package:codogram_app_frontend/view_model/auth_view_model.dart';

import '../res/components/round_button.dart';
import 'package:provider/provider.dart';

import '../view_model/user_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  ValueNotifier<bool> _obsecurePassword = ValueNotifier<bool>(true);
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    _obsecurePassword.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(

        body: Stack(

          children:[
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover, // Adjust to fill the screen
              ),
            ),
            SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Login',style: TextStyle(fontSize: 30,color: Colors.white),),
                SizedBox(height: 25,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    focusNode: emailFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(
                        color: Colors.black45,
                        fontSize: 18,
                      ),
                      prefixIcon: const Icon(Icons.alternate_email,),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: const Color(0xFFedf0f8),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2,color: Colors.brown),
                          borderRadius: BorderRadius.circular(30)),
                      // labelText: 'Email',

                    ),

                    onFieldSubmitted: (value){
                      Utils.fieldFocusChange(context, emailFocusNode, passwordFocusNode);
                    },
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: _obsecurePassword,
                    builder: (context , value ,child){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obsecurePassword.value,
                          obscuringCharacter: '*',
                          focusNode: passwordFocusNode,
                          decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: const Color(0xFFedf0f8),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(30)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 2,color: Colors.brown),
                                  borderRadius: BorderRadius.circular(30)),
                              // labelText: 'Password',
                              suffixIcon: InkWell(
                                  onTap: (){
                                    _obsecurePassword.value = !_obsecurePassword.value;
                                  },
                                  child: Icon(
                                      _obsecurePassword.value ? Icons.visibility_off_outlined:
                                      Icons.visibility
                                  ))
                          ),

                        ),
                      );
                    }
                ),
                SizedBox(height: height* .05,),
                RoundButton(
                    title: 'Login',
                    loading: authViewModel.loading,
                    onPress: () {
                      if(_emailController.text.isEmpty){
                        Utils.snackBar('Please enter email', context);
                      }else if(_passwordController.text.isEmpty){
                        Utils.flushBarErrorMessage('Please enter password', context);
                      }else if(_passwordController.text.length<6){
                        Utils.flushBarErrorMessage('Password must be at least 6 characters', context);
                      }else{
                        Map<String, dynamic> data = {
                          'email': _emailController.text.trim(),
                          'password': _passwordController.text.trim(),
                        };
                        // Map data = {
                        //   'email':'eve.holt@reqres.in',
                        //   'password':'cityslicka',
                        // };
                        authViewModel.loginApi(data , context);


                        print('api hit');

                      }
                    }
                ),
                SizedBox(height: height*0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",style: TextStyle(color: Colors.white),),
                    const SizedBox(width: 5,),
                    InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, RoutesName.signUp);
                        },
                        child: const Text("Sign Up",style: TextStyle(color: Colors.red),)),
                  ],
                )
              ],
            ),
          ),
    ]
        )
    );
  }
}
