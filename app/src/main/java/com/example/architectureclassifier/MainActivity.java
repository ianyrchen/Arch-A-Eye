package com.example.architectureclassifier;

import androidx.appcompat.app.AppCompatActivity;
import org.tensorflow.lite.Interpreter;
import android.os.Bundle;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.util.Pair;

import android.Manifest;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import org.tensorflow.lite.Interpreter;
import java.io.File;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import com.soundcloud.android.crop.Crop;

public class MainActivity extends AppCompatActivity {

    private Button btn_cam;
    private Button btn_archlib;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        btn_cam = findViewById(R.id.btn_cam);

        btn_cam.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                moveToActivityCam();

            }});

        btn_archlib = findViewById(R.id.btn_archlib);

        btn_archlib.setOnClickListener(new View.OnClickListener() {

            @Override
                public void onClick(View v) {

                    moveToActivityArchLibrary();

                }
        });

    }

    private void moveToActivityCam() {

        Intent intent = new Intent(MainActivity.this, Camera.class);
        startActivity(intent);
    }

    private void moveToActivityArchLibrary() {

        Intent intent = new Intent(MainActivity.this, ArchLibrary.class);
        startActivity(intent);
    }
}

