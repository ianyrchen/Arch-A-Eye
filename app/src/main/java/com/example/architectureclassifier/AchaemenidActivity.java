package com.example.architectureclassifier;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class AchaemenidActivity extends AppCompatActivity {
    private Button btn_backToMainFromAchaemenid;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_achaemenid);

        btn_backToMainFromAchaemenid = findViewById(R.id.btn_backToMainFromAchaemenid);

        btn_backToMainFromAchaemenid.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                openMainActivity();
            }
        });
    }

    private void openMainActivity(){
        Intent intent = new Intent(AchaemenidActivity.this,MainActivity.class);
        startActivity(intent);
    }
}