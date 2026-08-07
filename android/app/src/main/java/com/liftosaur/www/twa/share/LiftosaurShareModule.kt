package com.liftosaur.www.twa.share

import android.content.Intent
import androidx.core.content.FileProvider
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import java.io.BufferedReader
import java.io.File
import java.io.FileOutputStream
import java.io.InputStreamReader

import com.liftosaur.www.twa.specs.NativeLiftosaurShareSpec

class LiftosaurShareModule(reactContext: ReactApplicationContext) :
    NativeLiftosaurShareSpec(reactContext) {

    override fun shareLog(promise: Promise) {
        try {
            val activity = currentActivity ?: run {
                promise.reject("no_activity", "No current activity")
                return
            }
            val logsDir = File(reactApplicationContext.cacheDir, "sharelogs").apply { mkdirs() }
            val logFile = File(logsDir, "liftosaur-logcat.log")
            val pid = android.os.Process.myPid().toString()
            val process = Runtime.getRuntime().exec(arrayOf("logcat", "-d", "-v", "threadtime", "--pid=$pid"))
            BufferedReader(InputStreamReader(process.inputStream)).use { reader ->
                FileOutputStream(logFile).use { out ->
                    reader.forEachLine { line ->
                        out.write((line + "\n").toByteArray(Charsets.UTF_8))
                    }
                }
            }
            val authority = "${reactApplicationContext.packageName}.shareprovider"
            val uri = FileProvider.getUriForFile(reactApplicationContext, authority, logFile)
            val intent = Intent(Intent.ACTION_SEND).apply {
                type = "text/plain"
                putExtra(Intent.EXTRA_STREAM, uri)
                putExtra(Intent.EXTRA_SUBJECT, "Liftosaur logs")
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            val chooser = Intent.createChooser(intent, "Share device logs").apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            activity.startActivity(chooser)
            promise.resolve(null)
        } catch (e: Exception) {
            promise.reject("share_log_failed", e.message ?: "Unknown error", e)
        }
    }
}
