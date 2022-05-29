import 'package:flutter/material.dart';
class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 5), (){
      Navigator.pushReplacementNamed(context, '/Note_Screen');
    });
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9FCFF),
      ),
      home: Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [ const Center(
              child: Image(
                image: AssetImage('images/first.PNG'),
                height: 200,
                width: 200,),
            ),
              SizedBox(),
              ElevatedButton(
                onPressed: () {Navigator.pushNamed(context, '/Note_Screen'); },
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontFamily:'OpenSans', ),
                    primary: const Color(0xFF1321e0),
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))
                ),
                child: const Text('Get Started', style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,),), ),]
        ),
      ),

    );
  }
}