import 'package:ecocommit/functions/auth.dart';
import 'package:ecocommit/main.dart';
import 'package:ecocommit/utils/colors.dart';
import 'package:ecocommit/utils/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
                          text: "Let's create your \n",
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
                    height: 130,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextFeild(
                          type: TextInputType.emailAddress,
                          hintText: "Email Address",
                          controller: _emailController,
                          autofillHint: const [
                            AutofillHints.email,
                            AutofillHints.username,
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
                        Auth()
                            .signIn(
                              _emailController.text,
                              _passwordController.text,
                            )
                            .then(
                              (value) => {
                                if (value["status"] == true)
                                  {
                                    navigatorKey.currentState!.popUntil(
                                      (route) => route.isFirst,
                                    ),
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(value["message"]),
                                      ),
                                    ),
                                  },
                              },
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.kGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        "sign in",
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
