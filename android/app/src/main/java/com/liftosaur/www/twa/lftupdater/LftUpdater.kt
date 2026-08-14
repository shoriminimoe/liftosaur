package com.liftosaur.www.twa.lftupdater

import android.content.Context
import android.util.Log

// This build never fetches JS bundles from a remote update server - it only ever runs the bundle
// it was compiled with. The native module is kept so the JS spec still resolves, but every entry
// point is inert except revertToEmbedded, which cleans up bundles older builds downloaded.
object LftUpdater {
    private const val TAG = "LftUpdater"

    fun checkAndDownload(context: Context): Map<String, Any?> {
        Log.i(TAG, "checkAndDownload called; updates are disabled in this build")
        return mapOf("status" to "no-update")
    }

    fun markLaunchSuccessful(context: Context) {
    }
}
