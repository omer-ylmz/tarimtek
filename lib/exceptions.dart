class Hatalar {
  static String? goster(String hataKodu) {
    switch (hataKodu) {
      case "email-already-in-use":
        return "Bu mail adresi zaten kullanımda, lütfen farklı bir mail adresi kullanınız";

      default:
        return "Bir hata oluştu";
    }
  }
}
