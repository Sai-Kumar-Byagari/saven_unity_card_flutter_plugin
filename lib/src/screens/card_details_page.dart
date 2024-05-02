import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../utils/user_authentication.dart';
import '../services/api_service.dart';

enum CardDetailsApiStatus {
  initial,
  inProgress,
  success,
  failure,
}

class CardDetailsPage extends StatefulWidget {
  const CardDetailsPage({super.key});

  @override
  State<CardDetailsPage> createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage> {
  CardDetailsApiStatus cardDetailsApiStatus = CardDetailsApiStatus.initial;

  List<dynamic> unbilledTransactionsList = [];
  bool showAllTransactions = false;

  ValueNotifier<bool> showCvvNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> showCardNumberNotifier = ValueNotifier<bool>(true);

  final ApiService apiService = ApiService();

  String userName = "***";
  String cardNumber = "";
  bool isPinSetUp = false;
  String cardType = "";
  String networkType = "";
  String status = "";
  String cardBalance = "";
  String cardCvv = "";
  String kitNumber = "";
  String userDob = "";
  String expiryDate = "";

  String maskCardNumber(String cardNumber){
    if (cardNumber.length == 16) {
      String maskedNumber = "${cardNumber.substring(0,4)} XXXX XXXX ${cardNumber.substring(12,cardNumber.length)}";
      return maskedNumber;
    } else {
      return "Invalid card Number";
    }
  }

  String formatExpiryDate(String expiryDate){
    if (expiryDate.length == 4) {
      String formattedDate = "Expiry: ${expiryDate.substring(0,2)}/${expiryDate.substring(2,4)}";
      return formattedDate;
    } else {
      return "Invalid expiry date";
    }
  }

  Future<void> _getCardDetailsData(String? token) async {

    try{
      final response = await apiService.getCardDetails(token!);
      Map<String, dynamic> data = response.data;

      if(data['status'] == "success" && data['data'] != null){
        Map<String, dynamic> userDetails = data['data'];
        print(userDetails['name']);

        userName = userDetails['name'];
        cardNumber =  userDetails['cardNo'];
        kitNumber = userDetails['kitNo'];
        userDob = userDetails['dob'];
        expiryDate = userDetails['cardExpiry'];
      }else{
        setState(() {
          cardDetailsApiStatus = CardDetailsApiStatus.failure;
        });
      }
    }catch(error){
      setState(() {
        cardDetailsApiStatus = CardDetailsApiStatus.failure;
      });
    }
  }

  Future<void> _getCardBalanceData(String? token) async {

    try{
      final response = await apiService.getCardBalance(token!);
      Map<String, dynamic> data = response.data;

      if(data['status'] == "success" && data['data'] != null){
        cardBalance = data['data'][0]['balance'];
      }else{
        setState(() {
          cardDetailsApiStatus = CardDetailsApiStatus.failure;
        });
      }
    }catch(error){
      setState(() {
        cardDetailsApiStatus = CardDetailsApiStatus.failure;
      });
    }
  }

  Future<void> _getCvvData(String? token) async {
    try{
      final response = await apiService.getCvv(token!,kitNumber,userDob,expiryDate);
      Map<String, dynamic> data = response.data;

      if(data['status'] == "success" && data['data'] != null) {
        cardCvv = data['data']['cvv'].toString();
      }
    }catch(error){
      setState(() {
        cardDetailsApiStatus = CardDetailsApiStatus.failure;
      });
    }
  }

  Future<void> _getUnbilledTransactionsData(String? token) async {

    try{
      final response = await apiService.getUnbilledTransactions(token!);
      Map<String, dynamic> data = response.data;

      if(data['status'] == "success" && data['data'] != null) {
        List<dynamic> unbilledTransactionsListData = data['data'];
        List<dynamic> filteredUnbilledTransactionsList = unbilledTransactionsListData.sublist(0,unbilledTransactionsListData.length -1);
        unbilledTransactionsList = filteredUnbilledTransactionsList;
      }else{
        setState(() {
          cardDetailsApiStatus = CardDetailsApiStatus.failure;
        });
      }
    }catch(error){
      setState(() {
        cardDetailsApiStatus = CardDetailsApiStatus.failure;
      });
    }
  }

  String formatDate(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate);
    String formattedDate = DateFormat('MMMM dd, yyyy, hh:mm:ss a').format(dateTime);
    return formattedDate;
  }

  Widget _buildTransactionRow(String transactionType, String description, String transactionDate,int amount){
    final transactionIcon = transactionType == 'CREDIT' ? FontAwesomeIcons.circlePlus : FontAwesomeIcons.circleMinus;
    final transactionIconColor = transactionType == 'CREDIT' ? Colors.green : Colors.red;
    final String formattedExternalTransactionId;

    if(description.length > 27){
      String slicedExternalTransactionId = description.substring(0,26);
      formattedExternalTransactionId = slicedExternalTransactionId;
    }else{
      formattedExternalTransactionId = description;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(
                  transactionIcon,
                  size: 24,
                  color: transactionIconColor,
                ),
                const SizedBox(width: 13,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedExternalTransactionId,
                      style: const TextStyle(
                        fontFamily: 'primaryFont',
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      formatDate(transactionDate),
                      style: const TextStyle(
                        fontFamily: 'primaryFont',
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\u20B9 $amount",
                  style: const TextStyle(
                    fontFamily: 'primaryFont',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                // Text(
                //   "\u20B9 4.75",
                //   style: TextStyle(
                //     fontFamily: 'primaryFont',
                //     fontSize: 12,
                //     color: transactionIconColor,
                //   ),
                // ),
              ],
            ),
          ],
        ),
        const Divider(color: Color(0xFFe1e8e6),),
        const SizedBox(height: 10,),
      ],
    );
    // return ListView(
    //   children: [
    //       for (int i = 0;
    //       i < (showAllTransactions ? transactionsList.length : 5);
    //       i++)
    //         ListTile(
    //           leading: FaIcon(transactionsList[i]['icon']),
    //           title: Text(transactionsList[i]['day']),
    //           subtitle: Text(transactionsList[i]['subAmount']),
    //         ),
    //   ],
    // );
  }

  Widget _CardDetailsLoadingView(){
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFe96341)),
      ),
    );
  }

  Widget _CardDetailsSuccessView(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 250,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  height: 125,
                  child: Container(
                    color: const Color(0xFF404d6b),
                  )
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  height: 125,
                  child: Container(
                    color: Colors.white,
                  )
              ),
              Positioned(
                top: 30,
                right: 0,
                left: 0,
                child: Container(
                  height: 200,
                  margin: const EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xFFe96341),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 16, 18, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Current balance",
                              style: TextStyle(
                                fontFamily: 'primaryFont',
                                fontSize: 16,
                                color: Colors.white54,
                              ),
                            ),
                            Text(
                              "\u20B9 $cardBalance",
                              style: const TextStyle(
                                fontFamily: 'primaryFont',
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ValueListenableBuilder<bool>(
                                  valueListenable: showCardNumberNotifier,
                                  builder: (context, showCardNumber, _) {
                                    return Text(
                                      showCardNumber ? cardNumber : maskCardNumber(cardNumber),
                                      style: const TextStyle(
                                        fontFamily: 'primaryFont',
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ValueListenableBuilder<bool>(
                                          valueListenable: showCvvNotifier,
                                          builder: (context, showCvv, _) {
                                            return Text(
                                              showCvv ? "CVV: $cardCvv" : "CVV: XXX",
                                              style: const TextStyle(
                                                fontFamily: 'primaryFont',
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 8,),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showCvvNotifier.value = !showCvvNotifier.value;
                                              showCardNumberNotifier.value = !showCardNumberNotifier.value;
                                            });
                                          },
                                          child: Icon(
                                            showCvvNotifier.value ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10,),
                                    Text(
                                      formatExpiryDate(expiryDate),
                                      style: const TextStyle(
                                        fontFamily: 'primaryFont',
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 15),
                              width: 90,
                              height: 25,
                              child: const Image(image: AssetImage('packages/saven_unity_card_flutter_plugin/assets/images/VISA.png'))
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Transactions",
                            style: TextStyle(
                              fontFamily: 'primaryFont',
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Text(
                          //       "show all",
                          //       style: TextStyle(
                          //         fontFamily: 'primaryFont',
                          //         fontSize: 12,
                          //         color: Colors.black54,
                          //       ),
                          //     ),
                          //     Icon(
                          //       Icons.keyboard_arrow_right,
                          //       size: 25,
                          //       color: Colors.black54,
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Column(
                        children: unbilledTransactionsList.map((eachUnbilledTransaction) {
                          return _buildTransactionRow(
                              eachUnbilledTransaction['transactionType'],
                              eachUnbilledTransaction['description'],
                              eachUnbilledTransaction['transactionDate'],
                              eachUnbilledTransaction['amount']
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _CardDetailsFailureView(){
    return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Something went wrong. Retry ",
              style: TextStyle(
                fontFamily: 'primaryFont',
                fontSize: 16,
                color: Color(0xFFe96341),
              ),
            ),
            GestureDetector(
              onTap: (){
                null;
              },
              child: const Icon(
                Icons.refresh_outlined,
                size: 20,
                color: Color(0xFFe96341),
              ),
            ),
          ],
        )
    );
  }

  Widget _buildCardDetailsContent(){
    switch (cardDetailsApiStatus){
      case CardDetailsApiStatus.inProgress:
        return _CardDetailsLoadingView();
      case CardDetailsApiStatus.success:
        return _CardDetailsSuccessView();
      case CardDetailsApiStatus.failure:
        return _CardDetailsFailureView();
      default:
        return Container();
    }
  }

  void userAuthentication() async {
    String? token = await UserAuthentication.isLoggedIn(context);
    setState(() {
      cardDetailsApiStatus = CardDetailsApiStatus.inProgress;
      // unbilledTransactionsApiStatus = ApiStatus.inProgress;
    });

    try{
      await _getCardDetailsData(token);
      await _getCardBalanceData(token);
      await _getCvvData(token);
      await _getUnbilledTransactionsData(token);
      setState(() {
        cardDetailsApiStatus = CardDetailsApiStatus.success;
      });
    }catch(error){
      setState(() {
        cardDetailsApiStatus = CardDetailsApiStatus.failure;
      });
    }
  }

  @override
  initState(){
    super.initState();
    userAuthentication();

    // transactionsList = List.generate(
    //   10,
    //       (index) => {
    //     "icon": FontAwesomeIcons.circlePlus,
    //     "iconColor": Colors.green,
    //     "day": "Today. 10:21 AM",
    //     "subAmount": "+ \u20B9 ${47.25 + index}",
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: double.infinity,
              color: const Color(0xFF404d6b),
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 15,),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: const Color(0xFF2d364b),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            //userName != null && userName.isNotEmpty ? userName : "***",
                            style: const TextStyle(
                              fontFamily: 'primaryFont',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            "Welcome back",
                            style: TextStyle(
                              fontFamily: 'primaryFont',
                              fontSize: 12,
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.alarm,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 18,),
                      GestureDetector(
                        onTap: (){
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => CardControlsPage()));
                        },
                        child: const Icon(
                          Icons.settings,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 15,),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                  child: _buildCardDetailsContent()
              ),
            )
          ],
        ),
      ),
    );
  }
}
