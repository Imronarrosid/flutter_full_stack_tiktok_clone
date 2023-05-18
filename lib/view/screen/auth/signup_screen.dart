import 'package:flutter/material.dart';
import 'package:tiktok_clone/view/screen/auth/login_screen.dart';
import 'package:tiktok_clone/view/widgets/form_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tiktok Clone')),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Text(
                'Register',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              CustomFormField(
                  controller: _emailController,
                  labelText: 'Username',
                  prefixIcon: Icons.person),
              const SizedBox(
                height: 15,
              ),
              CustomFormField(
                  controller: _emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.mail),
              const SizedBox(
                height: 15,
              ),
              CustomFormField(
                controller: _passwordController,
                labelText: 'Password',
                prefixIcon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      maximumSize: Size(double.infinity, 50)),
                  onPressed: () {},
                  child: Text('Register')),
                  const SizedBox(height: 20,),

                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        const Text('Alredy have an account?'),
                      
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
                          print('regiss');
                        },
                        child: const Text('Login',style: TextStyle(color: Colors.blue),),
                      )
                    ],
                  )
            ],
          )),
    );
  }
}
