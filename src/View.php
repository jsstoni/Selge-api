<?php
/**
 * Template
 */
namespace src;

class View
{
    private static $_args = array();
    private static $_menus = array();
    private static $_menuSelected = '';

    private static function checkExists($file)
    {
        $pathFile = ROOT . 'views' . DS . $file.".php";
        if (file_exists($pathFile)) {
            foreach (self::$_args as $key => $value) {
                ${$key} = $value;
            }
            include_once $pathFile;
        } else {
            echo 'Template no existe';
        }
    }

    private static function _fn($buffer)
    {
        $parms = self::$_args;
        //loop
        $buffer = preg_replace_callback('/{{loop (?P<name>\w+)}}(?P<inner>.*?){{endloop}}/is', function ($match) use ($parms) {
            if (isset($parms[$match['name']]) && is_array($parms[$match['name']])) {
                $buffer = '';
                foreach ($parms[$match['name']] as $key => $value) {
                    $parms['loop'] = $value;
                    $buffer .= preg_replace_callback('/{{(\w+)}}/is', function ($v) use (&$value) {
                        if (isset($value[$v[1]])) {
                            return $value[$v[1]];
                        } else {
                            return '{{'.$v[1].'}}';
                        }
                    }, $match['inner']);
                }
                return $buffer;
            }
        }, $buffer);
        //var
        $buffer = preg_replace_callback('/{{(?P<name>\w+)}}/is', function ($match) use ($parms) {
            if (isset($parms[$match['name']])) {
                return htmlspecialchars($parms[$match['name']]);
            } else {
                return '{{'.$match['name'].'}}';
            }
        }, $buffer);
        return $buffer;
    }

    public static function newUrl($str = '')
    {
        if (filter_var($str, FILTER_VALIDATE_URL)) {
            return $str;
        }
        return rtrim('/'.URLBASE.'/'.$str, '/');
    }

    public static function newMedia($type, $str = '')
    {
        if (filter_var($str, FILTER_VALIDATE_URL)) {
            return $str;
        }
        $protocol = stripos($_SERVER['SERVER_PROTOCOL'], 'https') === 0 ? 'https://' : 'http://';
        $url = "{$protocol}{$_SERVER['HTTP_HOST']}/".URLBASE."/assets/{$type}/{$str}";
        return rtrim($url, '/');
    }

    public static function toAssignMenu($id)
    {
        if (self::$_menuSelected == $id || $id == floor(self::$_menuSelected)) {
            echo ' class="active"';
        }
    }

    public static function assignedMenu($id)
    {
        self::$_menuSelected = $id;
    }

    public static function render($file, $args = array())
    {
        self::$_args = $args;
        ob_start(array('self', '_fn'));
        self::checkExists($file);
        return ob_get_contents();
    }
}
