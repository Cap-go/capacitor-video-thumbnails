package app.capgo.capacitor.videothumbnails;

import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.util.Log;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@CapacitorPlugin(name = "CapgoVideoThumbnails")
public class CapgoVideoThumbnailsPlugin extends Plugin {

    private static final String TAG = "CapgoVideoThumbnails";
    private final String pluginVersion = "8.0.0";
    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    @PluginMethod
    public void getThumbnail(PluginCall call) {
        String sourceUri = call.getString("sourceUri");
        if (sourceUri == null || sourceUri.isEmpty()) {
            call.reject("sourceUri is required");
            return;
        }

        Double time = call.getDouble("time", 0.0);
        Double quality = call.getDouble("quality", 1.0);
        JSObject headersObj = call.getObject("headers");

        Map<String, String> headers = new HashMap<>();
        if (headersObj != null) {
            Iterator<String> keys = headersObj.keys();
            while (keys.hasNext()) {
                String key = keys.next();
                String value = headersObj.optString(key, null);
                if (value != null) {
                    headers.put(key, value);
                }
            }
        }

        executor.execute(() -> {
            try {
                JSObject result = generateThumbnail(sourceUri, time, quality, headers);
                call.resolve(result);
            } catch (Exception e) {
                Log.e(TAG, "Failed to generate thumbnail", e);
                call.reject("Failed to generate thumbnail: " + e.getMessage());
            }
        });
    }

    private JSObject generateThumbnail(String sourceUri, double time, double quality, Map<String, String> headers) throws IOException {
        MediaMetadataRetriever retriever = new MediaMetadataRetriever();

        try {
            if (sourceUri.startsWith("http://") || sourceUri.startsWith("https://")) {
                if (headers != null && !headers.isEmpty()) {
                    retriever.setDataSource(sourceUri, headers);
                } else {
                    retriever.setDataSource(sourceUri, new HashMap<>());
                }
            } else if (sourceUri.startsWith("file://")) {
                String path = Uri.parse(sourceUri).getPath();
                if (path == null) {
                    throw new IOException("Invalid file URI: " + sourceUri);
                }
                retriever.setDataSource(path);
            } else if (sourceUri.startsWith("content://")) {
                retriever.setDataSource(getContext(), Uri.parse(sourceUri));
            } else {
                // Assume it's a local file path
                File file = new File(sourceUri);
                if (!file.exists()) {
                    throw new IOException("File does not exist: " + sourceUri);
                }
                retriever.setDataSource(sourceUri);
            }

            // Convert milliseconds to microseconds
            long timeUs = (long) (time * 1000);

            Bitmap bitmap = retriever.getFrameAtTime(timeUs, MediaMetadataRetriever.OPTION_CLOSEST_SYNC);
            if (bitmap == null) {
                throw new IOException("Failed to extract frame from video");
            }

            // Save bitmap to temporary file
            File cacheDir = getContext().getCacheDir();
            String fileName = "thumbnail_" + UUID.randomUUID().toString() + ".jpg";
            File outputFile = new File(cacheDir, fileName);

            int qualityPercent = (int) (quality * 100);
            if (qualityPercent < 0) qualityPercent = 0;
            if (qualityPercent > 100) qualityPercent = 100;

            try (FileOutputStream fos = new FileOutputStream(outputFile)) {
                bitmap.compress(Bitmap.CompressFormat.JPEG, qualityPercent, fos);
                fos.flush();
            }

            JSObject result = new JSObject();
            result.put("uri", Uri.fromFile(outputFile).toString());
            result.put("width", bitmap.getWidth());
            result.put("height", bitmap.getHeight());

            bitmap.recycle();

            return result;
        } finally {
            try {
                retriever.release();
            } catch (Exception e) {
                Log.w(TAG, "Error releasing MediaMetadataRetriever", e);
            }
        }
    }

    @PluginMethod
    public void getPluginVersion(final PluginCall call) {
        try {
            final JSObject ret = new JSObject();
            ret.put("version", this.pluginVersion);
            call.resolve(ret);
        } catch (final Exception e) {
            call.reject("Could not get plugin version", e);
        }
    }

    @Override
    protected void handleOnDestroy() {
        super.handleOnDestroy();
        executor.shutdown();
    }
}
