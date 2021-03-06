import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social/UI/constants.dart';
import 'package:social/UI/helpers/scrollable_list_mixin.dart';
import 'package:social/UI/helpers/showList.dart';
import 'package:social/UI/screens/home.dart';
import 'package:social/UI/widgets/story.dart';
import 'package:social/UI/widgets/text_field.dart';
import 'package:social/bloc/scroll_to_top_bloc.dart';
import 'package:social/bloc/scrollable_list_bloc/scrollable_list_bloc.dart';
import 'package:social/data/api_providers/api_constants.dart';
import 'package:social/data/api_providers/base_list_provider.dart';
import 'package:social/data/models/post.dart';
import 'package:social/data/pagination.dart';

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> with ScrollableListMixin {
  @override
  void initState() {
    super.initState();
    bloc = ScrollableListBloc(
      provider: BaseListProvider(
        paginator: Paginator(url: postListUrl),
        listFromJson: PostModel.listFromJson,
      ),
    )..add(LoadList());
    initScrollableList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer(
        bloc: bloc,
        listener: (context, state) {
          if (state is ListLoaded) {
            completeCompleter();
          }
        },
        builder: (context, state) {
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
            body: RefreshIndicator(
              onRefresh: () {
                bloc.add(RefreshList());
                return completerFuture();
              },
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 15),
                child: BlocListener<ScrollToTopBloc, ScrollToTopState>(
                  listener: (context, state) {
                    if (state is ScrolledToTop && state.item == TabItem.posts) {
                      animateScroll();
                    }
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: getScrollController(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: 20, bottom: 10, left: 5, right: 5),
                          child: Row(
                            children: [
                              Expanded(child: CustomTextField()),
                            ],
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          child: Text(
                            'Stories',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: getStories(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 14),
                          child: Divider(
                            height: 4,
                            color: Colors.black,
                          ),
                        ),
                        showList(state, ScrollableType.posts),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> getStories() {
    return [
      Story(
        image: 'assets/stories/story1.jpg',
      ),
      Story(
        image: 'assets/stories/story2.jpg',
      ),
      Story(
        image: 'assets/stories/story3.jpg',
      ),
      Story(
        image: 'assets/stories/story4.jpg',
      ),
      Story(
        image: 'assets/stories/story5.jpg',
      ),
    ];
  }
}
