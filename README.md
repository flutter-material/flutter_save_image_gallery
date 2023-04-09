# flutter_save_image_gallery

<img src="/screenshot/img01.png" width=250/>

## 1. 安裝庫
請在 `pubspec.yaml` 加入以下兩個庫。

```
dependencies:
  image_gallery_saver: ^1.7.1
  permission_handler: ^10.2.0
```

- [image_gallery_saver 照片相簿儲存](https://pub.dev/packages/image_gallery_saver)
- [permission_handler 權限管理](https://pub.dev/packages/permission_handler)

## 權限管理設定
### Android 設定
1. 設定 build.gradle
要設置 compileSdkVersion，您可以打開 `android/app/build.gradle` 文件，然後將以下行添加到文件中：

```xml
android {
  compileSdkVersion 33

  defaultConfig {
    targetSdkVersion 33
  }
}
```

2. AndroidManifest 添加權限標籤
開啟 Android 資料夾中的 `AndroidManifest.xml` 文件，並加入權限標籤。

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS 設定
1. Info.plist 加入權限
用 XCode 開啟 Info.plist 直接選 addRow 也行。或是在 ios -> Runner 資料夾中的 `Info.plist` 文件直接加入。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  ...
  <key>NSPhotoLibraryUsageDescription</key>
	<string>save image to gallery</string>
</dict>
</plist>
```

2. Podfile 添加設定
開啟 ios/Podfile 並加入。

```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    # 要加權限
    config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
            '$(inherited)',
        # dart: PermissionGroup.mediaLibrary
        'PERMISSION_MEDIA_LIBRARY=1',
            ]
  end
end
```