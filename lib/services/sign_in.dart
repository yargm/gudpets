import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gudpets/services/services.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;
String uid;

Future<String> signInWithGoogle(Controller controlador1) async {
  controlador1.loading = true;
  controlador1.notify();
  print('entré a signinwithgoogle');
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  print('paso1');
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  print('paso2');

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  print('paso4');

  final User user = (await _auth.signInWithCredential(credential)).user;
  // final FirebaseUser user = authResult.user;
  print('capturé datos de usuario');

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoURL != null);
  assert(user.uid != null);
  controlador1.uid = user.uid;
  controlador1.name = user.displayName;
  print('no la estoy dando con' + controlador1.name.toString());
  controlador1.email = user.email;
  controlador1.imageUrl = user.photoURL;
  final User currentUser = FirebaseAuth.instance.currentUser;
  assert(user.uid == currentUser.uid);
  controlador1.loading = false;

  return 'signInWithGoogle succeeded: $user';
  
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}