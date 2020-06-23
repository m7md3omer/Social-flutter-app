import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/UI/constants.dart';
import 'package:social/UI/helpers/showList.dart';
import 'package:social/UI/widgets/post.dart';
import 'package:social/bloc/scrollable_list_bloc/scrollable_list_bloc.dart';
import 'package:social/data/api_providers/api_constants.dart';
import 'package:social/data/api_providers/base_list_provider.dart';
import 'package:social/data/models/comment.dart';
import 'package:social/data/models/post.dart';
import 'package:social/data/pagination.dart';

class PostDetails extends StatefulWidget {
  PostDetails({@required this.post});
  final PostModel post;
  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final _scrollController = ScrollController();
  ScrollableListBloc _bloc;
  Completer _completer;
  final _scrollThreshold = 200.0;

  @override
  initState() {
    super.initState();
    _bloc = ScrollableListBloc(
      provider: BaseListProvider(
          paginator: Paginator(url: getCommentUrl(postId: widget.post.id)),
          listFromJson: CommentModel.listFromJson),
    )..add(LoadList());
    _scrollController.addListener(_onScroll);
    _completer = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          return Column(
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(Duration(seconds: 2));
                    return Completer().future;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: PostItem(
                            clickable: false,
                            post: widget.post,
                          ),
                        ),
                        showCommentList(state),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10, left: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Leave a comment...'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _bloc.add(LoadList());
    }
  }
}
