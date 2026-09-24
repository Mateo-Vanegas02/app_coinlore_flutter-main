package com.example.coin_lore_app

import android.content.Context
import android.graphics.Color
import android.view.View
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.BinaryMessenger
import com.github.mikephil.charting.charts.*
import com.github.mikephil.charting.data.*
import com.github.mikephil.charting.components.XAxis
import com.github.mikephil.charting.components.YAxis
import com.github.mikephil.charting.formatter.IndexAxisValueFormatter

class MpChartView(
    context: Context,
    private val id: Int,
    creationParams: Map<String?, Any?>?,
    messenger: BinaryMessenger
) : PlatformView {
    
    private val channel = MethodChannel(messenger, "mpandroidchart_view_$id")
    private val container: View
    
    init {
        val chartType = creationParams?.get("chartType") as? String ?: "line"
        container = createChart(context, chartType)
        applyConfig(creationParams)
        
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "updateConfig" -> {
                    applyConfig(call.arguments as? Map<String?, Any?>)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun getView(): View {
        return container
    }

    override fun dispose() {
        channel.setMethodCallHandler(null)
    }

    private fun createChart(context: Context, type: String): View {
        return when (type) {
            "bar" -> BarChart(context)
            "pie" -> PieChart(context)
            "radar" -> RadarChart(context)
            "scatter" -> ScatterChart(context)
            "bubble" -> BubbleChart(context)
            "candlestick" -> CandleStickChart(context)
            "combined" -> CombinedChart(context)
            "horizontal_bar" -> HorizontalBarChart(context)
            else -> LineChart(context)
        }
    }

    private fun applyConfig(config: Map<String?, Any?>?) {
        if (config == null || container !is Chart<*>) return
        
        val chart = container as Chart<*>
        
        // Basic configuration
        chart.description.isEnabled = config["showDescription"] as? Boolean ?: false
        if (chart.description.isEnabled) {
            chart.description.text = config["description"] as? String ?: ""
        }
        
        // Legend
        val legendConfig = config["legend"] as? Map<String, Any>
        if (legendConfig != null) {
            chart.legend.isEnabled = legendConfig["enabled"] as? Boolean ?: true
        }

        // Apply specific Data
        val dataMap = config["data"] as? Map<String, Any>
        if (dataMap != null) {
            when (chart) {
                is LineChart -> chart.data = parseLineData(dataMap)
                is BarChart -> chart.data = parseBarData(dataMap)
                is PieChart -> {
                    chart.data = parsePieData(dataMap)
                    chart.isDrawHoleEnabled = config["drawHole"] as? Boolean ?: false
                }
                is ScatterChart -> chart.data = parseScatterData(dataMap)
                is RadarChart -> chart.data = parseRadarData(dataMap)
                is CandleStickChart -> chart.data = parseCandleData(dataMap)
                is BubbleChart -> chart.data = parseBubbleData(dataMap)
            }
        }
        
        // Axes configuration for BarLineChartBase
        if (chart is BarLineChartBase<*>) {
            val xAxisConfig = config["xAxis"] as? Map<String, Any>
            if (xAxisConfig != null) {
                val xAxis = chart.xAxis
                xAxis.isEnabled = xAxisConfig["enabled"] as? Boolean ?: true
                xAxis.position = XAxis.XAxisPosition.BOTTOM
                val labels = xAxisConfig["labels"] as? List<String>
                if (labels != null) {
                    xAxis.valueFormatter = IndexAxisValueFormatter(labels)
                }
            }
        }

        // Animation
        val animateX = config["animateX"] as? Int ?: 0
        val animateY = config["animateY"] as? Int ?: 0
        if (animateX > 0 && animateY > 0) {
            chart.animateXY(animateX, animateY)
        } else if (animateX > 0) {
            chart.animateX(animateX)
        } else if (animateY > 0) {
            chart.animateY(animateY)
        }
        
        chart.invalidate() // refresh
    }

    private fun parseColor(colorStr: String?): Int {
        if (colorStr == null) return Color.BLUE
        return Color.parseColor(colorStr)
    }

    private fun parseLineData(dataMap: Map<String, Any>): LineData {
        val datasets = dataMap["datasets"] as? List<Map<String, Any>> ?: return LineData()
        val dataSetsList = ArrayList<io.flutter.plugin.common.StandardMessageCodec>()
        val lineDataSets = ArrayList<LineDataSet>()
        
        for (ds in datasets) {
            val label = ds["label"] as? String ?: ""
            val entries = ds["entries"] as? List<Map<String, Any>> ?: emptyList()
            val entryList = ArrayList<Entry>()
            for (e in entries) {
                val x = (e["x"] as? Number)?.toFloat() ?: 0f
                val y = (e["y"] as? Number)?.toFloat() ?: 0f
                entryList.add(Entry(x, y))
            }
            val set = LineDataSet(entryList, label)
            set.color = parseColor(ds["color"] as? String)
            set.setDrawCircles(ds["drawCircles"] as? Boolean ?: true)
            set.setDrawValues(ds["drawValues"] as? Boolean ?: true)
            set.lineWidth = (ds["lineWidth"] as? Number)?.toFloat() ?: 1f
            
            val isFilled = ds["isFilled"] as? Boolean ?: false
            if (isFilled) {
                set.setDrawFilled(true)
                set.fillColor = set.color
            }
            
            val mode = ds["mode"] as? String
            if (mode == "cubic") {
                set.mode = LineDataSet.Mode.CUBIC_BEZIER
            } else if (mode == "stepped") {
                set.mode = LineDataSet.Mode.STEPPED
            }
            lineDataSets.add(set)
        }
        return LineData(lineDataSets.toList())
    }

    private fun parseBarData(dataMap: Map<String, Any>): BarData {
        val datasets = dataMap["datasets"] as? List<Map<String, Any>> ?: return BarData()
        val barDataSets = ArrayList<BarDataSet>()
        for (ds in datasets) {
            val label = ds["label"] as? String ?: ""
            val entries = ds["entries"] as? List<Map<String, Any>> ?: emptyList()
            val entryList = ArrayList<BarEntry>()
            for (e in entries) {
                val x = (e["x"] as? Number)?.toFloat() ?: 0f
                val y = (e["y"] as? Number)?.toFloat() ?: 0f
                val yVals = e["yVals"] as? List<Number>
                if (yVals != null) {
                    val floats = FloatArray(yVals.size)
                    for (i in yVals.indices) floats[i] = yVals[i].toFloat()
                    entryList.add(BarEntry(x, floats))
                } else {
                    entryList.add(BarEntry(x, y))
                }
            }
            val set = BarDataSet(entryList, label)
            set.color = parseColor(ds["color"] as? String)
            val colors = ds["colors"] as? List<String>
            if (colors != null) {
                set.colors = colors.map { parseColor(it) }
            }
            barDataSets.add(set)
        }
        return BarData(barDataSets.toList())
    }

    private fun parsePieData(dataMap: Map<String, Any>): PieData {
        val datasets = dataMap["datasets"] as? List<Map<String, Any>> ?: return PieData()
        val pieDataSets = ArrayList<PieDataSet>()
        for (ds in datasets) {
            val label = ds["label"] as? String ?: ""
            val entries = ds["entries"] as? List<Map<String, Any>> ?: emptyList()
            val entryList = ArrayList<PieEntry>()
            for (e in entries) {
                val value = (e["value"] as? Number)?.toFloat() ?: 0f
                val name = e["label"] as? String
                entryList.add(PieEntry(value, name))
            }
            val set = PieDataSet(entryList, label)
            val colors = ds["colors"] as? List<String>
            if (colors != null) {
                set.colors = colors.map { parseColor(it) }
            }
            pieDataSets.add(set)
        }
        if (pieDataSets.isNotEmpty()) {
            return PieData(pieDataSets[0])
        }
        return PieData()
    }

    private fun parseScatterData(dataMap: Map<String, Any>): ScatterData {
        val datasets = dataMap["datasets"] as? List<Map<String, Any>> ?: return ScatterData()
        val scatterDataSets = ArrayList<ScatterDataSet>()
        for (ds in datasets) {
            val label = ds["label"] as? String ?: ""
            val entries = ds["entries"] as? List<Map<String, Any>> ?: emptyList()
            val entryList = ArrayList<Entry>()
            for (e in entries) {
                val x = (e["x"] as? Number)?.toFloat() ?: 0f
                val y = (e["y"] as? Number)?.toFloat() ?: 0f
                entryList.add(Entry(x, y))
            }
            val set = ScatterDataSet(entryList, label)
            set.color = parseColor(ds["color"] as? String)
            scatterDataSets.add(set)
        }
        return ScatterData(scatterDataSets.toList())
    }
    
    private fun parseRadarData(dataMap: Map<String, Any>): RadarData {
        val datasets = dataMap["datasets"] as? List<Map<String, Any>> ?: return RadarData()
        val dataSetsList = ArrayList<RadarDataSet>()
        for (ds in datasets) {
            val label = ds["label"] as? String ?: ""
            val entries = ds["entries"] as? List<Map<String, Any>> ?: emptyList()
            val entryList = ArrayList<RadarEntry>()
            for (e in entries) {
                val value = (e["value"] as? Number)?.toFloat() ?: 0f
                entryList.add(RadarEntry(value))
            }
            val set = RadarDataSet(entryList, label)
            set.color = parseColor(ds["color"] as? String)
            set.fillColor = set.color
            set.setDrawFilled(true)
            dataSetsList.add(set)
        }
        return RadarData(dataSetsList.toList())
    }

    private fun parseCandleData(dataMap: Map<String, Any>): CandleData {
        val datasets = dataMap["datasets"] as? List<Map<String, Any>> ?: return CandleData()
        val dataSetsList = ArrayList<CandleDataSet>()
        for (ds in datasets) {
            val label = ds["label"] as? String ?: ""
            val entries = ds["entries"] as? List<Map<String, Any>> ?: emptyList()
            val entryList = ArrayList<CandleEntry>()
            for (e in entries) {
                val x = (e["x"] as? Number)?.toFloat() ?: 0f
                val h = (e["high"] as? Number)?.toFloat() ?: 0f
                val l = (e["low"] as? Number)?.toFloat() ?: 0f
                val o = (e["open"] as? Number)?.toFloat() ?: 0f
                val c = (e["close"] as? Number)?.toFloat() ?: 0f
                entryList.add(CandleEntry(x, h, l, o, c))
            }
            val set = CandleDataSet(entryList, label)
            set.color = parseColor(ds["color"] as? String)
            dataSetsList.add(set)
        }
        return CandleData(dataSetsList.toList())
    }
    
    private fun parseBubbleData(dataMap: Map<String, Any>): BubbleData {
        val datasets = dataMap["datasets"] as? List<Map<String, Any>> ?: return BubbleData()
        val dataSetsList = ArrayList<BubbleDataSet>()
        for (ds in datasets) {
            val label = ds["label"] as? String ?: ""
            val entries = ds["entries"] as? List<Map<String, Any>> ?: emptyList()
            val entryList = ArrayList<BubbleEntry>()
            for (e in entries) {
                val x = (e["x"] as? Number)?.toFloat() ?: 0f
                val y = (e["y"] as? Number)?.toFloat() ?: 0f
                val size = (e["size"] as? Number)?.toFloat() ?: 0f
                entryList.add(BubbleEntry(x, y, size))
            }
            val set = BubbleDataSet(entryList, label)
            set.color = parseColor(ds["color"] as? String)
            dataSetsList.add(set)
        }
        return BubbleData(dataSetsList.toList())
    }
}
