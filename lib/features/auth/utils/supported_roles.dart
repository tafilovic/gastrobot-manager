/// Roles that are allowed to use the app. Others get "role not supported" after login.
const List<String> supportedRoles = ['chef', 'waiter', 'bartender'];

/// Returns true if [role] is one of the supported app roles.
bool isSupportedRole(String role) {
  return supportedRoles.contains(role.toLowerCase());
}
