// lib/utils/contract_config.dart

class ContractConfig {
  // Updated: 2025-01-02 22:36:53 by AdityaVatsS
  static const String NETWORK = "sepolia";
  static const String INFURA_PROJECT_ID = "c5eae67122c9493cbac3c4a1763cc20f";
  static const String RPC_URL = "https://sepolia.infura.io/v3/c5eae67122c9493cbac3c4a1763cc20f";
  static const String WS_URL = "wss://sepolia.infura.io/ws/v3/c5eae67122c9493cbac3c4a1763cc20f";

  // Your updated credentials
  static const String WALLET_ADDRESS = "0x356473704f02011023fb98ee03619272da162e66";
  static const String PRIVATE_KEY = "a977e554931bf7a1b1f305e84bcdde1df3ead5dad892f80a4a84f48c3077c3b3";
  static const String CONTRACT_ADDRESS = "YOUR_DEPLOYED_CONTRACT_ADDRESS"; // Will be updated after deployment

  // Metadata
  static const String LAST_UPDATED = "2025-01-02 22:36:53";
  static const String UPDATED_BY = "AdityaVatsS";

  static const Map<String, String> CONTRACT_FUNCTIONS = {
    'addPatient': 'function addPatient(address _patientAddress)',
    'addDoctor': 'function addDoctor(address _doctorAddress)',
    'loginPatient': 'function loginPatient(address _patientAddress) view returns (bool)',
    'loginDoctor': 'function loginDoctor(address _doctorAddress) view returns (bool)',
    'addPrescription': 'function addPrescription(address _patientAddress, string memory _prescription)',
    'getPrescriptions': 'function getPrescriptions(address _patientAddress) view returns (string[] memory)',
    'addAuthorization': 'function addAuthorization(address _doctorAddress)',
    'getMedicalRecords': 'function getMedicalRecords(address _patientAddress) view returns (string[] memory)',
    'updateDoctorFee': 'function updateDoctorFee(uint256 _fee)',
    'getDoctorFee': 'function getDoctorFee(address _doctorAddress) view returns (uint256)'
  };

  static const Map<String, String> NETWORKS = {
    'sepolia': '11155111',
    'mainnet': '1',
    'goerli': '5'
  };
}