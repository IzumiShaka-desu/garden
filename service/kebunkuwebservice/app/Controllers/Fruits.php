<?php namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;

class Fruits extends ResourceController{
        protected $format='json';
        protected $modelName='App\Models\Fruit_model';
        function index(){
            return $this->respond($this->model->findAll(),200);
        }
        
public function create()
{
    $validation =  \Config\Services::validation();
 
    $name   = $this->request->getPost('fruit_name');
    $status = $this->request->getPost('is_available');
     
    $data = [
        'fruit_name' => $name,
        'is_available' => $status
    ];
     
    if($validation->run($data, 'fruit') == FALSE){
        $response = [
            'status' => 500,
            'error' => true,
            'data' => $validation->getErrors(),
        ];
        return $this->respond($response, 500);
    } else {
        $simpan = $this->model->insertFruit($data);
        if($simpan){
            $msg = ['message' => 'Created fruit successfully'];
            $response = [
                'status' => 200,
                'error' => false,
                'data' => $msg,
            ];
            return $this->respond($response, 200);
        }
    }

}
public function delete($id=NULL){
    $result=$this->model->deleteFruit($id);
    if($result){
        $code=200;
        $message=['message'=>'sucessfully delete fruit'];
        $response=[
            'status'=>$code,
            'error'=>false,
            'data'=>$message
        ];


    }else{
        $code=404;
        $message=['message'=>'not found'];
        $response=[
            'status'=>$code,
            'error'=>true,
            'data'=>$message
        ];
         
    }
    return $this->respond($response,$code);
}
}
