import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:strip_payment_test/const.dart';
import 'package:strip_payment_test/services/stripe_service.dart';

void main() async{
  await _setUp();
  runApp(const MyApp());
}
Future<void> _setUp() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey= stripPublishableKey;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:SizedBox.expand(child:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async{
                await StripeService.instance.makePayment(20);
              },
              child: Text('Payment \$20'),
            ),
            ElevatedButton(
              onPressed: () async{
                await StripeService.instance.makePayment(10);
              },
              child: Text('Payment \$10'),
            ),
            ElevatedButton(
              onPressed: () async{
                await StripeService.instance.makePayment(30);
              },
              child: Text('Payment \$30'),
            ),
          ],
        ),
      ),)
    );
  }
}
