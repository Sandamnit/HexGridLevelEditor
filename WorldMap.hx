package;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.text.TextField;

/**
 * ...
 * @author Jeffery Hein
 */
class WorldMap extends Sprite
{
	private static var directions:Array<Array<Int>> = [
		[ 1, -1, 0 ],
		[ 1, 0, -1 ],
		[ 0, 1, -1 ],
		[ -1, 1, 0 ],
		[ -1, 0, 1 ],
		[ 0, -1, 1 ]
	];
	
	public static var chooseStart:Bool = false;
	public static var chooseEnd:Bool = false;
	public static var addAI:Bool = false;
	public static var orientAI:Bool = false;
	
	public static var startPos:Hex = null;
	public static var endPos:Hex = null;
	
	private var radius:Int;
	private var _height:Float;
	private var _width:Float;
	private var text:TextField;
	private var coords:Array<Array<Int>>;
	private var hexes:Array<Hex> = new Array<Hex>();
	public var aiList:Array<Hex> = new Array<Hex>();
	
	public function new(radius:Int, height:Float, text:TextField, code:String = "") {
		super();
		
		if (code != "") {
			trace(code.charCodeAt(0) - 'A'.charCodeAt(0));
		}
		
		this.text = text;
		this.radius = radius;
		this._height = height;
		this._width = 2 * height / Math.sqrt(3);
		this.coords = this.hexGrid(this.radius);
		
		for (k in 0...coords.length) {
			var coord:Array<Int> = coords[k];
			var hex:Hex = new Hex(this._height, coord[0], coord[1], coord[2]);
			hex.x = coord[0] * this._width * 1.5;
			hex.y = (coord[2] - coord[1]) * this._height;
			this.hexes.push(hex);
			this.addChild(hex);
		}
		
		if (code != "") {
			if (code.charAt(1) != '-') {
				var quot:Int = code.charCodeAt(1) - 'A'.charCodeAt(0);
				var rem:Int = code.charCodeAt(2) - 'A'.charCodeAt(0);
				var startIndex:Int = quot * 26 + rem;
				WorldMap.startPos = this.hexes[startIndex];
				
				var orientation:Int = code.charCodeAt(3) - 'A'.charCodeAt(0);
				WorldMap.startPos.orientation = orientation;
			}
			
			if (code.charAt(4) != '-') {
				var quot:Int = code.charCodeAt(4) - 'A'.charCodeAt(0);
				var rem:Int = code.charCodeAt(5) - 'A'.charCodeAt(0);
				var endIndex:Int = quot * 26 + rem;
				WorldMap.endPos = this.hexes[endIndex];
			}
			
			var numAI:Int = code.charCodeAt(6) - 'A'.charCodeAt(0);
			
			var index:Int = 7;
			
			for (k in 0...numAI) {
				var aiType:Int = code.charCodeAt(index) - 'A'.charCodeAt(0);
				var quot:Int = code.charCodeAt(index + 1) - 'A'.charCodeAt(0);
				var rem:Int = code.charCodeAt(index + 2) - 'A'.charCodeAt(0);
				var aiIndex:Int = 26 * quot + rem;
				var aiOrient:Int = code.charCodeAt(index + 3) - 'A'.charCodeAt(0);
				
				this.hexes[aiIndex].aiType = aiType;
				this.hexes[aiIndex].orientation = aiOrient;
				this.aiList.push(this.hexes[aiIndex]);
				
				index += 4;
			}
			
			for (k in index...code.length) {
				var value:Int = code.charCodeAt(k) - 'A'.charCodeAt(0);
				var ii:Int = 4 * (k - index);
				
				for (j in 0...4) {
					var active:Bool = value & (1 << j) != 0;
					if (ii + j < this.hexes.length) {
						if (active) { this.hexes[ii + j].activate(); }
						else { this.hexes[ii + j].deactive(); }
					}
				}
			}
		}
		
		for (k in 0...this.hexes.length) {
			this.hexes[k].draw();
		}
	}
	
	public function keyDown(e:KeyboardEvent):Void {
		switch (e.keyCode) {
			case Keyboard.ENTER:
				trace(this.generateCode());
			case Keyboard.NUMBER_1:
				Main.menu.selectItem(0);
			case Keyboard.NUMBER_2:
				Main.menu.selectItem(1);
			case Keyboard.NUMBER_3:
				Main.menu.selectItem(2);
			case Keyboard.NUMBER_4:
				Main.menu.selectItem(3);
			case Keyboard.NUMBER_5:
				Main.menu.selectItem(4);
		}
	}
	
	private function hexGrid(radius:Int):Array<Array<Int>> {
		var results:Array<Array<Int>> = new Array<Array<Int>>();
		results.push([ 0, 0, 0 ]);
		
		for (k in 1...radius + 1) {
			results = results.concat(this.hexRing(k));
		}
		
		return results;
	}
	
	private function hexRing(radius:Int):Array<Array<Int>> {
		var results:Array<Array<Int>> = new Array<Array<Int>>();
		
		var coord:Array<Int> = [ -radius, 0, radius ];
		
		for (i in 0...6) {
			var d:Array<Int> = WorldMap.directions[i];
			
			for (j in 0...radius) {
				results.push([ coord[0], coord[1], coord[2] ]);
				
				coord[0] += d[0];
				coord[1] += d[1];
				coord[2] += d[2];
			}
		}
		
		return results;
	}
	
	public function updateCode():Void {
		this.text.text = this.generateCode();
	}
	
	private function generateCode():String {
		// The radius of the hex "cube".
		var string:String = String.fromCharCode(('A'.charCodeAt(0) + this.radius));
		
		// The player's starting position and orientation.
		if (WorldMap.startPos != null) {
			var index:Int = this.hexes.indexOf(WorldMap.startPos);
			var rem:Int = index % 26;
			var quot:Int = Math.floor(index / 26);
			string += String.fromCharCode(('A'.charCodeAt(0) + quot));
			string += String.fromCharCode(('A'.charCodeAt(0) + rem));
			
			string += String.fromCharCode(('A'.charCodeAt(0) + startPos.orientation));
		}
		else {
			string += "---";
		}
		
		// The player's ending position and orientation.
		if (WorldMap.endPos != null) {
			var index:Int = this.hexes.indexOf(WorldMap.endPos);
			var rem:Int = index % 26;
			var quot:Int = Math.floor(index / 26);
			string += String.fromCharCode(('A'.charCodeAt(0) + quot));
			string += String.fromCharCode(('A'.charCodeAt(0) + rem));
		}
		else {
			string += "--";
		}
		
		// The number of AI elements on the game map.
		string += String.fromCharCode(('A'.charCodeAt(0) + this.aiList.length));
		
		for (k in 0...this.aiList.length) {
			string += String.fromCharCode(('A'.charCodeAt(0) + this.aiList[k].aiType));
			
			var index:Int = this.hexes.indexOf(this.aiList[k]);
			var rem:Int = index % 26;
			var quot:Int = Math.floor(index / 26);
			string += String.fromCharCode(('A'.charCodeAt(0) + quot));
			string += String.fromCharCode(('A'.charCodeAt(0) + rem));
			string += String.fromCharCode(('A'.charCodeAt(0) + this.aiList[k].orientation));
		}
		
		var len:Int = this.coords.length;
		
		for (k in 0...Math.ceil((len / 4))) {
			var value:Int = 0;
			
			for (j in 0...4) {
				var index:Int = 4 * k + j;
				if (index < len) { value += this.hexes[index].active ? 1 << j : 0; }
			}
			
			string += String.fromCharCode(('A'.charCodeAt(0) + value));
		}
		
		return string;
	}
}
