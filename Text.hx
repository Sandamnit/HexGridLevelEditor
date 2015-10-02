package;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Jeffery Hein
 */
class Text extends Sprite
{
	public var tf:TextField;
	public var sprite:Sprite;
	public var selected:Bool = false;
	
	public function new(text:String, color:Int) {
		super();
		
		this.draw();
		
		this.tf = new TextField();
		this.tf.defaultTextFormat = new TextFormat("Arial", 12, 0xffffff);
		this.tf.text = text;
		this.tf.selectable = false;
		this.tf.autoSize = TextFieldAutoSize.LEFT;
		this.tf.x = 25;
		this.addChild(this.tf);
		
		this.sprite = new Sprite();
		this.sprite.graphics.beginFill(color, 1.0);
		this.sprite.graphics.drawRect(2, 2, 20, 20);
		this.sprite.graphics.endFill();
		this.addChild(this.sprite);
		
		this.addEventListener(MouseEvent.CLICK, this.onClick);
	}
	
	private function onClick(e:MouseEvent):Void {
		if (!Std.is(this.parent, Menu)) { return; }
		var menu:Menu = cast this.parent;
		var index:Int = menu.getChildIndex(this);
		menu.selectItem(index);
	}
	
	public function draw():Void {
		this.graphics.clear();
		this.graphics.beginFill(this.selected ? 0x808080 : 0x000000, this.selected ? 1.0 : 0.0);
		this.graphics.drawRect(0, 0, 150, 24);
		this.graphics.endFill();
	}
}
