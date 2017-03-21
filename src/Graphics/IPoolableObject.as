package Graphics
{
	
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public interface IPoolableObject 
	{
		function returnToPool():void;
		function set pool(newPool:Pool):void;
		function get pool():Pool;
		function destroy():void;
	}
	
}