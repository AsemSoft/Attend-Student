import 'package:jwt_decoder/jwt_decoder.dart';

const jwtNameIdentifier =
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier';
const jwtEmail =
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress';
const jwtGivenName =
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname';
const jwtSurname =
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname';
const jwtRole = 'http://schemas.microsoft.com/ws/2008/06/identity/claims/role';

enum UserRole { root, admin, instructor, student }

class SessionUser {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final UserRole role;

  SessionUser({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  static SessionUser fromToken(String token) {
    Map<String, dynamic> decoded = JwtDecoder.decode(token);

    int id = int.parse(decoded['id']);
    String username = decoded[jwtNameIdentifier];
    String email = decoded[jwtEmail];
    String firstName = decoded[jwtGivenName];
    String lastName = decoded[jwtSurname];
    UserRole role = parseUserRole(decoded[jwtRole]);

    return SessionUser(
      id: id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: role,
    );
  }
  
  bool isRootOrAdmin() {
    return role == UserRole.root || role == UserRole.admin;
  }
}

UserRole parseUserRole(String roleString) {
  switch (roleString) {
    case 'root':
      return UserRole.root;
    case 'admin':
      return UserRole.admin;
    case 'instructor':
      return UserRole.instructor;
    case 'student':
      return UserRole.student;
    default:
      throw Exception('invalid role');
  }
}

String getRoleString(UserRole role) {
  switch (role) {
    case UserRole.root:
      return 'root';
    case UserRole.admin:
      return 'admin';
    case UserRole.instructor:
      return 'instructor';
    case UserRole.student:
      return 'student';
  }
}