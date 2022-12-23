import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/web3dart.dart';

class EthereumUtils {
  late Web3Client ethClient;
  late http.Client httpClient;
  final contractAddress = dotenv.env['FIRST_COIN_CONTRACT_ADDRESS'];

  void initialSetup() {
    httpClient = http.Client();
    String infura = 'https://goerli.infura.io/v3/${dotenv.env['API_KEY']}';
    ethClient = Web3Client(infura, httpClient);
  }

  Future getBalance() async {
    List<dynamic> result = await query("getBalance", []);
    return result[0];
  }

  Future<String> depositCoin(int amount) async {
    var bigAmount = BigInt.from(amount);
    var response = await submit("deposit", [bigAmount]);
    return response;
  }

  Future<String> withdrawCoin(int amount) async {
    var bigAmount = BigInt.from(amount);
    var response = await submit("withdraw", [bigAmount]);
    return response;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await getDeployedContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credential =
        EthPrivateKey.fromHex(dotenv.env['METAMASK_PRIVATE_KEY']!);
    DeployedContract contract = await getDeployedContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credential,
        Transaction.callContract(
            contract: contract,
            function: ethFunction,
            parameters: args,
            maxGas: 100000),
        chainId: 5);
    return result;
  }

  Future<DeployedContract> getDeployedContract() async {
    String abi = await rootBundle.loadString('assets/abi.json');
    final contract = DeployedContract(ContractAbi.fromJson(abi, 'FirstCoin'),
        EthereumAddress.fromHex(contractAddress!));
    return contract;
  }
}
