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


class Login extends StatelessWidget {

  bool isValidPhone(String phoneNumber){
    RegExp regex = RegExp(r'^\d{10}$');
    return regex.hasMatch(phoneNumber);
  }

  bool isValidEmail(String email){
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

 

  Future<void> handleLogin(String emailPhoneNumber, String password, BuildContext context) async{

    
    final String response = await rootBundle.loadString('assets/user.json');
    Map<String, dynamic> data = await json.decode(response);
    
  List<Map<String, dynamic>> users = (data['users'] as List<dynamic>).cast<Map<String, dynamic>>();
    

    if(isValidPhone(emailPhoneNumber)){
      
       for (Map<String, dynamic> user in users) {
        
        if(emailPhoneNumber == user['phone'] && user['password'] == password){
          User().email = user['email'];
          User().phoneNumber = user['phone'];

          if(!context.mounted) return;
          Navigator.pushNamed(context, "/seePage");
        }

      }

    }

    else if (isValidEmail(emailPhoneNumber)) {

      for (Map<String, dynamic> user in users) {
        
        if(emailPhoneNumber == user['email'] && user['password'] == password){
          User().email = user['email'];
          User().phoneNumber = user['phone'];

          if(!context.mounted) return;
          Navigator.pushNamed(context, "/seePage");
        }

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
