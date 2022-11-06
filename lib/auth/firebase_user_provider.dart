import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class BetaFirebaseUser {
  BetaFirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

BetaFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<BetaFirebaseUser> betaFirebaseUserStream() => FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<BetaFirebaseUser>(
      (user) {
        currentUser = BetaFirebaseUser(user);
        return currentUser!;
      },
    );
