import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:codogram_app_frontend/utils/routes/routes_name.dart';
import 'package:codogram_app_frontend/view_model/auth_view_model.dart';
import '../res/components/round_button.dart';
import '../utils/utils.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  ValueNotifier<bool> _obsecurePassword = ValueNotifier<bool>(true);
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  final FocusNode fullnameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode bioFocusNode = FocusNode();
  final FocusNode skillsFocusNode = FocusNode();

  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAvatar() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }
  File? _coverImage;

  Future<void> _pickCoverImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }


  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _skillsController.dispose();

    fullnameFocusNode.dispose();
    emailFocusNode.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    bioFocusNode.dispose();
    skillsFocusNode.dispose();
    _obsecurePassword.dispose();

    super.dispose();
  }

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('SignUp',style: TextStyle(fontSize: 30,color: Colors.white),),
                  SizedBox(height: 25,),
                  GestureDetector(
                    onTap: _pickAvatar,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _avatarImage != null
                          ? FileImage(_avatarImage!)
                          : null,
                      child: _avatarImage == null
                          ? const Icon(Icons.camera_alt, size: 30)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _pickCoverImage,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        image: _coverImage != null
                            ? DecorationImage(
                          image: FileImage(_coverImage!),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: _coverImage == null
                          ? const Center(child: Icon(Icons.add_photo_alternate, size: 30))
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: TextFormField(
                      controller: _fullnameController,
                      focusNode: fullnameFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        labelText: 'Full Name',
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      focusNode: emailFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.alternate_email),
                        labelText: 'Email',
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: TextFormField(
                      controller: _usernameController,
                      focusNode: usernameFocusNode,
                      decoration:  InputDecoration(
                        hintText: 'Username',
                        labelText: 'Username',
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
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _obsecurePassword,
                    builder: (context, value, child) {
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
                            labelText: 'Password',
                            suffixIcon: InkWell(
                              onTap: () {
                                _obsecurePassword.value = !_obsecurePassword.value;
                              },
                              child: Icon(
                                _obsecurePassword.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: TextFormField(
                      controller: _bioController,
                      focusNode: bioFocusNode,
                      decoration:  InputDecoration(
                        hintText: 'Bio',
                        labelText: 'Bio',
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: TextFormField(
                      controller: _skillsController,
                      focusNode: skillsFocusNode,
                      decoration:  InputDecoration(
                        hintText: 'Skills',
                        labelText: 'Skills',
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
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.085),
                  RoundButton(
                    title: 'SignUp',
                    loading: authViewModel.signUpLoading,
                    onPress: () {
                      Map<String, dynamic> data = {
                        'fullname': _fullnameController.text.trim(),
                        'email': _emailController.text.trim(),
                        'username': _usernameController.text.trim(),
                        'password': _passwordController.text.trim(),
                        'bio': _bioController.text.trim(),
                        'skills': _skillsController.text
                            .split(',')
                            .map((skill) => skill.trim())
                            .toList(),
                        'avatar': _avatarImage?.path,
                        'coverImage': _coverImage?.path,
                      };
                      authViewModel.signUpApi(data, context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
    ]
      ),
    );
  }
}
