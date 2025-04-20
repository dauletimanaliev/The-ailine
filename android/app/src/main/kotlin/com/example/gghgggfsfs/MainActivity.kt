package com.example.gghgggfsfs

import android.app.Application
import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity()


class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        MapKitFactory.setApiKey("fb0d9d49-9526-4df6-b209-5b1dab24f804") // Your generated API key
    }
}
