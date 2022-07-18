import 'package:flutter/material.dart';
import 'package:meme_hub/responsive/widgets.dart';

class DesktopBody extends StatelessWidget {
  const DesktopBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('DESKTOP',
          style: TextStyle(letterSpacing: 1.8),),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: 16 / 8,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),),
                Expanded(
                    child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),);
                        }))
                          ],
                        ),
                      ),
          Container(
            margin: const EdgeInsets.all(10),
            width: 400,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),),)
        ],
      ),


    );
  }
}
