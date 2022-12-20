import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF69A03A),
        title: Transform(
          // you can forcefully translate values left side using Transform
          transform: Matrix4.translationValues(-30.0, 17.0, 0.0),
          child: Text(
            "Help",
            style: TextStyle(
              fontFamily: "poppins",
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        leading: Transform(
          // you can forcefully translate values left side using Transform
          transform: Matrix4.translationValues(0.0, 20.0, 0.0),
          child: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              size: 21,
            ),
            onTap: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 20,
              color: Color(0xFF69A03A),
            ),
            SizedBox(height: 30),
            Text(
              """
    Lorem Ipsum is simply dummy text of the printing 
and typesetting industry. Lorem Ipsum has been 
the industry’s standard dummy text ever since the 
1500s, when an unknown printer took a galley of 
type and scrambled it to make a type specimen 
book. It has survived not only five centuries, but 
also the leap into electronic typesetting, remaining 
essentially unchanged. It was popularised in the 
1960s with the release of Letraset sheets containing 
Lorem Ipsum passages, and more recently with 
desktop publishing software like Aldus PageMaker 
including versions of Lorem Ipsum.
Lorem Ipsum is simply dummy text of the printing 
and typesetting industry. Lorem Ipsum has been 
the industry’s standard dummy text ever since the 
1500s, when an unknown printer took a galley of 
type and scrambled it to make a type specimen 
book. It has survived not only five centuries, but 
also the leap into electronic typesetting, remaining 
essentially unchanged. It was popularised in the 
1960s with the release of Letraset sheets containing 
Lorem Ipsum passages, and more recently with 
desktop publishing software like Aldus PageMaker 
including versions of Lorem Ipsum.
            """,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: "poppins",
                fontSize: 14,
              ),
            ),
            Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                // color: Colors.amber,
                child: Image.asset(
                  "assets/image_home/bottombar.png",
                  fit: BoxFit.fitWidth,
                )),
          ],
        ),
      ),
    );
  }
}
