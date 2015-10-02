package;
import openfl.display.Sprite;

/**
 * ...
 * @author Jeffery Hein
 */
class Menu extends Sprite
{
	public var menuList:Array<Text> = new Array<Text>();
	
	public function new() {
		super();
	}
	
	public function addItem(text:Text):Void {
		if (this.menuList.length == 0) { text.selected = true; text.draw(); }
		this.menuList.push(text);
		text.y = this.height;
		this.addChild(text);
	}
	
	public function selectItem(index:Int):Void {
		for (k in 0...this.numChildren) {
			var text:Text = cast this.getChildAt(k);
			text.selected = k == index;
			text.draw();
		}
		
		switch (index) {
			case 0:
				WorldMap.chooseStart = false;
				WorldMap.chooseEnd = false;
				WorldMap.addAI = false;
				WorldMap.orientAI = false;
			case 1:
				WorldMap.chooseStart = true;
				WorldMap.chooseEnd = false;
				WorldMap.addAI = false;
				WorldMap.orientAI = false;
			case 2:
				WorldMap.chooseStart = false;
				WorldMap.chooseEnd = true;
				WorldMap.addAI = false;
				WorldMap.orientAI = false;
			case 3:
				WorldMap.chooseStart = false;
				WorldMap.chooseEnd = false;
				WorldMap.addAI = true;
				WorldMap.orientAI = false;
			case 4:
				WorldMap.chooseStart = false;
				WorldMap.chooseEnd = false;
				WorldMap.addAI = false;
				WorldMap.orientAI = true;
		}
	}
}
