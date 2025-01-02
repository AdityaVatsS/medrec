import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class Connector {
  // Updated Configuration - 2025-01-02 22:33:04 by AdityaVatsS
  static const String _rpcUrl = "https://sepolia.infura.io/v3/c5eae67122c9493cbac3c4a1763cc20f";
  static const String _wsUrl = "wss://sepolia.infura.io/ws/v3/c5eae67122c9493cbac3c4a1763cc20f";
  static const String _privateKey = "0x356473704f02011023fb98ee03619272da162e66";
  static const String CONTRACT_ADDRESS = "YOUR_DEPLOYED_CONTRACT_ADDRESS"; // Update this after deployment

  // Metadata
  static const String _lastUpdated = "2025-01-02 22:33:04";
  static const String _updatedBy = "AdityaVatsS";
  static const String _defaultAddress = "0x356473704f02011023fb98ee03619272da162e66";

  // Web3 Client
  static late Web3Client _client;

  // Contract Details
  static late String _abiCode;
  static late EthereumAddress _contractAddress;
  static late DeployedContract _contract;
  static late Credentials _credentials;

  // Contract Functions
  static late ContractFunction _addPatient;
  static late ContractFunction _addDoctor;
  static late ContractFunction _loginPatient;
  static late ContractFunction _loginDoctor;
  static late ContractFunction _addPrescription;
  static late ContractFunction _getPrescriptions;
  static late ContractFunction _addAuthorization;
  static late ContractFunction _getMedicalRecords;
  static late ContractFunction _updateDoctorFee;
  static late ContractFunction _getDoctorFee;

  // Public Variables
  static EthereumAddress? address = EthereumAddress.fromHex(_defaultAddress);
  static String key = _privateKey;

  // Initialize Web3 Client
  static Future<void> init() async {
    try {
      _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      });

      await getAbi();
      await getCredentials();
      await getDeployedContract();

      print('Web3 Client Initialized - $_lastUpdated by $_updatedBy');
    } catch (e) {
      print('Error initializing Web3 Client: $e');
      rethrow;
    }
  }

  // Get ABI
  static Future<void> getAbi() async {
    try {
      String abiStringFile = await rootBundle.loadString("src/abis/MedRec.json");
      var jsonAbi = jsonDecode(abiStringFile);
      _abiCode = jsonEncode(jsonAbi["abi"]);
      _contractAddress = EthereumAddress.fromHex(CONTRACT_ADDRESS);
    } catch (e) {
      print('Error loading ABI: $e');
      rethrow;
    }
  }

  // Get Credentials
  static Future<void> getCredentials() async {
    try {
      _credentials = EthPrivateKey.fromHex(_privateKey);
    } catch (e) {
      print('Error getting credentials: $e');
      rethrow;
    }
  }

  // Get Deployed Contract
  static Future<void> getDeployedContract() async {
    try {
      _contract = DeployedContract(
          ContractAbi.fromJson(_abiCode, "MedRec"), _contractAddress);

      // Initialize Contract Functions
      _addPatient = _contract.function("addPatient");
      _addDoctor = _contract.function("addDoctor");
      _loginPatient = _contract.function("loginPatient");
      _loginDoctor = _contract.function("loginDoctor");
      _addPrescription = _contract.function("addPrescription");
      _getPrescriptions = _contract.function("getPrescriptions");
      _addAuthorization = _contract.function("addAuthorization");
      _getMedicalRecords = _contract.function("getMedicalRecords");
      _updateDoctorFee = _contract.function("updateDoctorFee");
      _getDoctorFee = _contract.function("getDoctorFee");
    } catch (e) {
      print('Error getting deployed contract: $e');
      rethrow;
    }
  }

  // Test Connection
  static Future<bool> testConnection() async {
    try {
      await init();
      final blockNumber = await _client.getBlockNumber();
      print('Connected to Sepolia network');
      print('Current block number: $blockNumber');
      print('Last updated: $_lastUpdated');
      print('Updated by: $_updatedBy');
      return true;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  // Patient Functions
  static Future<bool> addPatient(EthereumAddress address, String key) async {
    try {
      await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _addPatient,
          parameters: [address],
        ),
      );
      return true;
    } catch (e) {
      print("Error in addPatient: $e");
      return false;
    }
  }

  static Future<bool> logInPatient(String address, String privateKey) async {
    try {
      final result = await _client.call(
        contract: _contract,
        function: _loginPatient,
        params: [EthereumAddress.fromHex(address)],
      );
      return result[0];
    } catch (e) {
      print("Error in logInPatient: $e");
      return false;
    }
  }

  // Doctor Functions
  static Future<bool> addDoctor(EthereumAddress address, String key) async {
    try {
      await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _addDoctor,
          parameters: [address],
        ),
      );
      return true;
    } catch (e) {
      print("Error in addDoctor: $e");
      return false;
    }
  }

  static Future<bool> logInDoctor(String address, String privateKey) async {
    try {
      final result = await _client.call(
        contract: _contract,
        function: _loginDoctor,
        params: [EthereumAddress.fromHex(address)],
      );
      return result[0];
    } catch (e) {
      print("Error in logInDoctor: $e");
      return false;
    }
  }

  // Medical Record Functions
  static Future<List<dynamic>> getMedicalRecords(EthereumAddress address) async {
    try {
      final result = await _client.call(
        contract: _contract,
        function: _getMedicalRecords,
        params: [address],
      );
      return result[0];
    } catch (e) {
      print("Error in getMedicalRecords: $e");
      return [];
    }
  }

  // Authorization Functions
  static Future<bool> addAuthorization(
      EthereumAddress doctorAddress, EthereumAddress patientAddress, String key) async {
    try {
      await _client.sendTransaction(
        EthPrivateKey.fromHex(key),
        Transaction.callContract(
          contract: _contract,
          function: _addAuthorization,
          parameters: [doctorAddress],
        ),
      );
      return true;
    } catch (e) {
      print("Error in addAuthorization: $e");
      return false;
    }
  }

  // Prescription Functions
  static Future<bool> addPrescription(
      EthereumAddress patientAddress, String prescription, String key) async {
    try {
      await _client.sendTransaction(
        EthPrivateKey.fromHex(key),
        Transaction.callContract(
          contract: _contract,
          function: _addPrescription,
          parameters: [patientAddress, prescription],
        ),
      );
      return true;
    } catch (e) {
      print("Error in addPrescription: $e");
      return false;
    }
  }

  // Fee Management Functions
  static Future<String> updateDoctorFee(
      EthereumAddress doctorAddress, String key, String amount) async {
    try {
      await _client.sendTransaction(
        EthPrivateKey.fromHex(key),
        Transaction.callContract(
          contract: _contract,
          function: _updateDoctorFee,
          parameters: [BigInt.parse(amount)],
        ),
      );
      return amount;
    } catch (e) {
      print("Error in updateDoctorFee: $e");
      return "";
    }
  }

  static Future<String> getFee(EthereumAddress doctorAddress) async {
    try {
      final result = await _client.call(
        contract: _contract,
        function: _getDoctorFee,
        params: [doctorAddress],
      );
      return result[0].toString();
    } catch (e) {
      print("Error in getFee: $e");
      return "";
    }
  }

  // Utility Functions
  static String getLastUpdated() => _lastUpdated;
  static String getUpdatedBy() => _updatedBy;
  static String getDefaultAddress() => _defaultAddress;
}