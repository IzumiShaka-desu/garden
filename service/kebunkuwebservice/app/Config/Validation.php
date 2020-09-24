<?php namespace Config;

class Validation
{
	//--------------------------------------------------------------------
	// Setup
	//--------------------------------------------------------------------

	/**
	 * Stores the classes that contain the
	 * rules that are available.
	 *
	 * @var array
	 */
	public $ruleSets = [
		\CodeIgniter\Validation\Rules::class,
		\CodeIgniter\Validation\FormatRules::class,
		\CodeIgniter\Validation\FileRules::class,
		\CodeIgniter\Validation\CreditCardRules::class,
	];

	/**
	 * Specifies the views that are used to display the
	 * errors.
	 *
	 * @var array
	 */
	public $templates = [
		'list'   => 'CodeIgniter\Validation\Views\list',
		'single' => 'CodeIgniter\Validation\Views\single',
	];
	public $fruit=[
		'fruit_name'=>'required',
		'is_available'=>'required'
	];
	public $fruit_errors=[
		'fruit_name'=>'Nama wajib diisi',
		'is_available'=>'status perlu diisi'
	];
	public $login=[
		'email'=>'required',
		'password'=>'required'
	];
	public $login_errors=[
		'email'=>'Nama wajib diisi',
		'password'=>'status perlu diisi'
	];
	
	//--------------------------------------------------------------------
	// Rules
	//--------------------------------------------------------------------
}
