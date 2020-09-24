<?php namespace App\Models;

use CodeIgniter\Model;

class Auth_model extends Model{
    protected $table='userlogin';
    public function login($email,$password){
        if($email==='' && $password===''){
            return false;
        }
        else{$result=$this->db->table($this->table)->getWhere(['email'=>$email,'password'=>sha1($password)])->getRowArray();
        if($result){
            if ($result!==NULL)
            
            {
                return [
                'result'=>true,
                'message'=>'login berhasil',
                'email'=>$result['email'],
                'fullname'=>$result['fullname']
            ];
        }else{
            
                return [
                'result'=>false,
                'message'=>'login gagal',
            ];
        }
        }else{
            return [
                'result'=>false,
                'message'=>'login gagal',
            ];
        }}
    }
    public function Register($email,$password,$fullname){
       $result=$this->db->table($this->table)->getWhere(['email'=>$email]);
       if(($result->getRowArray()!==NULL)){
            return [
                'result'=>false,
                'message'=>'email telah digunakan',
            ];
       }
        else{
        
            $result=$this->db->table($this->table)->insert([
                'email'=>$email,
                'fullname'=>$fullname,
                'password'=>sha1($password)
            ]);
            if($result){
            return [
                'result'=>true,
                'message'=>'register berhasil'
            ];}else{
                return [
                    'result'=>false,
                    'message'=>'terjadi kesalahan'
                ];
            }
        }
    }
}
