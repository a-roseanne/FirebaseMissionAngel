part of 'pages.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String uid, username, pic;
  final currentUser = FirebaseAuth.instance.currentUser;
  var userCollection = FirebaseFirestore.instance.collection('users');
  bool isLoading = false;

  String imagePath;

  PickedFile imageFile;
  final ImagePicker imagePicker = ImagePicker();

  Future chooseImage() async {
    final selectedImage = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      imageFile = selectedImage;
    });
  }

  void getUserdata() {
    //Ambil data
    userCollection.doc(currentUser.uid).snapshots().listen((event) {
      username = event.data()['name'];
      pic = event.data()['profilePicture'];
      if (pic == "") {
        pic = null;
      }
      setState(() {});
    });
  }

  void initState() {
    getUserdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Account"),
          centerTitle: true,
          leading: Container(),
        ),
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(height: 10),
            CircleAvatar(
                radius: 120,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(pic ??
                    "https://i.dlpng.com/static/png/6542370_preview.png")),
            RaisedButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text("Edit Photo"),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                await chooseImage();
                setState(() {
                  isLoading = true;
                });
                await UserServices.updateProfile(currentUser.uid, imageFile)
                    .then((value) {
                  if (value) {
                    Fluttertoast.showToast(
                        msg: "Update Profile Successfull",
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_LONG);
                    setState(() {
                      isLoading = false;
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Update Profile Failed",
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_LONG);
                    setState(() {
                      isLoading = false;
                    });
                  }
                });
              },
            ),
            Text(
              username ?? "Display Name",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              currentUser.email,
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Sign Out Confirmation"),
                              content: Text("Do you want to sign out?"),
                              actions: [
                                FlatButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await AuthServices.signOut().then((value) {
                                      if (value) {
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return SignInPage();
                                        }));
                                        setState(() {
                                          isLoading = false;
                                        });
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    });
                                  },
                                  child: Text("Yes"),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("No"),
                                )
                              ],
                            );
                          });
                    },
                    padding: EdgeInsets.all(12),
                    child: Text("Signout"),
                  )),
            ),
            isLoading == true
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent,
                    child: SpinKitFadingCircle(size: 50, color: Colors.blue),
                  )
                : Container()
          ],
        )));
  }
}
