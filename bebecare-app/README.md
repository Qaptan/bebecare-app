# BebeCare 👶

Bebek mama, uyku ve bez takip uygulaması.

## Özellikler
- 🍼 Mama takibi (emzirme / biberon)
- 😴 Uyku takibi
- 🚼 Bez değişimi takibi
- 📊 Günlük istatistikler
- 💰 AdMob banner reklam entegrasyonu
- 🌙 Koyu tema

## Kurulum

### 1. Flutter Kur
https://flutter.dev/docs/get-started/install

### 2. Bağımlılıkları yükle
```bash
flutter pub get
```

### 3. AdMob ID'lerini Değiştir
- `android/app/src/main/AndroidManifest.xml` içinde APPLICATION_ID'yi değiştir
- `lib/widgets/banner_ad_widget.dart` içinde ad unit ID'yi değiştir

### 4. Build al
```bash
flutter build apk --release
```

## Paket Adı
`com.susaati.bebecare`

## Geliştirici Notları
- Test reklamları için mevcut ID'ler kullanılmaktadır
- Yayın öncesi gerçek AdMob ID'leri ile değiştiriniz
