import 'dart:ui';
import 'package:meme_hub/config/palette.dart';
import 'package:meme_hub/models/models.dart';
import 'package:meme_hub/services/services.dart';
import 'package:meme_hub/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:meme_hub/constants.dart';
import 'package:meme_hub/responsive/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MobileCommentsPage extends StatefulWidget {
  const MobileCommentsPage({Key? key, this.postId}) : super(key: key);

  final int? postId;

  @override
  State<MobileCommentsPage> createState() => _MobileCommentsPageState();
}

class _MobileCommentsPageState extends State<MobileCommentsPage> {
  List<dynamic> _commentsList = [];
  bool _loading = true;
  int userId = 0;
  int _editCommentId = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();


  //Get all comments
  Future<void> _getComments() async{
    userId = await getUserId();
    ApiResponse response = await getComments(widget.postId ?? 0);

    if(response.error == null){
      setState(() {
        _commentsList = response.data as List<dynamic>;
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

    }
  }

  //Create comment
  void _createComment() async{
    ApiResponse response = await createComments(widget.postId ?? 0, _txtControllerBody.text);

    if(response.error == null){
      _txtControllerBody.clear();
      _getComments();
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

  //Edit comment
  void _editComment() async{
    ApiResponse response = await editComment(_editCommentId, _txtControllerBody.text);

    if(response.error == null){
      _editCommentId = 0;
      _txtControllerBody.clear();
      _getComments();
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

  //Delete comment
  void _deleteComment(int commentId) async{
    ApiResponse response = await deleteComment(commentId);

    if(response.error == null){
      _getComments();
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
  void initState() {
    _getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Palette.nestBlue),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        centerTitle: false,
        title: const Text('Comments', style: TextStyle(color: Palette.nestBlue, fontSize: 18,),),

      ),
      body: _loading ? const Center(child: CircularProgressIndicator(),) :
          Column(
            children: [
              Expanded(
                  child: RefreshIndicator(
                    onRefresh: (){
                      return _getComments();
                    },
                    child: ListView.builder(
                      itemCount: _commentsList.length,
                        itemBuilder: (BuildContext context, int index){
                          Comment comment = _commentsList[index];
                          return Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.black26, width: 0.5),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            image: comment.user!.image != null ? DecorationImage(
                                                image: NetworkImage('${comment.user!.image}'),
                                            fit: BoxFit.cover) : null,
                                            borderRadius: BorderRadius.circular(20),
                                            color: Palette.nestBlue
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        Text('${comment.user!.name}', style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),

                                      ],
                                    ),
                                    comment.user!.id == userId ?
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
                                          setState(() {
                                            _editCommentId = comment.id ?? 0;
                                            _txtControllerBody.text = comment.comment ?? '';
                                          });
                                        }else{
                                          _deleteComment(comment.id ?? 0);
                                        }
                                      },
                                    ): const SizedBox()
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, bottom: 5),
                                  child: Text('${comment.comment}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic),),
                                ),
                              ],
                            ),
                          );
                        }),
                  )),

              Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      style: const TextStyle(color: Palette.scaffold),
                      controller: _txtControllerBody,
                      keyboardType: TextInputType.multiline,
                      validator: (val) => val!.isEmpty ? 'Caption is required' : null,
                      //maxLines: 9,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          FontAwesomeIcons.facebookMessenger,
                          color: Palette.scaffold,),
                        hintText: "  Caption",
                        hintStyle: const TextStyle(fontSize: 16.0, color: Palette.scaffold),
                        suffixIcon: InkWell(
                          onTap: (){
                            if(_formKey.currentState!.validate()){
                              setState(() {
                                _loading = true;
                              });
                              if(_editCommentId > 0){
                                _editComment();
                              }else{
                                _createComment();
                              }

                            }
                          },
                          child: const Icon(FontAwesomeIcons.paperPlane,
                              color: Palette.scaffold),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Palette.scaffold,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                          borderSide: const BorderSide(
                            color: Palette.scaffold,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          )
    );
  }
}
