import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Credentials? _credentials;
  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0('dev-aelqdrh6hx6twsln.us.auth0.com', 'iQ3FUZ079MZEL0piWVGl36fI4NWcxOhL');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.of(context).pushReplacementNamed('/');
            }
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_credentials == null) 
              ElevatedButton(
                onPressed: () async {
                  try {
                    final credentials = await auth0.webAuthentication(scheme: 'https').login();
                    setState(() {
                      _credentials = credentials;
                    });
                  } catch (e) {
                    print('Error during login: $e');
                  }
                },
                child: const Text("Log in")
              )
          ],
        ),
      ),
    );
  }
}
