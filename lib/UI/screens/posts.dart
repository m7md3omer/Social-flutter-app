import 'package:flutter/material.dart';
import 'package:social/bloc/scroll_bloc/scroll_to_top_bloc.dart';
import 'package:social/UI/constants.dart';
import 'package:social/UI/screens/home.dart';
import 'package:social/UI/widgets/post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    print('rebuilding posts');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add post',
        backgroundColor: mediumBlue,
        child: Icon(Icons.add),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', null);
          // Navigator.pushNamed(context, '/add_post');
        },
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10, top: 15),
        child: BlocListener<ScrollToTopBloc, ScrollToTopState>(
          listener: (context, state) {
            if (state is ScrolledToTop && state.item == TabItem.posts) {
              _scrollController.animateTo(0,
                  duration: Duration(seconds: 1), curve: Curves.ease);
            }
          },
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              PostItem(
                clickable: true,
                post: {
                  'name': 'post1',
                  'image': 'post1.jpg',
                  'body':
                      'lorem ipsum dolor set lorem ipsum dolor set lorem ipsum dolor set lorem ipsum dolor set'
                },
              ),
              PostItem(
                clickable: true,
                post: {
                  'name': 'post2',
                  'image': 'post2.jpg',
                  'body':
                      'lorem ipsum dolor set lorem ipsum dolor set lorem ipsum dolor set lorem ipsum dolor set'
                },
              ),
              PostItem(
                clickable: true,
                post: {
                  'name': 'post3',
                  'image': 'post3.jpg',
                  'body':
                      'lorem ipsum dolor set lorem ipsum dolor set lorem ipsum dolor set lorem ipsum dolor set',
                },
              ),
              PostItem(
                clickable: true,
                post: {
                  'name': 'post4',
                  'image': 'post4.jpg',
                  'body':
                      'lorem ipsum dolor set lorem ipsum dolor set lorem ipsum dolor set lorem ipsum dolor set'
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}