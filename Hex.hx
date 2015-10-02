package;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;
import openfl.Vector;
import openfl.display.Sprite;
import openfl.display.GraphicsPathCommand;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Jeffery Hein (testing)
 */
class Hex extends Sprite
{
	private var commands:Vector<Int> = new Vector<Int>();
	private var data:Vector<Float> = new Vector<Float>();
	private var _height:Float;
	private var _width:Float;
	public var _x:Int;
	public var _y:Int;
	public var _z:Int;
	public var active:Bool = true;
	public var orientation:Int = 0;
	public var aiType:Int = 0;
	public var aiText:TextField = new TextField();
	
	public static var aiMax:Int = 5;
	
	public function new(height:Float, _x:Int, _y:Int, _z:Int) {
		super();
		
		this._x = _x;
		this._y = _y;
		this._z = _z;
		this._height = height - 2;
		this._width = 2 * this._height / Math.sqrt(3);
		
		for (k in 0...7) {
			var theta:Float = k * Math.PI / 3;
			this.data.push(this._width * Math.cos(theta));
			this.data.push(this._width * Math.sin(theta));
			this.commands.push(k == 0 ? GraphicsPathCommand.MOVE_TO : GraphicsPathCommand.LINE_TO);
		}
		
		this.aiText.defaultTextFormat = new TextFormat("Arial", 15, 0x000000);
		this.aiText.text = "" + this.aiType;
		this.aiText.x = -5;
		this.aiText.y = -10;
		this.aiText.selectable = false;
		this.aiText.visible = false;
		this.aiText.width = 20;
		this.aiText.height = 20;
		this.addChild(this.aiText);
		
		this.draw();
		
		this.addEventListener(MouseEvent.CLICK, this.toggleActive);
	}
	
	public function draw():Void {
		var worldmap:WorldMap = this.parent == null ? null : cast this.parent;
		var isStart:Bool = this == WorldMap.startPos;
		var isEnd:Bool = this == WorldMap.endPos;
		var isAI:Bool = false;
		
		if (worldmap != null) {
			for (k in 0...worldmap.aiList.length) {
				isAI = isAI || worldmap.aiList[k] == this;
			}
		}
		
		this.graphics.clear();
		this.graphics.lineStyle(1.0, this.active ? 0x808080 : 0x202020, 1.0);
		this.graphics.beginFill(this.active ? (isStart ? 0x00ff00 : (isEnd ? 0xff0000 : (isAI ? 0x0000ff : 0x101010))) : 0x000000, 1.0);
		this.graphics.drawPath(this.commands, this.data);
		this.graphics.endFill();
		
		if (isStart || isAI) {
			this.graphics.lineStyle(3.0, 0x000000, 1.0);
			var _commands:Vector<Int> = [ GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO ];
			var _data:Vector<Float> = new Vector<Float>();
			var theta1:Float = this.orientation * Math.PI / 3;
			var theta2:Float = theta1 - Math.PI / 3;
			_data.push((this._width - 5) * Math.cos(theta1));
			_data.push((this._width - 5) * Math.sin(theta1));
			_data.push((this._width - 5) * Math.cos(theta2));
			_data.push((this._width - 5) * Math.sin(theta2));
			this.graphics.drawPath(_commands, _data);
			this.graphics.endFill();
		}
		
		if (isAI) {
			this.aiText.visible = true;
			this.aiText.text = "" + this.aiType;
		}
		else {
			this.aiText.visible = false;
		}
	}
	
	private function toggleActive(e:MouseEvent):Void {
		var worldmap:WorldMap = cast this.parent;
		
		if (this.active) {
			var aiIndex:Int = -1;
			
			var isAI:Bool = false;
			for (k in 0...worldmap.aiList.length) {
				isAI = isAI || worldmap.aiList[k] == this;
				if (worldmap.aiList[k] == this) { aiIndex = k; }
			}
			
			if (WorldMap.chooseStart && this != WorldMap.endPos && !isAI) {
				var oldStart:Hex = WorldMap.startPos;
				
				if (oldStart == this) {
					this.orientation = (this.orientation + 1) % 6;
				}
				
				WorldMap.startPos = this;
				this.draw();
				if (oldStart != null) { oldStart.draw(); }
			}
			else if (WorldMap.chooseEnd && this != WorldMap.startPos && !isAI) {
				var oldEnd:Hex = WorldMap.endPos;
				WorldMap.endPos = this;
				this.draw();
				if (oldEnd != null) { oldEnd.draw(); }
			}
			else if ((WorldMap.addAI || WorldMap.orientAI) && this != WorldMap.startPos && this != WorldMap.endPos) {
				if (isAI) {
					if (WorldMap.addAI) {
						this.aiType++;
						if (this.aiType == Hex.aiMax) {
							worldmap.aiList.remove(this);
							isAI = false;
							this.aiType = 0;
						}
					}
					else {
						this.orientation = (this.orientation + 1) % 6;
					}
				}
				else if (WorldMap.addAI) {
					worldmap.aiList.push(this);
				}
				this.draw();
			}
		}
		
		if (!WorldMap.addAI && !WorldMap.orientAI && !WorldMap.chooseStart && !WorldMap.chooseEnd) {
			if (this != WorldMap.endPos && this != WorldMap.startPos) {
				var value:Bool = false;
				
				for (k in 0...worldmap.aiList.length) {
					value = value || (this == worldmap.aiList[k]);
				}
				
				if (!value) {
					this.active = !this.active;
					this.draw();
				}
			}
		}
		
		worldmap.updateCode();
	}
	
	public function deactive():Void {
		this.active = false;
		this.draw();
	}
	
	public function activate():Void {
		this.active = true;
		this.draw();
	}
}
