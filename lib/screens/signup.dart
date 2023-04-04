import 'package:ecocommit/functions/auth.dart';
import 'package:ecocommit/main.dart';
import 'package:ecocommit/utils/colors.dart';
import 'package:ecocommit/utils/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.9,
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Let’s create your \n',
                          style: GoogleFonts.poppins(
                            color: CustomColors.kDark,
                            fontSize: 25,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'account',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w900,
                                  color: CustomColors.kDark,
                                  fontSize: 25,
                                  height: 0.9),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 280,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextFeild(
                          type: TextInputType.name,
                          hintText: "Full Name",
                          controller: _nameController,
                          autofillHint: const [
                            AutofillHints.name,
                          ],
                        ),
                        CustomTextFeild(
                          type: TextInputType.number,
                          hintText: "Pin Code",
                          controller: _pinCodeController,
                          autofillHint: const [
                            AutofillHints.postalCode,
                          ],
                        ),
                        CustomTextFeild(
                          type: TextInputType.emailAddress,
                          hintText: "Email Address",
                          controller: _emailController,
                          autofillHint: const [
                            AutofillHints.email,
                          ],
                        ),
                        CustomTextFeild(
                          type: TextInputType.visiblePassword,
                          hintText: "Password",
                          controller: _passwordController,
                          autofillHint: const [
                            AutofillHints.password,
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.isEmpty ||
                            _pinCodeController.text.isEmpty ||
                            _emailController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Please fill all the fields"),
                            ),
                          );
                          return;
                        }

                        Auth().signUp(
                            _emailController.text, _passwordController.text, {
                          "name": _nameController.text,
                          "pinCode": _pinCodeController.text,
                          "email": _emailController.text,
                          "points": 0,
                        }).then((value) {
                          if (value['status'] == true) {
                            navigatorKey.currentState!.popUntil(
                              (route) => route.isFirst,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(value["message"]),
                              ),
                            );
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.kGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        "sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
