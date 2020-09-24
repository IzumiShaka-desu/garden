<?php namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class Fruits extends Migration
{
	public function up()
	{
		
		$this->forge->addField(
			[
				'fruit_id'=>[
					'type'=>'BIGINT',
					'constraint'=>20,
					'unsigned'=>TRUE,
					'auto_increment'=>TRUE
				],
				'fruit_name'=>[
					'type'=>'VARCHAR',
					'constraint'=>	100,
				],
				'is_available'	=>[
					'type'=>'ENUM',
					'constraint'=>"'Available','Not-available'",
					'default'=>'Available'
				]
			]
		);
		$this->forge->addKey('fruit_id',TRUE);
		$this->forge->createTable('fruits');
	}

	//--------------------------------------------------------------------

	public function down()
	{
		//
	}
}
