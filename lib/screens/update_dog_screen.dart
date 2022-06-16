import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../db/database_helper.dart';
import '../models/dog.dart';

class UpdateDogScreen extends StatefulWidget {
  final Dog dog;

  const UpdateDogScreen({Key? key, required this.dog}) : super(key: key);

  @override
  State<UpdateDogScreen> createState() => _UpdateDogScreenState();
}

class _UpdateDogScreenState extends State<UpdateDogScreen> {
  late String name;
  late int age;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Dog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.dog.name,
                  decoration: const InputDecoration(hintText: 'Dog Name'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide Dog Name';
                    }

                    name = value;
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: widget.dog.age.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Dog Age'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide Dog Age';
                    }

                    age = int.parse(value);
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var dog = Dog(id: widget.dog.id, name: name, age: age);

                        var dbHelper = DatabaseHelper.instance;
                        int result = await dbHelper.updateDog(dog);

                        if (result > 0) {
                          Fluttertoast.showToast(msg: 'Dog Updated');
                          Navigator.pop(context, 'done');

                        }
                      }
                    },
                    child: const Text('Update')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
