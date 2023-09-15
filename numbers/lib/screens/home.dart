import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:numbers/models/user.dart' as model;
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import 'LoginPage.dart';
import 'addContact.dart';
import 'editContact.dart';

class Home extends StatefulWidget {
  final String uid;
  const Home({Key? key, required this.uid}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  var userData = {};
  var nContacts = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  Future<int> getData() async {
    try {
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      nContacts = postSnap.docs.length ?? 0;
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.toString()),
          )
      );
    } return nContacts;
  }

  void editContact(String postId) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditContact(postId: postId),
      )
    );
  }

  void deleteContact(String postId) async {
    try {
      String res = "error";
      res = await FirestoreMethods().deletePost(
        postId : postId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res),
          )
      );
    } catch (err) {
      SnackBar(
        content: Text(err.toString()),
      );
    }
  }
  void signout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    dynamic Dheight = MediaQuery.of(context).size.height;
    dynamic Dwidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.pink.shade900,
            title: const Text(
                "Numbers",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico',
                )
            ),
            actions: [
              // A search icon on the app bar
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // TODO: Implement the search functionality
                  showSearch(context: context, delegate: CustomSearchDelegate());
                },
              ),
              SizedBox(width: Dwidth * 0.05,),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  // TODO: Implement the logout functionality
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Do you want to log out?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            signout();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) =>  const LoginPage()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey.shade200,
                            ),
                            padding: const EdgeInsets.all(12),
                            child: const Text("Yes"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: Container(
            // color: Colors.grey.shade900,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: Dheight * 0.8,
                  child: StreamBuilder(
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState != ConnectionState.waiting) {
                        print('getData: $nContacts');
                        return nContacts != 0 || getData() != 0 ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data?.docs.length,
                            shrinkWrap: false,
                            itemBuilder: (context, index) => snapshot.data!.docs[index].data()['uid'] == user?.uid ? Container(
                              margin: const EdgeInsets.all(2),
                              height: 80,
                              child: Card(
                                elevation: 10,
                                shadowColor: Colors.grey.shade200,
                                color: Colors.blueGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                // color: Colors.transparent,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () => snapshot.data!.docs[index].data()['profImage'] != null ? showDialog(
                                                context: context,
                                                builder: (context) => Dialog(
                                                  child: snapshot.data!.docs[index].data()['profImage'] != "" ? Image(
                                                    image: NetworkImage(
                                                      snapshot.data!.docs[index].data()['profImage'],
                                                    ),
                                                  ) :
                                                  const Image(
                                                    image: AssetImage(
                                                        'assets/imgvid/null_dp.png'
                                                    ),
                                                  ),
                                                ),
                                            ) : {},
                                            child: snapshot.data!.docs[index].data()['profImage'] != "" ? CircleAvatar(
                                              radius: 35,
                                              backgroundImage: NetworkImage(
                                                  snapshot.data!.docs[index].data()['profImage'],
                                              ),
                                            ) :
                                            const CircleAvatar(
                                              radius: 35,
                                              backgroundImage: AssetImage(
                                                  'assets/imgvid/null_dp.png'
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 70,
                                                  // padding: const EdgeInsets.all(20),
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Text(
                                                      snapshot.data!.docs[index].data()['name'],
                                                      style: const TextStyle(
                                                        fontSize: 22,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 110,
                                                  // padding: const EdgeInsets.all(20),
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Text(
                                                      snapshot.data!.docs[index].data()['number'],
                                                      style: TextStyle(color: Colors.grey.shade300),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    // delete button to delete the summary from history storage
                                    GestureDetector(
                                      onTap: () {
                                        editContact(snapshot.data!.docs[index].data()['postId']);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 20),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.grey.shade200,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          nContacts = nContacts - 1;
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('Do you want to delete ${snapshot.data!.docs[index].data()['name']}\'s contact?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  deleteContact(snapshot.data!.docs[index].data()['postId']);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.grey.shade200,
                                                  ),
                                                  padding: const EdgeInsets.all(12),
                                                  child: const Text("Yes"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 20),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ) : Container(),
                        ) : Container();
                      }
                      return const Center(child: CircularProgressIndicator(),);
                    },
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .orderBy(
                      'datePublished',
                      descending: true,
                    ).snapshots(),
                  ),
                ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddContact(),
                  ),
                );
                // getData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Text(
                  "Create or Add Contact",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,

                  ),
                ),
              ),
            ),
              ],
            ),
          ),
        ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  // Fetch data from Firestore
  Future<List<String>> getSearchTerms() async {
    var postSnap = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    return postSnap.docs.map((doc) => (doc['name'] + ': '+ doc['number'] + '(' + doc['relation'] + ')').toString()).toList();
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getSearchTerms(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<String> matchQuery = snapshot.data!.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
          return ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              var result = matchQuery[index];
              return Column(
                children: [
                  ListTile(
                    title: Text(result),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }
}

