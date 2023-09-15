import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numbers/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:numbers/models/user.dart' as model;
import '../providers/user_provider.dart';
import '../resources/auth_methods.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';
import 'package:numbers/screens/loginPage.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  Uint8List? _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();

  bool _isLoading = false;
  String username = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String? name;
  String? number;
  bool canPost = true;

  @override
  // Dispose controllers
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _numberController.dispose();
    _relationController.dispose();
  }

  // select an Image
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  // add a Contact
  void postStuff(String name, String number, String relation, String uid,
      Uint8List? file) async {
    setState(() {
      _isLoading = true;
    });
    bool contentOk = true;

    if (_nameController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please give a name'),
      ));
      contentOk = false;
    }
    if (_numberController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter the number'),
      ));
      contentOk = false;
    }
    if (_relationController.text == "") {
      _relationController.text = "Unknown relation";
    }

    if (contentOk == false) {
    } else {
      try {
        String res = await FirestoreMethods().uploadContact(
          name: _nameController.text,
          number: _numberController.text,
          relation: _relationController.text,
          uid: uid,
          _image,
        );
        if (res == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Posted! Please wait till the record is updated."),
          ));

          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(res),
          ));
        }
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err.toString()),
        ));
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    dynamic Dheight = MediaQuery.of(context).size.height;
    dynamic Dwidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Numbers",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pacifico',
              )),
        ),
        body: Material(
          child: SizedBox(
            height: Dheight * 0.9,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                      child: const Text(
                        "Add Contact",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dheight * 0.02,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(40),
                    child: InkWell(
                      onTap: () => selectImage(),
                      child: Container(
                        child: _image != null
                            ? Material(
                                borderRadius: BorderRadius.circular(50),
                                child: CircleAvatar(
                                  radius: Dheight * 0.1,
                                  backgroundColor: Colors.greenAccent,
                                  child: CircleAvatar(
                                    radius: Dheight * 0.09,
                                    backgroundImage: MemoryImage(_image!),
                                  ),
                                ),
                              )
                            : Material(
                                borderRadius: BorderRadius.circular(50),
                                child: CircleAvatar(
                                  radius: Dheight * 0.05,
                                  backgroundImage: const AssetImage(
                                      'assets/imgvid/null_dp.png'),
                                ),
                              ),
                      ),
                    ),
                  ),
                  _image == null
                      ? Container(
                          margin:
                              EdgeInsets.symmetric(vertical: Dheight * 0.01),
                          child:
                              const Text("Chose a profile picture (optional)"),
                        )
                      : Container(),
                  SizedBox(
                    height: Dheight * 0.02,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Name",
                        errorText: name,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        filled: true,
                        prefixIcon: const Icon(Icons.person),
                      ),
                      keyboardType: TextInputType.text,
                      onTap: () {},
                    ),
                  ),
                  SizedBox(
                    height: Dheight * 0.02,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _numberController,
                      decoration: InputDecoration(
                        hintText: "Number",
                        errorText: number,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        filled: true,
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        // Allow only digits and plus sign as input
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                      ],
                      onTap: () {},
                    ),
                  ),
                  SizedBox(
                    height: Dheight * 0.02,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _relationController,
                      decoration: InputDecoration(
                        hintText: "Relation (optional)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        filled: true,
                        prefixIcon: const Icon(Icons.person_add_alt_1_rounded),
                      ),
                      keyboardType: TextInputType.text,
                      onTap: () {},
                    ),
                  ),
                  const Divider(
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: Dheight * 0.04,
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      border: Border.all(color: Colors.white60),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Container(
                                padding: const EdgeInsets.all(10),
                                child: const Center(child: Text('Post')),
                              ),
                      ),
                      onTap: () async {
                        setState(() {
                          if (_nameController.text.isEmpty) {
                            name = "Name can't be empty";
                            canPost = false;
                          } else if (_numberController.text.isEmpty) {
                            number = "Number can't be empty";
                            canPost = false;
                          } else {
                            canPost = true;
                          }
                        });

                        if (canPost) {
                          postStuff(
                              _nameController.text,
                              _numberController.text,
                              _relationController.text,
                              user!.uid,
                              _image);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
          child: FloatingActionButton(
            onPressed: () => Navigator.of(context).pop(),
            elevation: 15,
            child: const Icon(Icons.home),
          ),
        ),
      ),
    );
  }
}
