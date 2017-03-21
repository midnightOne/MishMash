package Graphics
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Kirill Prymachov aka Midnight
	 */
	public class GraphicVault 
	{
		private var dict:Dictionary;
		private static var vaultInstance:GraphicVault;
		
		
		public function GraphicVault() 
		{
			dict = new Dictionary(false); //no weak keys for now
			
		}
		
		public static function getInstance():GraphicVault 
		{
			if (vaultInstance) 
			{
				return vaultInstance;
				
			} else 
			{
				vaultInstance = new GraphicVault();
				return vaultInstance;
			}
			
		}
		
		public function setupAPoolFor(objectClass:Class, id:String, rasterize:Boolean = false, size:int = 10):void 
		{
			if (dict[id] == undefined) 
			{
				if (!rasterize) 
				{
					dict[id] = new Pool(objectClass, size);
				} else
				{
					dict[id] = new CachedMCPool(objectClass, size);
					
				}
				
			} else 
			{
				/*CONFIG::debug*/ {
					trace("WARNING: you tried to set up multiple pools for object: (" + id + ")");
				}
			}
			
		}
		
		public function getObject(id:String):DisplayObject 
		{
			/*CONFIG::debug*/ {
				trace2("getObject " + id );
			}
			if (dict[id]) 
			{
				return (dict[id] as Pool).getItem();
			}else 
			{
				/*CONFIG::debug*/ {
					trace("WARNING: no such object in Vault: " + id);
				}
				return null;
			}
		}
		
		private function  trace2(str:String):void 
		{
			if (Settings.traceEnabled) 
			{
				trace("GV: " + str);
			}
			
		}
		
		
	}

}