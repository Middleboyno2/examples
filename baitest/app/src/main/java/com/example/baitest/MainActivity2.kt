package com.example.baitest

import android.content.Intent
import android.os.Bundle
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.ListView
import android.widget.TableLayout
import android.widget.TableRow
import android.widget.TextView
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
var list:MutableList<SinhVien> = mutableListOf()
class MainActivity2 : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main2)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
        display_list_item()

        val btn_add = findViewById<Button>(R.id.btn_thêm)
        val btn_top = findViewById<Button>(R.id.btn_student_grade_high)
        val btn_low = findViewById<Button>(R.id.btn_student_grade_low)

        btn_add.setOnClickListener {
            val a = Intent(this, MainActivity::class.java)
            startActivity(a)
        }
        btn_top.setOnClickListener {
            val a =Intent(this, MainActivity3::class.java)

            val sinhVienDiemCaoNhat = list.maxByOrNull { it.tongDiem }

            a.putExtra("id", sinhVienDiemCaoNhat?.get_id().toString())
            a.putExtra("name", sinhVienDiemCaoNhat?.get_name().toString())
            a.putExtra("d_toan", sinhVienDiemCaoNhat?.get_d_toan().toString())
            a.putExtra("d_ly", sinhVienDiemCaoNhat?.get_d_ly().toString())
            a.putExtra("d_hoa", sinhVienDiemCaoNhat?.get_d_hoa().toString())

            startActivity(a)
        }

        btn_low.setOnClickListener {
            val a =Intent(this, MainActivity3::class.java)

            val sinhVienDiemThapNhat = list.minByOrNull { it.tongDiem }
            sinhVienDiemThapNhat?.let {
                a.putExtra("id", it.get_id().toString())
                a.putExtra("name", it.get_name())
                a.putExtra("d_toan", it.get_d_toan().toString())
                a.putExtra("d_ly", it.get_d_ly().toString())
                a.putExtra("d_hoa", it.get_d_hoa().toString())
            }
            startActivity(a)
        }
    }


    private fun display_list_item() {

        if(list.size == 0){
            list.add(SinhVien(1,"Hoang",5f, 6f, 6f))
            list.add(SinhVien(2,"Hieu",5f, 6f, 9f))
        }
        val b = intent
        if (b != null){
            val id = b.getStringExtra("id")
            val name = b.getStringExtra("name")
            val d_toan = b.getStringExtra("d_toan")
            val d_ly = b.getStringExtra("d_ly")
            val d_hoa = b.getStringExtra("d_hoa")


            if (id != null && name != null && d_toan != null && d_ly != null && d_hoa != null) {
                try {
                    val id = id.toInt()
                    val d_toan = d_toan.toFloat()
                    val d_ly = d_ly.toFloat()
                    val d_hoa = d_hoa.toFloat()

                    list.add(SinhVien(id, name, d_toan, d_ly, d_hoa))
                } catch (e: NumberFormatException) {
                    e.printStackTrace()
                    // Có thể hiển thị thông báo lỗi cho người dùng hoặc xử lý theo cách khác
                    Toast.makeText(this, "Dữ liệu sai định dạng", Toast.LENGTH_LONG).show()
                }
            }

        }

        val table_layout = findViewById<TableLayout>(R.id.listview)
        for(row in list){
            val tableRow = TableRow(this)

            val textView1 = TextView(this)
            textView1.text = row.get_id().toString()
            textView1.setPadding(16, 16, 16, 16) // Đặt padding cho TextView
            textView1.textSize = 16f

            val textView2 = TextView(this)
            textView2.text = row.get_name().toString()
            textView2.setPadding(16, 16, 16, 16) // Đặt padding cho TextView
            textView2.textSize = 16f

            val textView3 = TextView(this)
            textView3.text = row.get_d_toan().toString()
            textView3.setPadding(16, 16, 16, 16) // Đặt padding cho TextView
            textView3.textSize = 16f

            val textView4 = TextView(this)
            textView4.text = row.get_d_ly().toString()
            textView4.setPadding(16, 16, 16, 16) // Đặt padding cho TextView
            textView4.textSize = 16f

            val textView5 = TextView(this)
            textView5.text = row.get_d_hoa().toString()
            textView5.setPadding(16, 16, 16, 16) // Đặt padding cho TextView
            textView5.textSize = 16f

            // Thêm TextView vào TableRow
            tableRow.addView(textView1)
            tableRow.addView(textView2)
            tableRow.addView(textView3)
            tableRow.addView(textView4)
            tableRow.addView(textView5)

            table_layout.addView(tableRow)

        }

    }
}