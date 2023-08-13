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

public class Camera extends AppCompatActivity {

    private Button btn_takePicture;
    private TextView[][] outLabels;
    private ImageView imgDisplay;
    private Uri imageUri;
    private Button toMainActivity;
    private Button firstArchLabel;
    private Button secondArchLabel;
    private Button thirdArchLabel;

    private Interpreter tflite;
    private ArrayList<String> labelList;

    public static final int REQUEST_IMAGE = 100;
    public static final int REQUEST_PERMISSION = 300;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_camera);

        requestPermissions();

        btn_takePicture = (Button) findViewById(R.id.btn_takepicture);

        outLabels = new TextView[3][3];
        int[][] inps = {
                {R.id.btn_label1, R.id.tv_percentage1},
                {R.id.btn_label2, R.id.tv_percentage2},
                {R.id.btn_label3, R.id.tv_percentage3},
        };
        for (int i = 0; i < inps.length; i++)
            for (int j = 0; j < inps[0].length; j++)
                outLabels[i][j] = (TextView) findViewById(inps[i][j]);

        imgDisplay = (ImageView) findViewById(R.id.img_display);

        try {
            labelList = Helper.loadLabelList(this.getAssets());
            tflite = new Interpreter(Helper.loadModelFile(this.getAssets()), new Interpreter.Options());
        } catch (IOException e) {
            e.printStackTrace();
        }

        btn_takePicture.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openCameraIntent();
            }
        });

        // switching screens
        toMainActivity = findViewById(R.id.btn_backToMainFromCam);

        toMainActivity.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openMainActivity();
            }
        });


        firstArchLabel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String buttonText = (String) firstArchLabel.getText();
                openArchitecturePage(buttonText);
            }
        });
        secondArchLabel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String buttonText = (String) secondArchLabel.getText();
                openArchitecturePage(buttonText);
            }
        });
        thirdArchLabel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String buttonText = (String) thirdArchLabel.getText();
                openArchitecturePage(buttonText);
            }
        });
    }

    private void openMainActivity(){
        Intent intent = new Intent(Camera.this,MainActivity.class);
        startActivity(intent);
    }

    private void openArchitecturePage(String buttonText){
        Intent intent = null;
        if (buttonText == "Bauhaus")
        {
            intent = new Intent(Camera.this,BauhausActivity.class);
        }
        if (buttonText == "Achaemenid")
        {
            intent = new Intent(Camera.this,AchaemenidActivity.class);
        }
        if (buttonText == "Novelty")
        {
            intent = new Intent(Camera.this,NoveltyActivity.class);
        }
        startActivity(intent);
    }

    private void requestPermissions() {
        int PERMISSION_ALL = 1;
        String[] PERMISSIONS = {
                Manifest.permission.WRITE_EXTERNAL_STORAGE,
                Manifest.permission.READ_EXTERNAL_STORAGE,
                android.Manifest.permission.CAMERA
        };

        if (!Helper.hasPermissions(this, PERMISSIONS)) {
            ActivityCompat.requestPermissions(this, PERMISSIONS, PERMISSION_ALL);
        }
    }

    private void openCameraIntent() {
        ContentValues values = new ContentValues();
        values.put(MediaStore.Images.Media.TITLE, "New Picture");
        values.put(MediaStore.Images.Media.DESCRIPTION, "From your Camera");

        // tell camera where to store the resulting picture
        imageUri = getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        intent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri);
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

        // start the intent and wait for it to finish (c.f. async requests)
        startActivityForResult(intent, REQUEST_IMAGE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data){
        super.onActivityResult(requestCode, resultCode, data);

        // if the camera activity is finished, obtained the uri, crop it to make it square, and send it to 'Classify' activity
        if(requestCode == REQUEST_IMAGE && resultCode == RESULT_OK) {
            try {
                Uri source_uri = imageUri;
                Uri dest_uri = Uri.fromFile(new File(getCacheDir(), "cropped"));
                // need to crop it to square image as CNN's always required square input
                Crop.of(source_uri, dest_uri).asSquare().start(this);
            } catch (Exception e) {
                    e.printStackTrace();
            }
        }

        // if cropping acitivty is finished, get the resulting cropped image uri and send it to 'Classify' activity
        else if(requestCode == Crop.REQUEST_CROP && resultCode == RESULT_OK){
            classifyImage(Crop.getOutput(data));
        }
    }

    private void classifyImage(Uri uri) {
        int imageSizeX = Helper.DIM_IMG_SIZE_X;
        int imageSizeY = Helper.DIM_IMG_SIZE_Y;
        int imagePixelSize = Helper.DIM_PIXEL_SIZE;

        // initialize array that holds image data
        int[] imgArray = new int[imageSizeX * imageSizeY];

        // initialize byte array.
        ByteBuffer imgData =  ByteBuffer.allocateDirect(4 * imageSizeX * imageSizeY * imagePixelSize);
        imgData.order(ByteOrder.nativeOrder());

        // initialize probabilities array.
        float[][] labelProbArray = new float[1][labelList.size()];

        try {
            Bitmap bitmap = MediaStore.Images.Media.getBitmap(getContentResolver(), uri);
            imgDisplay.setImageBitmap(bitmap);
        } catch (IOException e) {
            e.printStackTrace();
        }

        // get current bitmap from imageView
        Bitmap bitmap_orig = ((BitmapDrawable) imgDisplay.getDrawable()).getBitmap();
        // resize the bitmap to the required input size to the CNN
        Bitmap bitmap = Helper.getResizedBitmap(bitmap_orig, imageSizeX, imageSizeY);
        // convert bitmap to byte array
        imgData = Helper.convertBitmapToByteBuffer(bitmap, imgData, imgArray);
        // pass byte data to the graph
        tflite.run(imgData, labelProbArray);

        ArrayList<Pair<Float, Integer>> toSort = new ArrayList<>();
        for (int i = 0; i < labelList.size(); i++) {
            toSort.add(new Pair<Float, Integer>(labelProbArray[0][i], i));
        }

        Collections.sort(toSort, new Comparator<Pair<Float, Integer>>() {
            @Override
            public int compare(Pair<Float, Integer> o1, Pair<Float, Integer> o2) {
                float diff = o1.first - o2.first;
                if (diff < 0) return 1;
                else if (diff == 0) return 0;
                else return -1;
            }
        });

        for (int i = 0; i < 3; i++) {
            outLabels[i][0].setText(labelList.get(toSort.get(i).second));
            outLabels[i][1].setText(Float.toString(toSort.get(i).first * 100f) + "%");
        }
    }
}