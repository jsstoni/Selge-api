<?php
namespace controllers;

use src\Controller;
use src\View;
use src\Helper;
class App extends Controller
{
	public function index($request)
	{
	}

	public function checkUser($request)
	{
		if (Helper::getAuthorizationNoDecode() == '3dae4f3d20fd4f666') {
			$req = $request->getInputs();
			$usuario = $this->getModel('Usuario')->setData(['user' => $req['user']]);
			$user = $usuario->checkUser();
			if (sizeof($user) > 0) {
				echo json_encode(['id' => Helper::codificar($user[0]['ID']), 'header' => View::newMedia('upload', $user[0]['header']), 'logo' => View::newMedia('upload', $user[0]['logo'])]);
			}else {
				echo json_encode(['error' => 'no existe']);
			}
		}
	}
}