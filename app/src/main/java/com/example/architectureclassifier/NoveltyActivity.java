package com.example.architectureclassifier;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class NoveltyActivity extends AppCompatActivity {
    private Button btn_backToMainFromNovelty;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_novelty);

        btn_backToMainFromNovelty = findViewById(R.id.btn_backToMainFromNovelty);

        btn_backToMainFromNovelty.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                openMainActivity();
            }
        });
    }

    private void openMainActivity(){
        Intent intent = new Intent(NoveltyActivity.this,MainActivity.class);
        startActivity(intent);
    }
}