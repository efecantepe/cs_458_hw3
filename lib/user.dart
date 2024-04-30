class User {
  static final User _singleton = User._internal();
  
  late String _email;
  late String _phoneNumber;
  
  factory User() {
    return _singleton;
  }
  
  User._internal();
  
  // Getter for email
  String get email => _email;
  
  // Setter for email
  set email(String value) {
    _email = value;
  }
  
  // Getter for phoneNumber
  String get phoneNumber => _phoneNumber;
  
  // Setter for phoneNumber
  set phoneNumber(String value) {
    _phoneNumber = value;
  }
}
