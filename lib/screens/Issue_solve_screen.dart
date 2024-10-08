import 'dart:io';
import 'dart:typed_data';

import 'package:Lets_Change/models/user.dart';
import 'package:Lets_Change/providers/user_provider.dart';
import 'package:Lets_Change/resources/firestore_methods.dart';
import 'package:Lets_Change/screens/comments_screen.dart';
import 'package:Lets_Change/widgets/like_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';



class IssueSolveScreen extends StatefulWidget {
  final snap;

   IssueSolveScreen({super.key, this.snap,});

  @override
  State<IssueSolveScreen> createState() => _IssueSolveScreenState();
}

class _IssueSolveScreenState extends State<IssueSolveScreen> {

  bool isLikeAnimating1 = false;
  bool isLikeAnimating2 = false;
  int commentLen = 0;
  var image;
  DateTime now = new DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(

          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                        child:  Card(
                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          elevation: 15,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.greenAccent,
                                    Colors.lightBlueAccent
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Row(
                                  //   // crossAxisAlignment: CrossAxisAlignment.center,
                                  //   children: [
                                  //     Padding(
                                  //       padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                                  //       child: CircleAvatar(
                                  //         radius: 30,
                                  //         backgroundColor: CupertinoColors.systemGrey2,
                                  //         backgroundImage: NetworkImage(widget.snap['profImage'] ??
                                  //             'https://www.pngitem.com/pimgs/m/504-5040528_empty-profile-picture-png-transparent-png.png'),
                                  //       ),
                                  //     ),
                                  //     Column(
                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                  //       children: [
                                  //         Text(
                                  //           widget.snap['username'],
                                  //           style: const TextStyle(fontWeight: FontWeight.bold),
                                  //         ),
                                  //         Text(
                                  //           widget.snap['address'],
                                  //           style: const TextStyle(fontWeight: FontWeight.bold),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     Spacer(),
                                  //     IconButton(
                                  //         onPressed: () {
                                  //           _showDeleteDialog(context);
                                  //
                                  //         },
                                  //         icon: const Icon(Icons.more_vert))
                                  //   ],
                                  // ),
                                  ListTile(
                                    leading: CircleAvatar(radius: 30,
                                      backgroundColor: CupertinoColors.systemGrey2,
                                      backgroundImage: NetworkImage(widget.snap['profImage'] ??
                                          'https://www.pngitem.com/pimgs/m/504-5040528_empty-profile-picture-png-transparent-png.png'),),
                                    title: Text(
                                      widget.snap['username'],
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      widget.snap['address'],
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          _showDeleteDialog(context);

                                        },
                                        icon: const Icon(Icons.more_vert)),
                                  ),
                                  Divider(
                                    thickness: 5,
                                  ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                                    child: Text(widget.snap['description']),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onDoubleTap: () async {
                                          // await FireStoreMethods().likePost(widget.snap['postId'],
                                          //     widget.snap['uid'], widget.snap['likes']);
                                          // setState(() {
                                          //   isLikeAnimating1 = true;
                                          // });
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image:
                                                    NetworkImage(widget.snap['postUrl'] ?? ''),
                                                  ),
                                                  color: Colors.grey.shade300),
                                              height: 300,
                                              width: MediaQuery.of(context).size.width * 0.85,
                                            ),
                                            AnimatedOpacity(
                                              duration: const Duration(milliseconds: 200),
                                              opacity: isLikeAnimating1 ? 1 : 0,
                                              child: LikeAnimation(
                                                isAnimating: isLikeAnimating1,
                                                duration: const Duration(
                                                  milliseconds: 200,
                                                ),
                                                onEnd: () {
                                                  setState(() {
                                                    isLikeAnimating1 = false;
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.energy_savings_leaf,
                                                  color: Colors.greenAccent,
                                                  size: 100,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //Like Share and Comment button
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          // mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Column(
                                              children: [
                                                LikeAnimation(
                                                  isAnimating:
                                                  widget.snap['likes'].contains(user?.uid),
                                                  smallLike: true,
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      await FireStoreMethods().likePost(
                                                          widget.snap['postId'].toString(),
                                                          widget.snap['uid'],
                                                          widget.snap['likes']);
                                                    },
                                                    icon: widget.snap['likes'].contains(user?.uid)
                                                        ? const Icon(
                                                      Icons.energy_savings_leaf,
                                                      color: Colors.green,
                                                    )
                                                        : const Icon(
                                                      Icons.energy_savings_leaf_outlined,
                                                    ),
                                                  ),
                                                ),
                                                Text('${widget.snap['likes'].length} ',
                                                    style: Theme.of(context).textTheme.bodyMedium),
                                              ],
                                              mainAxisSize: MainAxisSize.min,
                                            ),
                                            // SizedBox(width: 40,),
                                            Column(
                                              children: [
                                                IconButton(
                                                  onPressed: () =>
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => CommentsScreen(
                                                          snap: widget.snap,
                                                        ),
                                                      )),
                                                  icon: const Icon(
                                                    Icons.comment_outlined,
                                                  ),
                                                ),
                                                Text('$commentLen')
                                              ],
                                            ),
                                            // SizedBox(width: 40,),
                                            Column(
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.share,
                                                  ),
                                                ),
                                                Text('Share')
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      //TODO:This onTap function is temporary till backend is not connected at user side


                                      Text(
                                        DateFormat.yMMMd()
                                            .format(widget.snap['datePublished'].toDate()),
                                        style:
                                        const TextStyle(fontSize: 16, color: Colors.blueGrey),
                                      ),

                                      SizedBox(
                                        height: 5,
                                      ),




                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),

                ),
                Row(
                  children: [
                    Divider(thickness: 5,),
                    Text('data'),
                    Divider(thickness: 5,),
                  ],
                ),


                Container(

                  child:
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(25)
                    ),
                    elevation: 15,
                    // You can change the color here
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(radius: 30,),
                          title: Text('Username'),
                          subtitle: Text('Location'),
                          trailing: Text('Muncipal Corporation'),
                        ),
                        Divider(height: 1,thickness: 5,),


                        //DESCRIPTION OF POST
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: '',
                                ),
                              ],
                            ),
                          ),
                        ),
                        //IMAGE SECTION
                        GestureDetector(
                          onDoubleTap: () async {

                            setState(() {
                              isLikeAnimating2 = true;
                            });
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(

                                    color: Colors.grey.shade300,
                                height: 300,
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: (image != null)?Image.file(File(image!.path)):Container(decoration: BoxDecoration(image:DecorationImage(image: NetworkImage('https://www.google.com/imgres?imgurl=https%3A%2F%2Fstatic.toiimg.com%2Fphoto%2Fimgsize-308576%2Cmsid-90526453%2F90526453.jpg&tbnid=tLjjYVTnNH42QM&vet=12ahUKEwiA_NqPiZiCAxUkm2MGHSCJBXYQMygEegQIARBY..i&imgrefurl=https%3A%2F%2Fbangaloremirror.indiatimes.com%2Fbangalore%2Fcivic%2Fdrive-for-clean-streets%2Farticleshow%2F90526474.cms&docid=54zogJ8huS8oAM&w=1200&h=900&q=waste%20cleaning&ved=2ahUKEwiA_NqPiZiCAxUkm2MGHSCJBXYQMygEegQIARBY'))),)
                              ),
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: isLikeAnimating2 ? 1 : 0,
                                child: LikeAnimation(
                                  isAnimating: isLikeAnimating2,
                                  duration: const Duration(
                                    milliseconds: 200,
                                  ),
                                  onEnd: () {
                                    setState(() {
                                      isLikeAnimating2 = false;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.energy_savings_leaf,
                                    color: Colors.greenAccent,
                                    size: 100,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),



                        //LIKE COMMENT SECTION
                        Row(
                          children: <Widget>[
                            LikeAnimation(
                              isAnimating: widget.snap['likes'].contains(user?.uid),
                              smallLike: true,
                              child: IconButton(
                                onPressed: () async {
                                  await FireStoreMethods().likePost(
                                      widget.snap['postId'].toString(),
                                      widget.snap['uid'],
                                      widget.snap['likes']);
                                },
                                icon: widget.snap['likes'].contains(user?.uid)
                                    ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                                    : const Icon(
                                  Icons.favorite_border_outlined,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CommentsScreen(
                                  snap: widget.snap,
                                ),
                              )),
                              icon: const Icon(
                                Icons.comment_outlined,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.share,
                              ),
                            ),

                          ],
                        ),



                        // DESCRIPTON AND NUMBER OF COMMENTS
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DefaultTextStyle(
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.w800),
                                child: Text('${widget.snap['likes'].length} likes',
                                    style: Theme.of(context).textTheme.bodyMedium),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                ),
                              ),
                              // InkWell(
                              //   onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => CommentsScreen(
                              //       snap: widget.snap,
                              //     ),
                              //   )),
                              //   child: Container(
                              //     padding: const EdgeInsets.symmetric(vertical: 4),
                              //     child: Text(
                              //       'View all $commentLen comments',
                              //       style: const TextStyle(
                              //         fontSize: 16,
                              //         color: Colors.blueGrey,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  formatter.format(now).toString(),
                                  style:
                                  const TextStyle(fontSize: 16, color: Colors.blueGrey),
                                ),
                              ),
                              // ElevatedButton(onPressed: (){_issuesolvedreply(context);}, child: Text('Issue Solved'),style: ButtonStyle(),)
                            ],
                          ),
                        ),
                      ],
                    ),

                  ),
                )

                        ]
                    ),


                ),



            ),



    );
  }


  void _showDeleteDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Delete Content"),
          content: Text("Are you sure you want to delete this content?"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text("Delete"),
              isDestructiveAction: true,
              onPressed: () async {
                // showDialogBox(context);
                if (FirebaseAuth.instance.currentUser != null) {
                  FireStoreMethods().deletePost(widget.snap['postId']);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();

                }
              },
            ),
          ],
        );
      },
    );
  }


}
