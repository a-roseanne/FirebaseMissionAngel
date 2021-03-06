part of 'pages.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final ctrlName = TextEditingController();
  final ctrlEmail = TextEditingController();
  final ctrlPass = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    ctrlName.dispose();
    ctrlEmail.dispose();
    ctrlPass.dispose();
    super.dispose();
  }

  void clearForm() {
    ctrlName.clear();
    ctrlEmail.clear();
    ctrlPass.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: Stack(children: [
          Container(
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
                      keyboardType: TextInputType.emailAddress,
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
                          setState(() {
                            isLoading = true;
                          });
                          String result = await AuthServices.signUp(
                              ctrlEmail.text, ctrlPass.text, ctrlName.text);
                          if (result == "success") {
                            Fluttertoast.showToast(
                                msg: "Sign up successful!",
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                toastLength: Toast.LENGTH_LONG);
                            setState(() {
                              isLoading = false;
                              clearForm();
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: result,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                toastLength: Toast.LENGTH_LONG);
                            setState(() {
                              isLoading = false;
                            });
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
          isLoading == true
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                  child: SpinKitFadingCircle(
                    size: 50,
                    color: Colors.lightBlue,
                  ),
                )
              : Container()
        ]),
      ),
    );
  }
}
