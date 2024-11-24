import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi{
  static void firebaseInit(){
    FirebaseMessaging.onMessage.listen(
      (message){
        print(message.notification!.title);
        print(message.notification!.body);
      },
    );
  }
}