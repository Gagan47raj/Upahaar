import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:users1/global/global.dart';
import 'package:users1/models/donars.dart';
import 'package:users1/models/posts.dart';
import 'package:users1/widgets/app_bar.dart';
import 'package:users1/widgets/donars_design.dart';
import 'package:users1/widgets/my_drawer.dart';
import 'package:users1/widgets/posts_design.dart';
import 'package:users1/widgets/text_widget_header.dart';
import 'package:users1/widgets/progress_bar.dart';

class PostsScreen extends StatefulWidget {
  final Donars? model;
  PostsScreen({this.model});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(donarUID: widget.model!.donarsUID),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(
                  title: widget.model!.donarsName.toString() + " Menus")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("donars")
                .doc(widget.model!.donarsUID)
                .collection("posts")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgress(),
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        Posts model = Posts.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        return PostsDesignWidget(
                          model: model,
                          context: context,
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          ),
        ],
      ),
    );
  }
}
