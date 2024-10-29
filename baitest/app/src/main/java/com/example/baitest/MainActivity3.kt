package com.example.baitest

import android.os.Bundle
import android.widget.ImageView
import android.widget.TextView
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

class MainActivity3 : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main3)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
        val id = findViewById<TextView>(R.id.textView3)
        val name = findViewById<TextView>(R.id.textView4)
        val d_toan = findViewById<TextView>(R.id.textView5)
        val d_ly = findViewById<TextView>(R.id.textView6)
        val d_hoa = findViewById<TextView>(R.id.textView7)
        val exit = findViewById<ImageView>(R.id.btn_exit)

        val a = intent


        val iddStr = a.getStringExtra("id")
        val namee = a.getStringExtra("name") ?: ""
        val toan = a.getStringExtra("d_toan") ?: ""
        val ly = a.getStringExtra("d_ly") ?: ""
        val hoa = a.getStringExtra("d_hoa") ?: ""


        val idd = iddStr?.toIntOrNull() ?: 0


        id.setText("id: ${idd}")  // idd được chuyển đổi lại thành String
        name.setText("name: ${namee}")
        d_toan.setText("điểm toán: ${toan}")
        d_ly.setText("Điểm lý: ${ly}")
        d_hoa.setText("Điểm hóa: ${hoa}")

        exit.setOnClickListener {
            finish()
        }

    }
}