import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class EditContact extends StatefulWidget {
  final String postId;
  const EditContact({Key? key, required this.postId}) : super(key: key);

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  var postData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();

      postData = postSnap.data()!;

    } catch (err) {
      SnackBar(
        content: Text(err.toString()),
      );
    }
    setState(() {
      isLoading = false;
    });
  }
  Uint8List? _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();

  bool _isLoading = false;

  String? name;
  String? number;
  bool canUpdate = true;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _numberController.dispose();
    _relationController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void updateContact(
      String name,
      String number,
      String relation,
      String uid,
      Uint8List? file
      ) async {
    setState(() {
      _isLoading = true;
    });
    bool contentOk = true;

    print('PostData');
    if (kDebugMode) {
      print(postData);
    }

    if (_nameController.text == "") {
      _nameController.text = postData['name'];
    }
    if (_numberController.text == "") {
      _numberController.text = postData['number'];
    }
    if (_relationController.text == "") {
      _relationController.text = postData['relation'];
    }
    if (contentOk == false) {
      return;
    } else {
      try {
        String res = await FirestoreMethods().updateContact(
          name: _nameController.text,
          number: _numberController.text,
          relation: _relationController.text,
          uid: uid,
          postId: postData['postId'],
          _image,
        );
        if (res == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Posted!'),
              )
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(res),
              )
          );
        }
      } catch (err) {
        SnackBar(
          content: Text(err.toString()),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void signout() async{
    await AuthMethods().signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    dynamic Dheight = MediaQuery.of(context).size.height;
    dynamic Dwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.black26,
        centerTitle: false,
        title: const Text(
            "Numbers",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pacifico',
            )
        ),
      ),
      body: Material(
        // color: const Color.fromARGB(255, 60, 60, 60),
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
                      "Edit Contact",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dheight * 0.03,),
                Material(
                  borderRadius: BorderRadius.circular(40),
                  child: InkWell(
                    onTap: () => selectImage(),
                    child: Container(
                      child: _image != null
                          ? Material(
                        borderRadius: BorderRadius.circular(50),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.greenAccent,
                          child: CircleAvatar(
                            radius: 38,
                            backgroundImage:
                            MemoryImage(_image!),
                          ),
                        ),
                      )
                          : Material(
                        borderRadius: BorderRadius.circular(50),
                        child: postData['profImage'] != "" ? CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              postData['profImage'] ?? 'https://wallpaperaccess.com/full/2131.jpg'
                          ),
                        ) :
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/imgvid/null_dp.png'),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dheight * 0.06,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _nameController,
                    // initialValue: postData['name'],
                    decoration: InputDecoration(
                      hintText: postData['name'],
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
                SizedBox(height: Dheight * 0.03,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _numberController,
                    // initialValue: postData['number'],
                    decoration: InputDecoration(
                      hintText: postData['number'],
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
                SizedBox(height: Dheight * 0.03,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _relationController,
                    // initialValue: postData['relation'],
                    decoration: InputDecoration(
                      hintText: postData['relation'],
                      // errorText: relation,
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
                SizedBox(height: Dheight * 0.03,),
                const Divider(
                  thickness: 1.0,
                ),
                SizedBox(height: Dheight * 0.06,),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: Colors.white60),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    child: Center(
                      child: _isLoading ? const CircularProgressIndicator(
                        color: Colors.white,
                      ) : Container(
                        padding: const EdgeInsets.all(10),
                        child: const Center(child: Text('Update')),
                      ),
                    ),
                    onTap: () {
                      if(canUpdate){
                        updateContact(
                            _nameController.text,
                            _numberController.text,
                            _relationController.text,
                            user!.uid,
                            _image
                        );
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
          // backgroundColor: Colors.blueGrey[200],
          child: const Icon(Icons.home),
        ),
      ),
    );
  }
}

