import 'dart:ui';
import 'package:meme_hub/config/palette.dart';
import 'package:meme_hub/models/models.dart';
import 'package:meme_hub/services/services.dart';
import 'package:meme_hub/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:meme_hub/constants.dart';
import 'package:meme_hub/responsive/widgets.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({Key? key}) : super(key: key);

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;

  //Get all posts
  Future<void> retrievePosts() async{
    userId = await getUserId();
    ApiResponse response = await getPosts();

    if(response.error == null){
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const SignInMobileScreen()), (route) => false),
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}'),));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  void _handlePostLikeDislike(int postId) async{
    ApiResponse response = await likeUnlikePost(postId);

    if(response.error == null){
      retrievePosts();
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const SignInMobileScreen()), (route) => false),
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}'),));

    }
  }

  void _handlePostDelete(int postId) async{
    ApiResponse response = await deletePost(postId);

    if(response.error == null){
      retrievePosts();
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const SignInMobileScreen()), (route) => false),
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}'),));

    }
  }

  @override
  void initState(){
    retrievePosts();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return _loading ? const Center(
      child: CircularProgressIndicator(),) :
    RefreshIndicator(
      onRefresh: (){
        return retrievePosts();
      },
      child: ListView.builder(
        itemCount: _postList.length,
          itemBuilder: (BuildContext context, int index){
          Post post = _postList[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            image: post.user!.image != null ?
                                DecorationImage(image: NetworkImage('${post.user!.image}')) : null,
                            borderRadius: BorderRadius.circular(25),
                            color: Palette.nestBlue,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Text('${post.user!.name}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),)
                      ],
                    ),),

                    post.user!.id == userId ?
                    PopupMenuButton(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.more_vert_rounded, color: Colors.black,),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: const [
                                Text('Edit',
                                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),),
                                SizedBox(width: 5,),
                                Icon(Icons.edit, size: 18, color: Colors.black,)
                              ],
                            ),
                            value: 'edit',
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: const [
                                Text('Delete',
                                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),),
                                SizedBox(width: 5,),
                                Icon(Icons.delete, size: 18, color: Colors.black,)
                              ],
                            ),
                            value: 'delete',
                          ),
                        ],
                      onSelected: (val){
                          if(val == 'edit'){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MobileUploadPage(
                              title: 'Edit Post', post: post,)));

                          }else{
                            _handlePostDelete(post.id ?? 0);
                          }
                      },
                    ): const SizedBox()
                  ],
                ),
                const SizedBox(height: 12,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Text('${post.body}'),
                ),
                post.image != null ?
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 25,
                        sigmaY: 17,
                      ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      margin: const EdgeInsets.only(top: 5, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(width: 1.5, color: Colors.white.withOpacity(0.2)),
                          image: DecorationImage(
                              image: NetworkImage('${post.image}'),
                              fit: BoxFit.cover
                          )),
                    ),
                  )
                ) : SizedBox(height: post.image != null ? 0 : 10,),
                Row(
                  children: [
                    likeAndComment(
                        post.likesCount ?? 0,
                        post.selfLiked == true ? Icons.favorite : Icons.favorite_outline_outlined,
                        post.selfLiked == true ? Colors.red : Colors.black38,
                        (){
                          _handlePostLikeDislike(post.id ?? 0);
                        }),
                    Container(
                      height: 25,
                      width: 0.5,
                      color: Colors.black38,
                    ),
                    likeAndComment(
                        post.commentsCount ?? 0,
                        Icons.sms_outlined,
                        Colors.black54,
                        (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MobileCommentsPage(
                            postId: post.id,
                          )));                        },)
                  ],
                ),
                Container(
                  height: 0.5,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black26,
                ),
              ],
            ),
          );
          }),
    );
  }
}
