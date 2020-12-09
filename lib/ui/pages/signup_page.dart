part of 'pages.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final ctrlName = TextEditingController();
  final ctrlEmail = TextEditingController();
  final ctrlPass = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    ctrlName.dispose();
    ctrlEmail.dispose();
    ctrlPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  TextFormField(
                    controller: ctrlName,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Nama',
                        hintText: "Write your name",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: ctrlEmail,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        labelText: 'Email',
                        hintText: "Write your active email",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: ctrlPass,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Password',
                        hintText: "Password",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  RaisedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text("Sign Up"),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () async {
                      if (ctrlName.text.isEmpty ||
                          ctrlEmail.text == "" ||
                          ctrlPass.text == "") {
                        Fluttertoast.showToast(
                            msg: "Please fill all fields!",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            toastLength: Toast.LENGTH_LONG);
                      } else {
                        String result = await AuthServices.signUp(
                            ctrlEmail.text, ctrlPass.text, ctrlEmail.text);
                        if (result == "success") {
                          Fluttertoast.showToast(
                              msg: "Sign up successful!",
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG);
                        } else {
                          Fluttertoast.showToast(
                              msg: result,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG);
                        }
                      }
                    },
                  ),
                  SizedBox(height: 25),
                  RichText(
                    text: TextSpan(
                        text: "Already have an account? Sign in",
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(this.context,
                                MaterialPageRoute(builder: (context) {
                              return MyApp();
                            }));
                          }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
