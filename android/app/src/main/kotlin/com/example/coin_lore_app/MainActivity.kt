package com.example.coin_lore_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.platformViewsController
            .registry
            .registerViewFactory("mp_chart_view", MpChartViewFactory(flutterEngine.dartExecutor.binaryMessenger))
    }
}
