<?php namespace App\Database\Seeds;
Class FruitSeeder extends \CodeIgniter\Database\Seeder{

    public function run(){
        $data1=[
            'fruit_name'=>'jeruk',
            'is_available'=>'Available'
        ];
        $data2=[
            'fruit_name'=>'mangga',
            'is_available'=>'Available'
        ];
        $this->db->table('fruits')->insert($data1);
        $this->db->table('fruits')->insert($data2);
    }


}

?>