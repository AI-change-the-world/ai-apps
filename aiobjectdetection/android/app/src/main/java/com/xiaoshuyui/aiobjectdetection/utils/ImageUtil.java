package com.xiaoshuyui.aiobjectdetection.utils;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.util.Base64;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class ImageUtil {
    public static Bitmap zoomBitmap(int width, int height, String imgPath) {
        BitmapFactory.Options options = new BitmapFactory.Options();
        Bitmap bitmap = BitmapFactory.decodeFile(imgPath);
        float scaleWidth = (float) width / bitmap.getWidth();
        float scaleHeight = (float) height / bitmap.getHeight();
        Matrix matrix = new Matrix();
        matrix.setScale(scaleWidth, scaleHeight);
        Bitmap scaleBitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
//        bitmap.recycle();
        if(scaleBitmap!=bitmap){
            bitmap.recycle();
        }
        return scaleBitmap;
    }

    public static Bitmap bitmapFromRGBImageAsFloatArray(float[] data, int width, int height) {

        Bitmap bmp = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        for (int i = 0; i < width * height; i++) {
            int r = (int) ((data[i] * 0.5 + 0.5) * 255.0f);
            int g = (int) ((data[i + width * height] * 0.5 + 0.5) * 255.0f);
            int b = (int) ((data[i + width * height * 2] * 0.5 + 0.5) * 255.0f);

            int x = i / width;
            int y = i % width;

            int color = Color.rgb(r, g, b);
            bmp.setPixel(x, y, color);
        }
        return bmp;
    }

    public static Bitmap adjustPhotoRotation(Bitmap bm, int degree) {
        Matrix m = new Matrix();
        m.setRotate(degree, (float) bm.getWidth() / 2, (float) bm.getHeight() / 2);
        m.postScale(-1,1);

        try {
            Bitmap bm1 = Bitmap.createBitmap(bm, 0, 0, bm.getWidth(), bm.getHeight(), m, true);

            return bm1;

        } catch (OutOfMemoryError ex) {
        }
        return null;
    }

    public static String bitmapToBase64(Bitmap bitmap) {
        String result = "";
        ByteArrayOutputStream bos = null;
        try {
            if (null != bitmap) {
                bos = new ByteArrayOutputStream();
                bitmap.compress(Bitmap.CompressFormat.JPEG, 90, bos);//将bitmap放入字节数组流中
                bos.flush();//将bos流缓存在内存中的数据全部输出，清空缓存
                bos.close();
                byte[] bitmapByte = bos.toByteArray();
                result = Base64.encodeToString(bitmapByte, Base64.DEFAULT);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (bos != null) {
                try {
                    bos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return result;
    }

    public static void saveBitmap(Bitmap bitmap,String savePath){
        File f = new File(savePath);
        if (f.exists()){
            f.delete();
        }

        try{
            FileOutputStream out = new FileOutputStream(f);
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, out);
            out.flush();
            out.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
