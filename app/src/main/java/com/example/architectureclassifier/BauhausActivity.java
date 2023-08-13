package com.example.architectureclassifier;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class BauhausActivity extends AppCompatActivity {
    private Button btn_backToMainFromBauhaus;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bauhaus);

        btn_backToMainFromBauhaus = findViewById(R.id.btn_backToMainFromBauhaus);

        btn_backToMainFromBauhaus.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                openMainActivity();
            }
        });
    }

    private void openMainActivity(){
        Intent intent = new Intent(BauhausActivity.this,MainActivity.class);
        startActivity(intent);
    }
}