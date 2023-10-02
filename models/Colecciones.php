<?php
namespace models;
use src\Model;
use src\Helper;

class Colecciones extends Model
{
	private $token;
    public function __construct()
    {
        $this->token = Helper::getAuthorization();
    }
 
	public function lista()
	{
		return self::getResult("SELECT * FROM colecciones WHERE usuario = '{$this->token}'");
	}

	public function crear()
	{
		$tags = $this->getData('tags');
		$id = $this->getData('id');
		if ($id) {
			return self::Update('colecciones', array('categoria' => $tags), "ID = '{$id}' AND usuario = '{$this->token}'");
		}else {
			return self::Insert("colecciones", array('categoria' => $tags, 'usuario' => $this->token));
		}
	}

	public function borrar()
	{
		$id = $this->getData('id');
		return self::Remove('colecciones', "ID = '{$id}' AND usuario = '{$this->token}'");
	}
}