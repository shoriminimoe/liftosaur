package com.liftosaur.www.twa.lftupdater

import android.content.Context
import android.util.Log
import java.io.File

object LftUpdaterPath {
    private const val TAG = "LftUpdater"
    private const val PREFS_NAME = "LftUpdater"
    private const val KEY_ACTIVE_UPDATE_ID = "activeUpdateId"

    fun otaRoot(context: Context): File = File(context.filesDir, "ota")

    // Builds before updates were removed could download a JS bundle and launch from it instead of
    // the embedded one. Those bundles survive an app upgrade, so delete them on every launch.
    fun purgeDownloadedBundles(context: Context) {
        val root = otaRoot(context)
        if (root.exists()) {
            root.deleteRecursively()
            Log.i(TAG, "purged downloaded bundles at ${root.absolutePath}")
        }
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .remove(KEY_ACTIVE_UPDATE_ID)
            .apply()
    }
}
