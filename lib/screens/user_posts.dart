import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pakistan_solar_market/screens/update_user_post_screen.dart';
import '../pdf_services.dart';
import '../user_post_model.dart';
import 'myDrawer.dart';

class UserPostsList extends StatefulWidget {
  const UserPostsList({super.key});

  @override
  _UserPostsListState createState() => _UserPostsListState();
}

class _UserPostsListState extends State<UserPostsList> {
  List<UserPost> userPosts = [];
  String? postID;
  String? mainDocId;
  late Future<List<UserPost>> userPostsFuture;
  late Future<List<UserPost>> userPostsFuture2;
  TextEditingController searchController = TextEditingController();

  Future<List<UserPost>> fetchData() async {

    CollectionReference postsCollection =
    FirebaseFirestore.instance.collection('posts');

    QuerySnapshot postsSnapshot = await postsCollection.get();

    for (QueryDocumentSnapshot postDoc in postsSnapshot.docs) {
      postID = postDoc.id;


      CollectionReference userPanelPostsCollection =
      postsCollection.doc(postID).collection('userPanelPosts');

      QuerySnapshot userPanelPostsSnapshot =
      await userPanelPostsCollection.get();

      for (var userPostDoc in userPanelPostsSnapshot.docs) {
        Map<String, dynamic> postDetails =
        userPostDoc.data() as Map<String, dynamic>;

        mainDocId = postDetails['mainDocId'];

        UserPost userPost = UserPost.fromJson(postDetails);

        userPosts.add(userPost);
      }
    }

    return userPosts;
  }

  Future<List<UserPost>> displayPost() async {
    CollectionReference postsCollection =
    FirebaseFirestore.instance.collection('posts');

    QuerySnapshot postsSnapshot = await postsCollection
        .doc("+923114376818")
        .collection("userPanelPosts")
        .get();

    for (var userPostDoc in postsSnapshot.docs) {
      Map<String, dynamic> postDetails =
      userPostDoc.data() as Map<String, dynamic>;

      mainDocId ??= postDetails['mainDocId'];


      UserPost userPost = UserPost.fromJson(postDetails);

      userPosts.add(userPost);
    }
    return userPosts;
  }

  List<UserPost> filterPosts(List<UserPost> posts, String query) {
    return posts.where((post) {
      String phoneno = post.phoneno.toLowerCase();
      String available = post.available.toLowerCase();
      String subCategories = post.subCategories.toLowerCase();
      String name = post.name.toLowerCase();

      return phoneno.contains(query.toLowerCase()) ||
          available.contains(query.toLowerCase()) ||
          subCategories.contains(query.toLowerCase()) ||
          name.contains(query.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    userPostsFuture = fetchData();
    userPostsFuture2 = displayPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const MyDrawer(),
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 50, right: 50, top: 10),
                  child: Text(
                    "User Posts",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 500,
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Posts',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {});
                            },
                          ),
                        ),
                        onChanged: (query) {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder<List<UserPost>>(
                    future: userPostsFuture,
                    builder: (context, AsyncSnapshot<List<UserPost>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No data found for the user.'),
                        );
                      } else {
                        List<UserPost> filteredPosts =
                        filterPosts(snapshot.data!, searchController.text);

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: ScrollController(),
                              child: DataTable(
                                border: TableBorder.all(width: 0.75),
                                columns: const [
                                  DataColumn(
                                    label: SizedBox(
                                      width: 50,
                                      child: Text(
                                        'Name',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Phone Number',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 100,
                                      child: Text(
                                        'SubCategories',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 50,
                                      child: Text(
                                        'Posted At',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 50,
                                      child: Text(
                                        'Size',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 70,
                                      child: Text(
                                        'Number',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 70,
                                      child: Text(
                                        'Available',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 50,
                                      child: Text(
                                        'Type',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 50,
                                      child: Text(
                                        'Price',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 50,
                                      child: Text(
                                        'Sold',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: 50,
                                      child: Text(
                                        'Action',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: filteredPosts
                                    .map<DataRow>((UserPost postData) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          postData.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.visible,
                                          softWrap: false,
                                        ),
                                      ),
                                      DataCell(Text(postData.phoneno)),
                                      DataCell(Text(postData.subCategories)),
                                      DataCell(Text(postData.postedAt)),
                                      DataCell(Text(postData.size)),
                                      DataCell(Text(postData.number)),
                                      DataCell(
                                        Text(
                                          postData.available,
                                          maxLines: 1,
                                          overflow: TextOverflow.visible,
                                          softWrap: false,
                                        ),
                                      ),
                                      DataCell(Text(postData.type)),
                                      DataCell(Text(postData.price)),
                                      DataCell(Text(postData.sold.toString())),
                                      DataCell(InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateUserPostScreen(
                                                      postData: postData),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "Edit",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          PdfService().printCustomersPdf(userPosts);
        },
        child: const Icon(
          Icons.print,
          color: Colors.white,
        ),
      ),
    );
  }
}
