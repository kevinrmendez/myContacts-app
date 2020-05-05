class Contact {
  static int contactId = 0;
  int id;
  String name;
  String phone;
  String image;
  String email;
  String category;
  String birthday;
  String address;
  String organization;
  String website;
  String note;
  int showNotification;
  int favorite;

  // Contact(
  //     {this.name,
  //     this.phone,
  //     this.image = "",
  //     this.id,
  //     this.email = "",
  //     this.category,
  //     this.birthday = "",
  //     this.address = "",
  //     this.organization = "",
  //     this.note = "",
  //     this.website = "",
  //     this.favorite = 0});
  Contact({
    this.name,
    this.phone,
    this.image = "",
    this.id,
    this.email = "",
    this.category,
    this.birthday = "",
    this.address = "",
    this.organization = "",
    this.note = "",
    this.website = "",
    this.favorite = 0,
    this.showNotification = 0,
  }) {
    if (id == null) {
      this.id = Contact.contactId;
      Contact.contactId++;
    } else {
      this.id = id;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'image': image,
      'category': category,
      'birthday': birthday,
      'address': address,
      'organization': organization,
      'website': website,
      'note': note,
      'favorite': favorite,
      'showNotification': showNotification,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Contact{id: $id, name: $name, phone: $phone,email: $email, category: $category, birthday: $birthday, address: $address,organization: $organization, website: $website ,image: $image, favorite $favorite, showNotification: $showNotification}';
  }
}
