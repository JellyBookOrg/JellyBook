class Author {
  final String name;
  String? link;
  List<String> roles = [];

  Author({
    required this.name,
    this.link,
  });

  void addRole(String role) {
    roles.add(role);
  }
}
