<?php namespace App\Models;

use CodeIgniter\Model;

class Fruit_model extends Model{
    Protected $table='fruits';
    public function getFruit($id=false){
            if($id===false){
                return $this->findAll();
            }else{
                return $this->getWhere(['id'=>$id])->getRowArray();
            }
    }
    public function insertFruit($data){
        return $this->db->table($this->table)->insert($data);
    }
    public function deleteFruit($id){
        return $this->db->table($this->table)->delete(['id'=>$id]);
    }
    
}
?>