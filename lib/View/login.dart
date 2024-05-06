import 'dart:io';

import 'package:cs_458_project3/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cs_458_project3/helper.dart';
import 'package:flutter/services.dart' show rootBundle;


final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class LoginActions {
  void onLoginFailed(String error) {
    // Implement your error handling logic here
    print("Login failed: $error");
  }

  void onLoginSuccessful() {
    // Implement your error handling logic here
    print("Login successful");
  }
}

class Login extends StatelessWidget {

  static LoginActions actions = LoginActions();

  static bool isValidPhone(String phoneNumber){
    RegExp regex = RegExp(r'^\d{10}$');
    return regex.hasMatch(phoneNumber);
  }

  static bool isValidEmail(String email){
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

 

  static Future<void> handleLogin(String emailPhoneNumber, String password, BuildContext context) async{
    // PhoneNo Login
    if(isValidPhone(emailPhoneNumber)){
      
      User().phoneNumber = emailPhoneNumber;

      var response1 = await http.post(

        Uri.http("localhost:3000", "/loginPhoneNumber"),
        headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Access-Control-Allow-Origin': '*', // Add this header
            },
          body: jsonEncode(<String, dynamic>{
            'phone_number' : User().phoneNumber,
            'password' : password
          })
      );
      bool successfulLogin = false;
      if(response1.statusCode == 200){
        var decodedResponse = jsonDecode(response1.body);
        // Access the 'message' key, which contains an array of items
        List<dynamic> messages = decodedResponse['message'];
        String email = messages[0]['email'];
        User().email = email;
        print(User().email);
        successfulLogin = true;
        actions.onLoginSuccessful();
      }

      else{
        actions.onLoginFailed("invalid cred.");
      }
      if(!context.mounted) return;
      if(successfulLogin){
        Navigator.pushNamed(context, "/seaPage");
      }
        
    }

    // Email Login
    else if(isValidEmail(emailPhoneNumber)){
      
      User().email = emailPhoneNumber;

      var response1 = await http.post(

        Uri.http("localhost:3000", "/loginEmail"),
        headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Access-Control-Allow-Origin': '*', // Add this header
            },
          body: jsonEncode(<String, dynamic>{
            'email' : User().email ,
            'password' : password
          })
      );
      bool successfulLogin = false;
      if(response1.statusCode == 200){
        var decodedResponse = jsonDecode(response1.body);
        // Access the 'message' key, which contains an array of items
        List<dynamic> messages = decodedResponse['message'];
        String pno = messages[0]['phone_number'];
        User().phoneNumber = pno;
        successfulLogin = true;
        print(User().phoneNumber);
        actions.onLoginSuccessful();
      }
      else{
        actions.onLoginFailed("invalid cred.");
      }
      if(!context.mounted) return;
      if(successfulLogin){
        Navigator.pushNamed(context, "/seaPage");
      }
        
    }

  }



  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 166, 211, 241),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              // For desktop layout
              return Center(
                child: SizedBox(
                  width: 400,
                  child: _buildLoginForm(context),
                ),
              );
            } else {
              // For mobile layout
              return _buildLoginForm(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: SelectionArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Email Or Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Enter your email or phone number',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              Row(
          
                mainAxisAlignment: MainAxisAlignment.end,
          
                children: [
                  ElevatedButton(
                    onPressed: () {
          
                      try{
                        handleLogin(_emailController.text, _passwordController.text, context );
                      }
                      
                      catch(e){
                        debugPrint("S");
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.green, // Button color
                      backgroundColor: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
          
                    child: const Text(
                      "Sign In",
                      style: TextStyle(fontSize: 16),
                    ),
          
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
