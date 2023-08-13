package com.example.architectureclassifier;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class ArchLibrary extends Activity {
    private Button toMainActivity;
    private Button toAchaemenid;
    private Button toBauhaus;
    private Button toNovelty;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_arch_library);

        toMainActivity = (Button) findViewById(R.id.btn_backToMainFromLib);

        toMainActivity.setOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View v) {
                openMainActivity();
            }
        });

        // styles
        toAchaemenid = findViewById(R.id.btn_achaemenid);

        toAchaemenid.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openAchaemenid();
            }
        });

        toBauhaus = findViewById(R.id.btn_bauhaus);

        toBauhaus.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openBauhaus();
            }
        });
        toNovelty = findViewById(R.id.btn_novelty);
        toNovelty.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openNovelty();
            }
        });
    }

    private void openMainActivity(){
        Intent intent = new Intent(ArchLibrary.this,MainActivity.class);
        startActivity(intent);
    }

    private void openAchaemenid(){
        Intent intent = new Intent(ArchLibrary.this,AchaemenidActivity.class);
        startActivity(intent);
    }

    private void openBauhaus(){
        Intent intent = new Intent(ArchLibrary.this,BauhausActivity.class);
        startActivity(intent);
    }

    private void openNovelty(){
        Intent intent = new Intent(ArchLibrary.this,NoveltyActivity.class);
        startActivity(intent);
    }

}
