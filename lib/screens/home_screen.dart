import 'package:flutter/material.dart';
import 'package:homework_sql/controllers/contacts_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final ContactsController contactDatabase = ContactsController();
  List<Map<String, dynamic>> contacts = [];

  @override
  void initState() {
    super.initState();
    viewContacts();
  }

  Future<void> viewContacts() async {
    await contactDatabase.viewContacts();
    setState(() {});
  }

  Future<void> deleteContact(String contactId) async {
    await contactDatabase.deleteContacts(contactId);
  }

  Future<void> editContact(
    String contactId,
    String newName,
  ) async {
    await contactDatabase.editContacts(
      contactId,
      newName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Phone Contacts",
            style: TextStyle(fontSize: 35),
          ),
          centerTitle: true,
          backgroundColor: Colors.greenAccent,
          foregroundColor: const Color.fromARGB(255, 2, 161, 98),
          actions: [
            IconButton(
                onPressed: () async {
                  final response = await showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text("Add Contacts"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Name"),
                              ),
                              TextField(
                                controller: phoneController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Phone Number"),
                              )
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                            FilledButton(
                                onPressed: () {
                                  Navigator.pop(context, {
                                    "name": nameController.text,
                                    "phone_number": phoneController.text,
                                  });
                                },
                                child: const Text("Save"))
                          ],
                        );
                      });
                  if (response != null) {
                    //! Add new contacts
                    print(response);
                    nameController.clear();
                    phoneController.clear();

                    await contactDatabase.addContacts(
                        response['name'], response['phone_number']);
                    print("object");
                    setState(() {});
                  }
                },
                icon: const Icon(
                  Icons.add,
                  size: 40,
                ))
          ],
        ),
        body: FutureBuilder(
            future: contactDatabase.viewContacts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final contacts = snapshot.data;
              return contacts == null
                  ? const Center(
                      child: Text("No contacts yet!"),
                    )
                  : ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          onTap: () async {
                            nameController.text = contacts[index]['name'];
                            phoneController.text =
                                contacts[index]['phone_number'];
                            final response = await showDialog<String>(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text("Edit Contacts"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Name",
                                        ),
                                      ),
                                      TextField(
                                        controller: phoneController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Phone Number",
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        editContact(
                                          contacts[index]['id'],
                                          nameController.text,
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Edit"),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (response != null) {
                              //! Contact editing
                              await editContact(
                                  contacts[index]['id'], response);
                            }
                          },
                          title: Text(
                            "${index + 1}.${contacts[index]['name']}'s phone number is${contacts[index]["phone_number"]}",
                            style: const TextStyle(fontSize: 30),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              //! Contact deleting
                              deleteContact(contacts[index]['id']);
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 30,
                            ),
                          ),
                        );
                      },
                    );
            }));
  }
}


// ListView.builder(
//         itemCount: contacts.length,
//         itemBuilder: (ctx, index) {
//           return ListTile(
//             onTap: () async {
//               nameController.text = contacts[index]['name'];
//               phoneController.text = contacts[index]['phone_number'];
//               final response = await showDialog<String>(
//                 context: context,
//                 builder: (ctx) {
//                   return AlertDialog(
//                     title: const Text("Edit Contacts"),
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         TextField(
//                           controller: nameController,
//                           decoration: const InputDecoration(
//                             border: OutlineInputBorder(),
//                             labelText: "Name",
//                           ),
//                         ),
//                         TextField(
//                           controller: phoneController,
//                           decoration: const InputDecoration(
//                             border: OutlineInputBorder(),
//                             labelText: "Phone Number",
//                           ),
//                         ),
//                       ],
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Text("Cancel"),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           editContact(
//                             contacts[index]['id'],
//                             nameController.text,
//                           );
//                           Navigator.pop(context);
//                         },
//                         child: const Text("Edit"),
//                       ),
//                     ],
//                   );
//                 },
//               );

//               if (response != null) {
//                 //! Contact editing
//                 await editContact(contacts[index]['id'], response);
//               }
//             },
//             title: Text(
//               "${index + 1}.${contacts[index]['name']}'s phone number is${contacts[index]["phone_number"]}",
//               style: const TextStyle(fontSize: 30),
//             ),
//             trailing: IconButton(
//               onPressed: () {
//                 //! Contact deleting
//                 deleteContact(contacts[index]['id']);
//               },
//               icon: const Icon(
//                 Icons.delete,
//                 size: 30,
//               ),
//             ),
//           );
//         },
//       ),