import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrec/Utils/connector.dart';
import 'package:medrec/Utils/routes.dart';
import 'package:web3dart/web3dart.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController address = TextEditingController();
  TextEditingController privateKey = TextEditingController();
  TextEditingController role = TextEditingController();
  bool adding = false;

  void _showPicker(BuildContext ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        CupertinoIcons.person_circle,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Patient',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onPressed: () {
                    role.text = "Patient";
                    setState(() {});
                    Navigator.pop(context);
                  }),
              CupertinoActionSheetAction(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        FontAwesomeIcons.userDoctor,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Doctor',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onPressed: () {
                    role.text = "Doctor";
                    setState(() {});
                    Navigator.pop(context);
                  })
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  void moveToHome() async {
    bool result;
    if (_formKey.currentState!.validate()) {
      adding = true;
      setState(() {});
      if (role.text == "Patient") {
        try {
          result = await Connector.logInPatient(address.text, privateKey.text);
          if (!result) {
            Fluttertoast.showToast(msg: "Wrong credentials");
            setState(() {
              adding = false;
            });
          } else {
            Fluttertoast.showToast(msg: "Login Success");
            Connector.address = EthereumAddress.fromHex(address.text);
            Connector.key = privateKey.text;
            await Navigator.pushReplacementNamed(
                context, MyRoutes.patientHomePage);
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Oops! Something went wrong. Try Again...");
          setState(() {
            adding = false;
          });
        }
        adding = false;
      } else if (role.text == "Doctor") {
        try {
          // Fixed: Changed from logInPatient to logInDoctor
          result = await Connector.logInDoctor(address.text, privateKey.text);
          if (!result) {
            Fluttertoast.showToast(msg: "Wrong credentials");
            setState(() {
              adding = false;
            });
          } else {
            Fluttertoast.showToast(msg: "Login Success");
            Connector.address = EthereumAddress.fromHex(address.text);
            Connector.key = privateKey.text;
            await Navigator.pushReplacementNamed(
                context, MyRoutes.doctorHomePage);
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Oops! Something went wrong. Try Again...");
          setState(() {
            adding = false;
          });
        }
        adding = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).canvasColor,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100)),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3,
                          child: Image.asset(
                            "assets/images/welcomeImage.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Text(
                      "Sign-In",
                      style: GoogleFonts.lato(
                          fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
                    child: CupertinoFormSection(
                      backgroundColor: Colors.transparent,
                      children: [
                        CupertinoFormRow(
                          child: CupertinoTextFormFieldRow(
                            style: GoogleFonts.poppins(),
                            controller: address,
                            placeholder: "Enter your Ethereum Address",
                            prefix: Text(
                              "Address      ",
                              style: Theme.of(context).textTheme.caption,
                            ),
                            padding: const EdgeInsets.only(left: 0),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Address can't be empty";
                              }
                              return null;
                            },
                          ),
                        ),
                        CupertinoFormRow(
                          child: CupertinoTextFormFieldRow(
                            style: GoogleFonts.poppins(),
                            controller: privateKey,
                            placeholder: "Enter your private key",
                            prefix: Text(
                              "Key      ",
                              style: Theme.of(context).textTheme.caption,
                            ),
                            padding: const EdgeInsets.only(left: 0),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Key can't be empty";
                              }
                              return null;
                            },
                          ),
                        ),
                        CupertinoTextFormFieldRow(
                          style: GoogleFonts.poppins(),
                          controller: role,
                          onTap: () => _showPicker(context),
                          placeholder: "Tap to Show Roles",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Role can't be empty";
                            }
                            return null;
                          },
                          decoration: const BoxDecoration(color: Colors.white),
                          prefix: Text(
                            "Role            ",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: adding
                        ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: CupertinoActivityIndicator(
                          radius: 20,
                        ),
                      ),
                    )
                        : Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () => moveToHome(),
                          icon: const Icon(Icons.send_outlined),
                          iconSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}