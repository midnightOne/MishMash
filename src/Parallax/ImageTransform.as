package Parallax 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class ImageTransform 
	{
		public function ImageTransform() 
		{
			
		}
		
		
		/**
		 * 
		 * @param	image	изображение, которое мы "плющим"
		 * @param	canvas	спрайт, на котором мы будем рисовать
		 * @param	x1		координата X левой верхней вершины
		 * @param	y1		координата Y левой верхней вершины
		 * @param	x2		координата X правой верхней вершины
		 * @param	y2		координата Y правой верхней вершины
		 * @param	x3		координата X правой нижней вершины
		 * @param	y3		координата Y правой нижней вершины
		 * @param	x4		координата X левой нижней вершины
		 * @param	y4		координата Y левой нижней вершины
		 * @param	clear	флаг очистки спрайта от прежних художеств
		 */
		public static function transform(image:BitmapData, canvas:Sprite, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, x4:Number, y4:Number, clear:Boolean = false):void {
			var diagonalRatio:Number = length(x1, y1, x3, y3) / length(x2, y2, x4, y4);
 
			// A, B и C параметры уравнения прямой первой диагонали
			var a1:Number = y1 - y3;
			var b1:Number = x3 - x1;
			var c1:Number = x1 * y3 - x3 * y1;
 
			// A, B и C параметры уравнения прямой второй диагонали
			var a2:Number = y2 - y4;
			var b2:Number = x4 - x2;
			var c2:Number = x2 * y4 - x4 * y2;
 
			// точка пересечения диагоналей
			var intersectionX:Number = -(c1 * b2 - c2 * b1) / (a1 * b2 - a2 * b1);
			var intersectionY:Number = -(a1 * c2 - a2 * c1) / (a1 * b2 - a2 * b1);
 
			// коэффициенты, с помощью которых мы достигаем перспективно корректного результата
			var t1:Number = 1 / length(x3, y3, intersectionX, intersectionY) * diagonalRatio;
			var t2:Number = 1 / length(x4, y4, intersectionX, intersectionY);
			var t3:Number = 1 / length(x1, y1, intersectionX, intersectionY) * diagonalRatio;
			var t4:Number = 1 / length(x2, y2, intersectionX, intersectionY);
 
			var vertices:Vector.<Number> = new Vector.<Number>()
			vertices.push(x1, y1, x2, y2, x3, y3, x4, y4);
			var indices:Vector.<int> = new Vector.<int>()
			indices.push(0, 1, 2, 2, 3, 0);
			var uvtdata:Vector.<Number> = new Vector.<Number>()
			uvtdata.push(0, 0, t1, 1, 0, t2, 1, 1, t3, 0, 1, t4);
 
			if (clear) canvas.graphics.clear();
			canvas.graphics.beginBitmapFill(image, null, false, true);
			canvas.graphics.drawTriangles(vertices, indices, uvtdata);
			canvas.graphics.endFill();
		}
 
		private static function length(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
 
			return Math.sqrt(dx * dx + dy * dy);
		}
	}

}