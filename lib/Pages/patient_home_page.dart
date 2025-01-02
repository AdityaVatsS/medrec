import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medrec/Utils/connector.dart';
import 'package:medrec/Utils/routes.dart';
import 'package:web3dart/web3dart.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({Key? key}) : super(key: key);

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  TextEditingController doctorAddressController = TextEditingController();
  bool showLoading = false;
  List<dynamic> prescriptions = [];

  void addAuthorization(String doctorAddress) async {
    if (doctorAddress.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter doctor's address");
      return;
    }
    setState(() {
      showLoading = true;
    });
    try {
      bool result = await Connector.addAuthorization(
          EthereumAddress.fromHex(doctorAddress),
          Connector.address,
          Connector.key);
      if (result) {
        Fluttertoast.showToast(msg: "Authorization Added Successfully!");
        doctorAddressController.clear();
      } else {
        Fluttertoast.showToast(msg: "Something went wrong!");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
    setState(() {
      showLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        showLoading = true;
      });
      try {
        // Using getMedicalRecords instead of getPrescriptionList
        prescriptions = await Connector.getMedicalRecords(Connector.address);
      } catch (e) {
        Fluttertoast.showToast(msg: "Unable to fetch medical records!");
      }
      setState(() {
        showLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
        child: SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
    Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height / 8,
    padding: const EdgeInsets.all(8),
    decoration: const BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.only(
    topLeft: Radius.circular(0),
    bottomLeft: Radius.circular(50),
    topRight: Radius.circular(0),
    bottomRight: Radius.circular(50),
    ),
    ),
    child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
    Icon(
    CupertinoIcons.person_circle,
    color: Colors.white,
    size: 40,
    ),
    VerticalDivider(
    color: Colors.white,
    ),
    Text(
    'Patient Panel',
    style: TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: Colors.white),
    ),
    ],
    ),
    ),
    Padding(
    padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Container(
    width: MediaQuery.of(context).size.width * 0.7,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.green.shade50,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    blurRadius: 7,
    offset: const Offset(0, 3),
    ),
    ],
    ),
    child: Center(
    child: Text(
    "${Connector.address} (${DateTime.now().toString().substring(0, 16)})",
    style: TextStyle(
    fontSize: (MediaQuery.of(context).size.width * 0.02),
    fontWeight: FontWeight.bold,
    color: Colors.green),
    ),
    ),
    ),
    const SizedBox(width: 10),
    InkWell(
    onTap: () {
    Connector.key = "";
    Navigator.popAndPushNamed(context, MyRoutes.loginPage);
    },
    child: Container(
    width: MediaQuery.of(context).size.width * 0.2,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.red.shade50,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    blurRadius: 7,
    offset: const Offset(0, 3),
    ),
    ],
    ),
    child: Center(
    child: Text(
    "Logout",
    style: TextStyle(
    fontSize:
    (MediaQuery.of(context).size.width * 0.02),
    color: Colors.red),
    ),
    ),
    ),
    ),
    ],
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
    padding: const EdgeInsets.only(bottom: 16, top: 8),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(50),
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    blurRadius: 7,
    offset: const Offset(0, 3),
    ),
    ],
    ),
    child: Column(
    children: [
    Center(
    child: Container(
    width: 300,
    height: 50,
    padding: const EdgeInsets.all(8),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: const [
    Icon(
    FontAwesomeIcons.userDoctor,
    color: Colors.black,
    size: 25,
    ),
    VerticalDivider(
    color: Colors.black,
    thickness: 1,
    ),
    Text(
    'Authorize Doctor',
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black),
    ),
    ],
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: CupertinoFormSection(
    children: [
    CupertinoFormRow(
    child: CupertinoTextFormFieldRow(
    controller: doctorAddressController,
    placeholder: "Enter Doctor's Address",
    padding: const EdgeInsets.only(left: 0),
    validator: (value) {
    if (value!.isEmpty) {
    return "Address cannot be empty.";
    }
    return null;
    },
    enableSuggestions: true,
    prefix: Text(
    'Address  | ',
    style: Theme.of(context).textTheme.caption,
    ),
    ),
    ),
    ],
    ),
    ),
    Center(
    child: GestureDetector(
    onTap: () =>
    addAuthorization(doctorAddressController.text),
    child: Container(
    width: 100,
    height: 40,
    decoration: BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    blurRadius: 7,
    offset: const Offset(0, 3),
    ),
    ],
    ),
    child: const Center(
    child: Text(
    "Add",
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold),
    ),
    ),
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    Center(
    child: Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    padding: const EdgeInsets.all(8),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
    Icon(
    FontAwesomeIcons.timeline,
    color: Colors.black,
    size: 25,
    ),
    Padding(
    padding: EdgeInsets.all(8.0),
    child: VerticalDivider(
    color: Colors.black,
    thickness: 1,
    ),
    ),
    Text(
    'Medical History',
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black),
    ),
    ],
    ),
    ),
    ),
          showLoading == false && prescriptions.isNotEmpty
              ? ListView.builder(
            itemCount: prescriptions.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    MyRoutes.medicalRecordPage,
                    arguments: {
                      'record': prescriptions[index],
                      'index': index + 1,
                      'timestamp': '2025-01-02 22:09:48',
                      'user': 'AdityaVatsS'
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Record ${index + 1}",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )
              : showLoading
              ? const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: CupertinoActivityIndicator(
                radius: 20,
              ),
            ),
          )
              : Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  const Icon(
                    Icons.history,
                    size: 100,
                    color: Colors.grey,
                  ),
                  Text(
                    "No Records Found",
                    style: TextStyle(
                        fontSize: 20, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Last updated: 2025-01-02 22:09:48 UTC\nLogged in as: AdityaVatsS",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
        ),
        ),
        ),
    );
  }
}