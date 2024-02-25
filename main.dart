import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
void main(List<String> args) {
  String? userName;
  String? userPassword;
  String? messageSender;
  String? messageReceiver;
  String? message;
  String? hashedMessage;
  String? hashedMessageForReceiver;
  
  //Kayıt oluştur
  Map<String, String>? users = SignUp(userName ?? "", userPassword ?? "");
  
  //Giriş yap
  print("Log In");
  messageSender = LogIn(users);

  //Mesaj yollanacak kişi
  print("Who do you want to send a message to?: ");
  messageReceiver = stdin.readLineSync();
  messageReceiver = HashPassword(messageReceiver!);
  //Gönderilecek mesajı alıyoruz
  print("What's your message? : ");
  message = stdin.readLineSync();
  
  //mesaj hash yapılıp gönderiliyor
  hashedMessage = SendMessage(messageSender, users, message);

  //karşılaştırıp yazdırılıyor
  ShowMessage(hashedMessageForReceiver, hashedMessage, users, messageReceiver, message);
}

void ShowMessage(String? hashedMessageForReceiver, String? hashedMessage, Map<String, String>? users, String? messageReceiver, String? message) {
  String? salt = GenerateSalt(16);
  hashedMessageForReceiver = (hashedMessage! + users![messageReceiver]! + salt);//mesaj karşılandı

  if(hashedMessageForReceiver == hashedMessage){//hash karşılaştırıldı
    print("Mesajınız : $message");//mesaj yazdırıldı
  }
}

String? SendMessage(String? messageSender, Map<String, String>? users, String? message) {
  String? salt = GenerateSalt(16);
  String? hashedMessage = users![messageSender]! + message! + salt ;//password + salt + message
  return hashedMessage;
}


Map<String,String>? SignUp(String userName, String userPassword){
  String? userInput;
  String? hashedPassword;
  String? hashedName;
  Map<String,String>? users = {};
  while (userInput != 'q') {
    print("Enter your name: ");
    userName = stdin.readLineSync()!;
    hashedName = HashPassword(userName);
    print("q for quit: ");
    print("Enter your password: ");
    userPassword = stdin.readLineSync()!;
    print("q for quit: ");
    hashedPassword = HashPassword(userPassword);

    users[hashedName] = hashedPassword;
    userInput = stdin.readLineSync();
  }
  print("Kayıtlar oluşturuldu");
  return users;
}

String GenerateSalt(int length){
  final random = Random.secure();
  var codeUnits = List.generate(length, (_) => random.nextInt(256));
  return String.fromCharCodes(codeUnits);
}

String HashPassword(String input){
  var bytes = utf8.encode(input);
  var hash = sha256.convert(bytes);
  return hash.toString();
}

String? LogIn(Map<String,String>? users){
  print("Enter your name for log in : ");
  String? userNameInput = stdin.readLineSync();
  print("Enter your password for log in : ");
  String? userPasswordInput = stdin.readLineSync();
  
  String? hashedUserNameInput = HashPassword(userNameInput ?? "");
  String? hashedUserPasswordInput = HashPassword(userPasswordInput ?? "");
  for (var key in users!.keys) {
    if(hashedUserNameInput == key && users[key] == hashedUserPasswordInput){
      return hashedUserNameInput;
    }
  }
  return null;
}