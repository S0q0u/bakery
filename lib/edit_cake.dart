import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cake_collection.dart';
import 'auth.dart';

class EditCake extends StatefulWidget {
  static const routeName = '/EditCake';

  @override
  _EditCakeState createState() => _EditCakeState();
}

class _EditCakeState extends State<EditCake> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final cakeProvider = Provider.of<CakeList>(context, listen: false);

    // Menampilkan detail cake
    final selectedCakeId = ModalRoute.of(context)?.settings.arguments as String?;
    final selectedCake = cakeProvider.items.firstWhere(
          (cake) => cake.id == selectedCakeId,
      orElse: () =>
          Cake(id: '', name: '', description: '', price: 0.0, imageUrl: ''),
    );

    void _saveForm() async {
      final isValid = _formKey.currentState?.validate() ?? false;
      if (!isValid) {
        return;
      }

      // Mengambil nilai dari controller
      final name = _nameController.text;
      final description = _descriptionController.text;
      final price = double.parse(_priceController.text);
      final imageUrl = _imageUrlController.text;

      // Membuat objek cake baru
      final newCake = Cake(
        id: selectedCake.id, // Use the existing ID for updates
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl,
      );

      // Tambah atau update data di Firestore
      final firestoreService = FirebaseServiceCake();
      if (selectedCake.id.isEmpty) {
        // Jika ID kosong, artinya cake baru
        //await firestoreService.addCake(newCake.toJson());
        cakeProvider.addCake(newCake);
      } else {
        // Jika ID tidak kosong, artinya update cake yang sudah ada
        //cakeProvider.updateCake(selectedCake.id, newCake);

        // GATK TAUUUUUUUU
      }

      // Bersihkan controller
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _imageUrlController.clear();

      // Navigasi kembali
      Navigator.of(context).pop();
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: const Text('Edit Cake'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                //style: Theme.of(context).textTheme.labelMedium,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  //labelStyle: Theme.of(context).textTheme.labelMedium,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                //style: Theme.of(context).textTheme.labelMedium,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  //labelStyle: Theme.of(context).textTheme.labelMedium,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                //style: Theme.of(context).textTheme.labelMedium,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  //labelStyle: Theme.of(context).textTheme.labelMedium,
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters long.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                //style: Theme.of(context).textTheme.labelMedium,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  //labelStyle: Theme.of(context).textTheme.labelMedium,
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL.';
                  }
                  if (!value.startsWith('http') && !value.startsWith('https')) {
                    return 'Please enter a valid URL.';
                  }
                  if (!value.endsWith('.png') &&
                      !value.endsWith('.jpg') &&
                      !value.endsWith('.jpeg')) {
                    return 'Please enter a valid image URL.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
