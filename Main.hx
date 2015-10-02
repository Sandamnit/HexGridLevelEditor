package;

import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;

/**
 * ...
 * @author Jeffery Hein
 */
class Main extends Sprite 
{
	public static var menu:Menu;
	
	public function new() {
		super();
		
		var tf:TextField = new TextField();
		tf.defaultTextFormat = new TextFormat("Arial", 10, 0xffffff);
		tf.x = 10;
		tf.y = 10;
		tf.selectable = true;
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.text = "";
		
		var worldmap:WorldMap = new WorldMap(5, 21.0, tf, "FDFCCQDEAAFACWDCDLBBIPPPPPPPNNNNNNJBDGMIBD");
		this.addChild(worldmap);
		worldmap.x = Lib.current.stage.stageWidth / 2;
		worldmap.y = Lib.current.stage.stageHeight / 2;
		
		worldmap.updateCode();
		this.addChild(tf);
		
		Main.menu = new Menu();
		Main.menu.addItem(new Text("(1) Add/Remove", 0x101010));
		Main.menu.addItem(new Text("(2) Starting Position", 0x00ff00));
		Main.menu.addItem(new Text("(3) Ending Position", 0xff0000));
		Main.menu.addItem(new Text("(4) AI Position", 0x0000ff));
		Main.menu.addItem(new Text("(5) AI Orientation", 0x0000ff));
		
		this.addChild(Main.menu);
		Main.menu.x = 10; Main.menu.y = 50;
		
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, worldmap.keyDown);
	}
}
