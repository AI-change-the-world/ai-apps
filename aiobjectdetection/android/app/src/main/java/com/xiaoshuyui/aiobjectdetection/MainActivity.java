package com.xiaoshuyui.aiobjectdetection;


import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.StrictMode;

import androidx.annotation.Nullable;

import com.xiaoshuyui.aiobjectdetection.utils.DetectionResult;
import com.xiaoshuyui.aiobjectdetection.utils.PrePostProcessor;

import org.pytorch.IValue;
import org.pytorch.LiteModuleLoader;
import org.pytorch.Module;
import org.pytorch.Tensor;
import org.pytorch.torchvision.TensorImageUtils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.FutureTask;


import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String channel = "yolov5";
    private Bitmap _bitmap = null;
    private Module module;
    private float mImgScaleX, mImgScaleY, mIvScaleX, mIvScaleY, mStartX, mStartY;
    InputStream inputStream = null;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), channel).setMethodCallHandler(
                (call, result) -> {
                    _bitmap = null;
                    module = null;
                    if (call.method != null) {
                        result.success(detection((String) call.arguments));
                    } else {
                        result.notImplemented();
                    }
                }
        );
    }

    private String detection(String imgPath) {

        try {
            String filepath = imgPath;
            System.out.println("===========================");
            System.out.println(filepath);
            System.out.println("===========================");
            module = LiteModuleLoader.load(MainActivity.assetFilePath(getApplicationContext(), "yolov5s.torchscript.ptl"));
            BufferedReader br = new BufferedReader(new InputStreamReader(getAssets().open("classes.txt")));
            String line;
            List<String> classes = new ArrayList<>();
            while ((line = br.readLine()) != null) {
                classes.add(line);
            }
            PrePostProcessor.mClasses = new String[classes.size()];
            classes.toArray(PrePostProcessor.mClasses);
            inputStream = new FileInputStream(new File(filepath));
            _bitmap = BitmapFactory.decodeStream(inputStream);

            Detection detection = new Detection();

            FutureTask futureTask = new FutureTask(detection);

            Thread thread = new Thread(futureTask);
            thread.start();
            ArrayList<DetectionResult> results = (ArrayList<DetectionResult>) futureTask.get();
            if (results.isEmpty()) {
                System.out.println("nothing");
            } else {
                for (int i = 0;i< results.size();i++){
                    System.out.println(results.get(i).toString());
                }

            }

            return "ojbk";


        } catch (ExecutionException | InterruptedException | IOException e) {
            e.printStackTrace();
            return "not ok";
        }


    }

    private static String getFilePath(String filename) {
        String filepath = "";
        String[] tmp = filename.trim().split("/");
        for (int i = 1; i < tmp.length - 1; i++) {
            filepath += "/" + tmp[i];
        }
        System.out.println("filepath:" + filepath);
        return tmp[0] + filepath;
    }

    class Detection implements Callable<ArrayList<DetectionResult>> {

        @Override
        public ArrayList<DetectionResult> call() throws Exception {
//        return null;
            Bitmap resizedBitmap = Bitmap.createScaledBitmap(_bitmap, PrePostProcessor.mInputWidth, PrePostProcessor.mInputHeight, true);
            final Tensor inputTensor = TensorImageUtils.bitmapToFloat32Tensor(resizedBitmap, PrePostProcessor.NO_MEAN_RGB, PrePostProcessor.NO_STD_RGB);
            IValue[] outputTuple = module.forward(IValue.from(inputTensor)).toTuple();
            final Tensor outputTensor = outputTuple[0].toTensor();
            final float[] outputs = outputTensor.getDataAsFloatArray();
            final ArrayList<DetectionResult> results = PrePostProcessor.outputsToNMSPredictions(outputs, mImgScaleX, mImgScaleY, mIvScaleX, mIvScaleY, mStartX, mStartY);
            return results;
        }

    }


    public static String assetFilePath(Context context, String assetName) throws IOException {
        File file = new File(context.getFilesDir(), assetName);
        if (file.exists() && file.length() > 0) {
            return file.getAbsolutePath();
        }

        try (InputStream is = context.getAssets().open(assetName)) {
            try (OutputStream os = new FileOutputStream(file)) {
                byte[] buffer = new byte[4 * 1024];
                int read;
                while ((read = is.read(buffer)) != -1) {
                    os.write(buffer, 0, read);
                }
                os.flush();
            }
            return file.getAbsolutePath();
        }
    }


}
