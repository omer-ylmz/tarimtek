import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarimtek/constants/text_style.dart';
import 'package:tarimtek/locator/locator.dart';
import 'package:tarimtek/pages/sign_in/email_aktivasyon.dart';
import 'package:tarimtek/services/firebase_auth_service.dart';
import 'package:tarimtek/viewmodel/user_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  late FirebaseAuth auth;
  String _adSoyad = "";
  String _telefon = "";
  String _email = "";
  String _sifre = "";
  String _sifreTekrar = "";
  bool _sifreGizli = true;
  bool _sifreGizliTekrar = true;
  String _girilenSifreKontrol = "";

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
  }

  void _formSubmit() async {
    bool _validate = _formKey.currentState!.validate();
    if (_validate == true) {
      _formKey.currentState?.save(); // Form alanlarını kaydet
      debugPrint("email $_email şifre $_sifre");

      try {
        // Firebase Authentication kullanarak kullanıcı oluştur
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _sifre,
        );
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmailAktivasyon(
                email: _email,
              ),
            ));

        // Kullanıcı başarıyla oluşturulduğunda devam edilecek işlemler buraya yazılabilir
      } catch (e) {
        // Eğer hata bir FirebaseAuthException ise ve e-posta adresi zaten kayıtlıysa
        if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(
                'Böyle bir kullanıcı zaten kayıtlı.',
                style: Sabitler.yaziMorStyle,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Tamam',
                    style: Sabitler.yaziMorStyle,
                  ),
                ),
              ],
            ),
          );
        } else {
          // Diğer hataları işle
          print('Hata: $e');
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            'Lütfen girilen bilgileri kontrol edin.',
            style: Sabitler.yaziMorStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Tamam',
                style: Sabitler.yaziMorStyle,
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    return Scaffold(
        backgroundColor: Sabitler.arkaplan,
        body: _userModel.state == ViewState.idle
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ListView(
                  children: [
                    const SizedBox(height: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Bir Hesap Oluşturun",
                          textAlign: TextAlign.center,
                          style: Sabitler.baslikStyle,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Yeni bir hesap oluşturmak için lütfen aşağıdaki bilgileri doldurun.",
                          textAlign: TextAlign.center,
                          style: Sabitler.yaziMorStyle,
                        ),
                        const SizedBox(height: 15),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              formAlani(
                                TextInputType.name,
                                Icons.nest_cam_wired_stand_rounded,
                                "Ad Soyad",
                                "Ömer Yılmaz",
                                _adSoyad,
                                (value) =>
                                    _adSoyad = value!, // onSaved düzeltildi
                              ),
                              const SizedBox(height: 15),
                              formAlani(
                                  TextInputType.number,
                                  Icons.phone,
                                  "Telefon Numarası",
                                  "5314561052",
                                  _telefon,
                                  (value) =>
                                      _telefon = value!, // onSaved düzeltildi
                                  validator: (value) {
                                if (value!.length != 10) {
                                  return "Telefon numarası 10 karakter olmalı";
                                }
                              }),
                              const SizedBox(height: 15),
                              formAlani(
                                  TextInputType.emailAddress,
                                  Icons.email,
                                  "Email",
                                  "omeryilmaz@gmail.com",
                                  _email,
                                  (value) =>
                                      _email = value!, // onSaved düzeltildi
                                  validator: (value) {
                                if (EmailValidator.validate(value!)) {
                                  //mail kontrolu yapan sınıfı kullanarak işlem yaptık
                                  return null;
                                } else {
                                  return "Hatalı mail adresi girişi yaptınız";
                                }
                              }),
                              const SizedBox(height: 15),
                              formAlaniSifre(
                                  TextInputType.visiblePassword,
                                  Icons.lock,
                                  "Şifre",
                                  "**********",
                                  _sifre,
                                  (value) => _sifre = value!,
                                  yaziGizleme: _sifreGizli, validator: (value) {
                                if (value!.length < 6) {
                                  return "Şifre en az 6 karakter olmalı";
                                }
                              }),
                              const SizedBox(height: 15),
                              formAlaniSifreTekrar(
                                  TextInputType.visiblePassword,
                                  Icons.lock,
                                  "Şifre Tekrar",
                                  "**********",
                                  _sifreTekrar,
                                  (value) => _sifreTekrar = value!,
                                  yaziGizleme: _sifreGizliTekrar,
                                  validator: (value) {
                                if (value!.length < 6) {
                                  return "Şifre en az 6 karakter olmalı";
                                } else if (_girilenSifreKontrol != value!) {
                                  debugPrint("$_girilenSifreKontrol ve $value");
                                  return "Şifreler birbirleriyle uyuşmuyor";
                                }
                              }),
                              const SizedBox(height: 15),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, right: 40),
                                child: ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Sabitler.anaRenk)),
                                  onPressed: () => _formSubmit(),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Üye Ol",
                                        style: Sabitler.butonYaziStyleKapali,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }

  TextFormField formAlaniSifre(TextInputType keyboardType, IconData icon,
      String labelText, String hintText, deger, void Function(String?) onSaved,
      {bool yaziGizleme = false, final String? Function(String?)? validator}) {
    return TextFormField(
      obscureText: yaziGizleme,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(yaziGizleme ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _sifreGizli = !_sifreGizli;
            });
          },
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      onSaved: onSaved,
      onChanged: (value) {
        setState(() {
          _girilenSifreKontrol = value!;
        });
      },
      validator: validator,
    );
  }

  TextFormField formAlaniSifreTekrar(TextInputType keyboardType, IconData icon,
      String labelText, String hintText, deger, void Function(String?) onSaved,
      {bool yaziGizleme = false,
      var sifreDurumu,
      final String? Function(String?)? validator}) {
    return TextFormField(
      obscureText: yaziGizleme,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(yaziGizleme ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _sifreGizliTekrar = !_sifreGizliTekrar;
            });
          },
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }

  TextFormField formAlani(
    TextInputType keyboardType,
    IconData icon,
    String labelText,
    String hintText,
    String value,
    void Function(String?) onSaved, // onSaved fonksiyonu parametreden alındı
    {
    final String? Function(String?)? validator,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      initialValue: value, // varsayılan değeri belirle
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      onSaved: onSaved, // onSaved fonksiyonu parametreden alındı
      validator: validator,
    );
  }
}
