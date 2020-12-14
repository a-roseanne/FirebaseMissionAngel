part of 'services.dart';

class AuthServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static Reference ref;
  static UploadTask uploadTask;

  static String imgUrl;
  // <void> jika tidak mengembalikan nilai
  static Future<String> signUp(
      String email, String password, String name) async {
    await Firebase.initializeApp();
    String msg = "";
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Users users = result.user.convertToUser(name: name);
      auth.signOut();
      await UserServices.updateUser(users);
      msg = "success";
    } catch (e) {
      msg = e.toString();
    }

    return msg;
  }

  static Future<String> signIn(String email, String password) async {
    await Firebase.initializeApp();
    String msg = "";
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .whenComplete(
            () => msg = "success",
          );
    } catch (e) {
      msg = e.toString();
    }
    return msg;
  }

  static Future<bool> signOut() async {
    bool result = false;
    await auth.signOut().whenComplete(() => result = true);
    return result;
  }

  static Future<String> uploadImage(File imageFile) async {
    String fileName = basename(imageFile.path);

    Reference ref = FirebaseStorage.instance.ref().child(fileName);

    uploadTask = ref.putFile(File(imageFile.path));

    await uploadTask.whenComplete(() => ref.getDownloadURL().then(
          (value) => imgUrl = value,
        ));
    return imgUrl;
  }
}
