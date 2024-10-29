package com.example.baitest

class SinhVien {
    private var id:Int = 0
    private var name:String = ""
    private var d_toan:Float = 0f
    private var d_ly:Float = 0f
    private var d_hoa:Float = 0f
    constructor(id:Int, name:String, d_toan:Float, d_ly:Float, d_hoa:Float){
        this.id = id
        this.name = name
        this.d_toan = d_toan
        this.d_ly = d_ly
        this.d_hoa = d_hoa
    }

    val tongDiem: Float
        get() = this.d_toan + this.d_ly + this.d_hoa

    fun get_id():Int{
        return this.id
    }
    fun get_name():String{
        return this.name
    }
    fun get_d_toan():Float{
        return this.d_toan
    }fun get_d_ly():Float{
        return this.d_ly
    }
    fun get_d_hoa():Float {
        return this.d_hoa
    }
}