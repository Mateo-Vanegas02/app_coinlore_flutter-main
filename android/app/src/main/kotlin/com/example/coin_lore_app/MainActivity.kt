package com.example.coin_lore_app

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("mpandroidchart_view", MpChartViewFactory(flutterEngine.dartExecutor.binaryMessenger))
    }
}
