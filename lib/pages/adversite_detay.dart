import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/model/ilan.dart';
import 'package:tarimtek/model/user.dart';
import 'package:tarimtek/viewmodel/user_model.dart';
import 'package:geocoding/geocoding.dart'; // For geocoding

class AdversiteDetay extends StatefulWidget {
  final Ilan ilan;

  AdversiteDetay({
    Key? key,
    required this.ilan,
  }) : super(key: key);

  @override
  State<AdversiteDetay> createState() => _AdversiteDetayState();
}

class _AdversiteDetayState extends State<AdversiteDetay> {
  late GoogleMapController mapController;
  LatLng? _center;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getLatLng();
  }

  Future<void> _getLatLng() async {
    try {
      List<Location> locations = await locationFromAddress(
        "${widget.ilan.selectedIlce}, ${widget.ilan.selectedIl}",
      );
      setState(() {
        _center = LatLng(locations[0].latitude, locations[0].longitude);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Konum bilgisi alınırken bir hata oluştu: $e";
        _isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    Future<AppUser?> ilanSahibi =
        _userModel.readUser(widget.ilan.ilanSahibiId!);

    return Scaffold(
      body: FutureBuilder<AppUser?>(
        future: ilanSahibi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Kullanıcı bulunamadı'));
          } else {
            AppUser? ilanSahibiUser = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    const Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                          'https://static.ticimax.cloud/35637/uploads/urunresimleri/buyuk/cig-ic-findik-7dcb.jpg',
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                        child: Text(widget.ilan.isPozisyonu!,
                            style: Sabitler.ilanDetayBaslikStyle)),
                    SizedBox(height: 8),
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          ilanSahibiUser!.userName!,
                          style: Sabitler.yaziStyleSiyahAltBaslikBuyuk,
                        ),
                        Text(
                          " • ",
                          style: Sabitler.yaziStyleSiyahAltBaslikBuyuk,
                        ),
                        Text(
                          widget.ilan.selectedIl!,
                          style: Sabitler.yaziStyleSiyahAltBaslikBuyuk,
                        ),
                        Text(
                          " • ",
                          style: Sabitler.yaziStyleSiyahAltBaslikBuyuk,
                        ),
                        Text(
                          widget.ilan.isSuresi!,
                          style: Sabitler.yaziStyleSiyahAltBaslikBuyuk,
                        )
                      ],
                    )),
                    SizedBox(height: 16),
                    Center(
                      child: Text(
                        "₺" + widget.ilan.isUcreti!,
                        style: Sabitler.baslikStyle,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('İşin Açıklaması',
                        style: Sabitler.ilanDetayBaslikStyleKucuk),
                    SizedBox(height: 8),
                    Text(
                      widget.ilan.ilanTanimi!,
                      style: Sabitler.yaziStyleSiyahAltBaslikBuyuk,
                    ),
                    SizedBox(height: 16),
                    // Text('Konum', style: Sabitler.ilanDetayBaslikStyleKucuk),
                    // SizedBox(height: 8),
                    // Text(
                    //   widget.ilan.selectedIlce! + "," + widget.ilan.selectedIl!,
                    //   style: Sabitler.yaziStyleSiyahAltBaslikBuyuk,
                    // ),
                    // SizedBox(height: 16),
                    // _isLoading
                    //     ? Center(child: CircularProgressIndicator())
                    //     : _error != null
                    //         ? Center(child: Text(_error!))
                    //         : Container(
                    //             height: 200,
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(8),
                    //               border: Border.all(color: Colors.grey),
                    //             ),
                    //             child: GoogleMap(
                    //               onMapCreated: _onMapCreated,
                    //               initialCameraPosition: CameraPosition(
                    //                 target: _center!,
                    //                 zoom: 14.0,
                    //               ),
                    //             ),
                    //           ),
                    // SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: Text('İLETİŞİME GEÇ'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
