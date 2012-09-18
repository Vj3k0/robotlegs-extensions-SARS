package robotlegs.bender.extensions.sarsIntegration.api
{
	import flash.utils.Dictionary;
	
	import starling.core.Starling;

	/**
	 * The <code>StarlingCollection</code> class represents collection of Starling
	 * instances which will be used in SARS extension.
	 * 
	 * <p>This class will adds support to have multiple instances of Starling available
	 * in Robotlegs application. All Starling instances when added to collection must
	 * have defined name which will actually be used as named injection of Starling
	 * view.</p>
	 */	
	public class StarlingCollection
	{
		
		/*============================================================================*/
		/* Private Properties
		/*============================================================================*/
		
		/** Collection of all registered Starling views. **/
		private var _starlingCollection:Dictionary = new Dictionary(true);
		
		/**
		 * Total number of Starling instances in dictionary (since Dictionary doesn't
		 * keep track of number of items in it, and looping through it is expensive).
		 */		
		private var _length:uint = 0;
		
		/*============================================================================*/
		/* Public Methods
		/*============================================================================*/
		
		/**
		 * Add Starling instance to collection.
		 * 
		 * <p>Instance will be added to dictionary with key as name provided. When 
		 * using this collection with SARS, Starling views will be mapped to injector
		 * and differentiated by named injection. Name will be exact same as one
		 * provieded when adding instance to this collection.</p>
		 * 
		 * @param starling Starling instace to add to collection.
		 * 
		 * @param name Name by which Starling instance will be remembered.
		 * 
		 * @return Return number of instances in collection.
		 */		
		public function addItem(starling:Starling, name:String):uint
		{
			if (_starlingCollection[name] == undefined) {
				_starlingCollection[name] = starling;
				_length++;
			}
			
			return _length;
		}
		
		/**
		 * Remove Starling item from collection by its name.
		 * 
		 * @param name Name by which Starling instance was added to collection.
		 * 
		 * @return Returns Starling instance which was removed if it is found, or if 
		 * not found by that name, returns <code>null</code>. 
		 */		
		public function removeItem(name:String):Starling
		{
			var result:Starling = getItem(name);
			
//			If Starling instance is found in collection, remove entry
			if (result) {
				delete _starlingCollection[name];
				_length--;
			}
			
			return result;
		}
		
		/**
		 * Get Starling instance by name.
		 * 
		 * @param name Name provided when Starling instance was added to collection.
		 * 
		 * @return Returns Starling instance it it was found, or <code>null</code> 
		 * otherwise.
		 */		
		public function getItem(name:String):Starling
		{
			if (_starlingCollection[name] == undefined)
				return null;
			
			return Starling(_starlingCollection[name]);
		}
		
		/**
		 * Get Starling instances in collection.
		 * 
		 * @return Returns Starling instances collection. 
		 */		
		public function get items():Dictionary
		{
			return _starlingCollection;
		}

		/**
		 * Number of items in collection.
		 */		
		public function get length():uint
		{
			return _length;
		}
		
		
		
	}
}