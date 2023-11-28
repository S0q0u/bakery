// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'cake_collection.dart';

class input_bakery_page extends StatefulWidget {
  const input_bakery_page({Key? key});

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<input_bakery_page> {
  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final address = TextEditingController();
  // CakeList cakeList = CakeList();
  late CakeList cakeList;

  // Map untuk menyimpan jumlah item yang ingin dibeli
  Map<String, int> quantities = {};

  // Fungsi untuk mengembalikan nilai jumlah yang harus dibayar
  int getTotal() {
    int total = 0;
    for (String item in quantities.keys) {
      total += (cakeList.items
          .firstWhere((cake) => cake.name == item)
          .price * quantities[item]!)
          .toInt();
    }
    return total;
  }

  // Fungsi untuk mengosongkan semua inputan saat tombol tutup ditekan
  void kosong() {
    name.clear();
    phoneNumber.clear();
    address.clear();
    quantities.clear();
    setState(() {}); // Memaksa widget untuk melakukan rebuild
  }

  // Fungsi untuk menampilkan nota pesanan
  bool submitOrder() {
    String nameValue = name.text;
    String phoneNumberValue = phoneNumber.text;
    String addressValue = address.text;

    // Map untuk menyimpan data pesanan
    Map<String, dynamic> order = {
      'name': nameValue,
      'phoneNumber': phoneNumberValue,
      'address': addressValue,
      'items': List<Map<String, dynamic>>.from(quantities.entries.map((entry) {
        String itemName = entry.key;
        int itemQuantity = entry.value;
        double itemPrice = cakeList.items
            .firstWhere((cake) => cake.name == itemName)
            .price;

        return {
          'item': itemName,
          'quantity': itemQuantity,
          'price': itemPrice,
        };
      })),
      'total': getTotal(),
    };

    // Check if any of the text fields is empty
    if (name.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.pink,
            title: Text(
              'Peringatan',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: Text(
              'Nama masih kosong.',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return false;
    } else if (phoneNumber.text.isEmpty || double.tryParse(phoneNumber.text) == null || phoneNumber.text.length < 10){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.pink,
            title: Text(
              'Peringatan',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: Text(
              'Nomor Hp tidak valid. Harap masukkan nomor yang valid.',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return false;
    } else if (address.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.pink,
            title: Text(
              'Peringatan',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: Text(
              'Alamat masih kosong',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return false;
    } else if (quantities.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.pink,
            title: Text(
              'Peringatan',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: Text(
              'Belum ada kue yang dipilih.',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return false;
    }


    // Mengambil waktu saat tombol "Pesan Sekarang" diklik
    DateTime orderDate = DateTime.now();
    order['orderDate'] = orderDate;

    int year = orderDate.year;
    int month = orderDate.month;
    int day = orderDate.day;
    int hour = orderDate.hour;
    int minute = orderDate.minute;

    // Tambahkan tanggal, jam, dan menit ke dalam nota pesanan
    order['orderYear'] = year;
    order['orderMonth'] = month;
    order['orderDay'] = day;
    order['orderHour'] = hour;
    order['orderMinute'] = minute;

    // Menyimpan data pesanan
    OrderData orderData = Provider.of<OrderData>(context, listen: false);
    orderData.addOrder(order);
    // OrderData().addOrder(order);

    // Menampilkan nota
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.pink,
          title: Text(
            'NOTA PESANAN',
            style: TextStyle(
              color: Colors.white,
            ),
            //style: Theme.of(context).textTheme.bodyMedium,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nama: $nameValue',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                'Nomor Telepon: $phoneNumberValue',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                'Alamat: $addressValue',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const Text(
                'Pesanan:',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              for (String item in quantities.keys)
              Text(
                //'$item: ${quantities[item]} x Rp ${menuPrices[item]}',
                '$item: ${quantities[item]} x Rp ${cakeList.items.firstWhere((cake) => cake.name == item).price}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(''
                'Total: Rp ${getTotal()}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                'Tanggal Pemesanan: $day/$month/$year',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                'Waktu Pemesanan: $hour:$minute',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // Menerapkan background color sesuai tema
          //backgroundColor: Theme.of(context).dialogBackgroundColor,
          // Menutup nota dan membersihkan inputan
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                kosong();
              },
              child: Text(
                'Tutup',
                style: TextStyle(
                  color: Colors.white,
                ),
                //style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        );
      },
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    cakeList = Provider.of<CakeList>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: const Text(
          'Buy Cake',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: name,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    labelStyle: TextStyle(
                        fontSize: 15
                    ),
                    filled: true, // Mengaktifkan pengisian latar belakang
                    fillColor: Colors.white, // Warna latar belakang
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 248, 30, 67),
                      ), // Border ketika fokus
                    ),
                  ),
                  maxLength: 50,
                ),

                const SizedBox(height: 10.0),

                TextField(
                  controller: phoneNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Nomor Telepon',
                    labelStyle: TextStyle(
                        fontSize: 15
                    ),
                    filled: true, // Mengaktifkan pengisian latar belakang
                    fillColor: Colors.white, // Warna latar belakang
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 248, 30, 67),
                      ), // Border ketika fokus
                    ),
                  ),
                  maxLength: 13,
                ),

                const SizedBox(height: 10.0),

                TextField(
                  controller: address,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    labelStyle: TextStyle(
                      fontSize: 15
                    ),
                    filled: true, // Mengaktifkan pengisian latar belakang
                    fillColor: Colors.white, // Warna latar belakang
                    border:
                        const OutlineInputBorder(), // Atau gunakan jenis border yang sesuai dengan kebutuhan Anda
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 248, 30, 67),
                      ), // Border ketika fokus
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

                // Listview, separated digunakan untuk memisahkan tiap item
                ListView.separated(
                  shrinkWrap: true,
                  //itemCount: menuPrices.keys.length,
                  itemCount: cakeList.items.length,
                  itemBuilder: (context, index) {
                    //String item = menuPrices.keys.toList()[index];
                    Cake cake = cakeList.items[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          cake.name,
                          //style: Theme.of(context).textTheme.labelMedium,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  // if (quantities.containsKey(item) &&
                                  //     quantities[item]! > 0) {
                                  //   quantities[item] = quantities[item]! - 1;
                                  // }
                                  if (quantities.containsKey(cake.name) &&
                                      quantities[cake.name]! > 0) {
                                    quantities[cake.name] =
                                        quantities[cake.name]! - 1;
                                  }
                                });
                              },
                              mini: true,
                              backgroundColor:
                                  const Color.fromARGB(255, 248, 30, 67),
                              child: const Icon(
                                CupertinoIcons.minus,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              //'${quantities[item] ?? 0}',
                              '${quantities[cake.name] ?? 0}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  // if (quantities.containsKey(item)) {
                                  //   quantities[item] = quantities[item]! + 1;
                                  // } else {
                                  //   quantities[item] = 1;
                                  // }
                                  if (quantities.containsKey(cake.name)) {
                                    quantities[cake.name] =
                                        quantities[cake.name]! + 1;
                                  } else {
                                    quantities[cake.name] = 1;
                                  }
                                });
                              },
                              mini: true,
                              backgroundColor:
                                  const Color.fromARGB(255, 248, 30, 67),
                              child: const Icon(
                                CupertinoIcons.add,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                      height: 10.0), // jarak antar item adalah 10
                ),
                const SizedBox(
                  height: 15,
                ),
                CupertinoButton(
                  color: const Color.fromARGB(255, 248, 30, 67),
                  onPressed: () {
                    // submitOrder() sekarang mengembalikan nilai boolean yang menunjukkan apakah pemesanan berhasil
                    bool orderSuccessful = submitOrder();

                    if (orderSuccessful) {
                      // Menampilkan snackbar hanya jika pemesanan berhasil
                      const mySnackBar = SnackBar(
                        content: Text("Order berhasil"),
                        duration: Duration(seconds: 3),
                        padding: EdgeInsets.all(10),
                        backgroundColor: Color.fromARGB(255, 248, 30, 67),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(mySnackBar);
                    }
                  },
                  child: const Text(
                    'Pesan Sekarang',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
