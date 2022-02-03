import 'package:ahia_deliveryAgent/Services/FirebaseServices.dart';
import 'package:ahia_deliveryAgent/Services/OrderServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class OrderSummaryCard extends StatefulWidget {
  final DocumentSnapshot document;
  OrderSummaryCard(this.document);

  @override
  _OrderSummaryCardState createState() => _OrderSummaryCardState();
}

class _OrderSummaryCardState extends State<OrderSummaryCard> {
  FirebaseServices _services = FirebaseServices();
  OrderServices _orderServices = OrderServices();
  DocumentSnapshot _customer;

  @override
  void initState() {
    _services
        .getCustomerDetails(widget.document.data()['userId'])
        .then((value) {
      if (value != null) {
        setState(() {
          _customer = value;
        });
      } else {
        print('no customer');
      }
    });
    super.initState();
  }

  Color statusColour(DocumentSnapshot document) {
    if (document.data()['orderStatus'] == 'Accepted') {
      return Theme.of(context).primaryColor;
    }
    if (document.data()['orderStatus'] == 'Picked Up') {
      return Colors.pink;
    }
    if (document.data()['orderStatus'] == 'Delivered') {
      return Colors.purple;
    }
    if (document.data()['orderStatus'] == 'On the way') {
      return Colors.green;
    }
    return Colors.orange;
  }

  Icon statusIcon(DocumentSnapshot document) {
    if (document.data()['orderStatus'] == 'Accepted') {
      return Icon(Icons.check_circle, color: statusColour(document));
    }
    if (document.data()['orderStatus'] == 'Picked Up') {
      return Icon(Icons.wallet_giftcard, color: statusColour(document));
    }
    if (document.data()['orderStatus'] == 'Delivered') {
      return Icon(Icons.shopping_bag, color: statusColour(document));
    }
    if (document.data()['orderStatus'] == 'On the way') {
      return Icon(Icons.delivery_dining, color: statusColour(document));
    }
    return Icon(CupertinoIcons.square_list, color: statusColour(document));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 14,
              child: statusIcon(widget.document),
            ),
            title: Text(widget.document.data()['orderStatus'],
                style: TextStyle(
                  fontSize: 12,
                  color: statusColour(widget.document),
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Text(
                'On ${DateFormat.yMMMd().format(
                  DateTime.parse(widget.document.data()['timestamp']),
                )}',
                style: TextStyle(fontSize: 12)),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Amount: \NGN${widget.document.data()['total'].toStringAsFixed(0)}',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(
                    'Payment Method: ${widget.document.data()['cod'] == true ? 'Cash on delivery' : 'Online payment'}',
                    style: TextStyle(
                      fontSize: 12,
                    )),
              ],
            ),
          ),
          // Customer details here
          _customer != null
              ? ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer Details',
                          style: TextStyle(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.bold)),
                      Text(
                          '${_customer.data()['firstName']} ${_customer.data()['lastName']}',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _customer.data()['address'],
                        style: TextStyle(fontSize: 12),
                        maxLines: 2,
                      ),
                      Text(
                          '${_customer.data()['city']} - ${_customer.data()['state']}',
                          style: TextStyle(
                            fontSize: 12,
                          )),
                      Text(
                        _customer.data()['number'],
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.phone,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          _orderServices
                              .launchCall('tel:${_customer.data()['number']}');
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          _orderServices.launchEmail(
                              'mailto:${_customer.data()['email']}?subject=Delivery Agent Contact');
                        },
                      ),
                    ],
                  ),
                )
              : Container(),
          ExpansionTile(
            title: Text(
              'Order details',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            subtitle: Text(
              'view order details',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.network(widget.document.data()['products']
                            [index]['productImage'])),
                    title: Text(widget.document.data()['products'][index]
                        ['productName']),
                    subtitle: Text(
                        'NGN${widget.document.data()['products'][index]['price'].toStringAsFixed(0)} x qty (${widget.document.data()['products'][index]['quantity']}) = ${widget.document.data()['products'][index]['total'].toStringAsFixed(0)},',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  );
                },
                itemCount: widget.document.data()['products'].length,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 8, bottom: 8),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Row(children: [
                        Text('Seller: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(
                          widget.document.data()['seller']['shopName'],
                          style: (TextStyle(fontSize: 12)),
                        )
                      ]),
                      SizedBox(height: 10),
                      if (int.parse(widget.document.data()['discount']) > 0)
                        Column(children: [
                          Row(children: [
                            Text('Discount: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                            Text(
                              '\NGN${widget.document.data()['discount']}',
                            )
                          ]),
                          SizedBox(height: 10),
                          Row(children: [
                            Text('Discount Code: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                            Text('${widget.document.data()['discountCode']}',
                                style: TextStyle(fontSize: 12))
                          ])
                        ]),
                      SizedBox(height: 10),
                      Row(children: [
                        Text('Delivery Fee: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(
                            'NGN${widget.document.data()['deliveryFee'].toString()}',
                            style: TextStyle(fontSize: 12))
                      ])
                    ]),
                  ),
                ),
              )
            ],
          ),
          Divider(
            height: 3,
            color: Colors.grey,
          ),
          statusContainer(widget.document, context),

          Divider(
            height: 3,
            color: Colors.grey,
          ),
        ]));
  }

  showMyDialog(title, status, documentId, context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text('Are you sure you have received payment?'),
          actions: [
            FlatButton(
              child: Text(
                'YES, Payment Received',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                EasyLoading.show();
                _services
                    .updateStatus(id: documentId, status: 'Delivered')
                    .then((value) {
                  EasyLoading.showSuccess(
                      'Order status updated to (Delivered)');
                  Navigator.pop(context);
                });
              },
            ),
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Widget statusContainer(DocumentSnapshot document, context) {
    if (document.data()['deliveryBoy']['name'].length > 1) {
      if (document.data()['orderStatus'] == 'Accepted') {
        return Container(
          color: Colors.grey[200],
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
            child: FlatButton(
              color: statusColour(widget.document),
              child: Text('Pick Up', style: TextStyle(color: Colors.white)),
              onPressed: () {
                EasyLoading.show();
                _services
                    .updateStatus(
                  id: document.id,
                  status: 'Picked Up',
                )
                    .then((value) {
                  EasyLoading.showSuccess(
                      'Order status updated successfully to (Picked Up)');
                });
              },
            ),
          ),
        );
      }

      if (document.data()['orderStatus'] == 'Picked Up') {
        return Container(
          color: Colors.grey[200],
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
            child: FlatButton(
              color: statusColour(widget.document),
              child: Text('On the way', style: TextStyle(color: Colors.white)),
              onPressed: () {
                EasyLoading.show();
                _services
                    .updateStatus(
                  id: document.id,
                  status: 'On the way',
                )
                    .then((value) {
                  EasyLoading.showSuccess(
                      'Order status updated successfully to (On the way)');
                });
              },
            ),
          ),
        );
      }

      if (document.data()['orderStatus'] == 'On the way') {
        return Container(
          color: Colors.grey[200],
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: FlatButton(
            color: statusColour(widget.document),
            child: Text('Deliver Order', style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (document.data()['cod'] == true) {
                return showMyDialog(
                    'Receive Payment', 'Delivered', document.id, context);
              } else {
                EasyLoading.show();
                _services
                    .updateStatus(
                  id: document.id,
                  status: 'Delivered',
                )
                    .then((value) {
                  EasyLoading.showSuccess(
                      'Order status updated successfully to (Delivered)');
                });
              }
            },
          ),
        );
      }

      return Container(
        color: Colors.grey[200],
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: FlatButton(
          color: Colors.purple,
          child: Text('Order completed', style: TextStyle(color: Colors.white)),
          onPressed: () {},
        ),
      );
    }
  }
}
