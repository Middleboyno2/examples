package com.example.baitest

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
        var btn = findViewById<Button>(R.id.button)
        var id = findViewById<EditText>(R.id.id)
        var name = findViewById<EditText>(R.id.name)
        var d_toan = findViewById<EditText>(R.id.d_toan)
        var d_ly = findViewById<EditText>(R.id.d_ly)
        var d_hoa = findViewById<EditText>(R.id.d_hoa)
        btn.setOnClickListener {
            var a = Intent(this, MainActivity2::class.java)
            a.putExtra("id", id.text.toString())
            a.putExtra("name", name.text.toString())
            a.putExtra("d_toan", d_toan.text.toString())
            a.putExtra("d_ly", d_ly.text.toString())
            a.putExtra("d_hoa", d_hoa.text.toString())
            startActivity(a)
            finish()

        }
    }
}