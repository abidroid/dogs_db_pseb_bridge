import 'package:dogs_db_pseb_bridge/db/database_helper.dart';
import 'package:dogs_db_pseb_bridge/models/dog.dart';
import 'package:dogs_db_pseb_bridge/screens/update_dog_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchDogScreen extends StatefulWidget {
  const SearchDogScreen({super.key});

  @override
  State<SearchDogScreen> createState() => _SearchDogScreenState();
}

class _SearchDogScreenState extends State<SearchDogScreen> {
  TextEditingController nameC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameC,
              decoration: InputDecoration(
                hintText: 'Type a Dog Name',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    DatabaseHelper.instance.searchDog(name: nameC.text.trim());

                    setState(() {});
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
                child: FutureBuilder<List<Dog>>(
                    future: DatabaseHelper.instance.searchDog(
                      name: nameC.text.trim(),
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.data!.isEmpty) {
                          return const Center(child: Text('No Dogs Found in Database'));
                        } else {
                          List<Dog> dogs = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ListView.builder(
                                itemCount: dogs.length,
                                itemBuilder: (context, index) {
                                  Dog dog = dogs[index];
                                  return Card(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      dog.name,
                                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text('Age: ${dog.age}')
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  IconButton(
                                                      onPressed: () async {
                                                        var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                          return UpdateDogScreen(dog: dog);
                                                        }));

                                                        if (result == 'done') {
                                                          setState(() {});
                                                        }
                                                      },
                                                      icon: const Icon(Icons.edit)),
                                                  IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            barrierDismissible: false,
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: const Text('Confirmation!'),
                                                                content: const Text('Are you sure to delete ?'),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                      child: const Text('No')),
                                                                  TextButton(
                                                                      onPressed: () async {
                                                                        Navigator.of(context).pop();

                                                                        // delete dog

                                                                        int result = await DatabaseHelper.instance.deleteDog(dog.id!);

                                                                        if (result > 0) {
                                                                          Fluttertoast.showToast(msg: 'Dog Deleted');
                                                                          setState(() {});
                                                                          // build function will be called
                                                                        }
                                                                      },
                                                                      child: const Text('Yes')),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      icon: const Icon(Icons.delete)),
                                                ],
                                              )
                                            ],
                                          )));
                                }),
                          );
                        }
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
