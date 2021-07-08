package com.xiaoshuyui.aiobjectdetection.utils;

import android.graphics.Rect;

public class DetectionResult {
    int classIndex;
    Float score;
    Rect rect;

    public DetectionResult(int cls, Float output, Rect rect) {
        this.classIndex = cls;
        this.score = output;
        this.rect = rect;
    }

    @Override
    public String toString() {
        return "DetectionResult{" +
                "classIndex=" + classIndex +
                ", score=" + score +
                ", rect=" + rect +
                '}';
    }
};