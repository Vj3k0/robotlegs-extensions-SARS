package robotlegs.bender.extensions.sarsIntegration.impl
{
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.sarsIntegration.api.IDisplayObject;
	import robotlegs.bender.extensions.sarsIntegration.api.IStarlingViewMap;
	import robotlegs.bender.extensions.sarsIntegration.api.StarlingCollection;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	/**
	 * The <code>StarlingViewMap</code> class performs managing Starling stage and 
	 * views automatic mediation. When view is added or removed from stage, it will
	 * automatically create or destroy its mediator.
	 */	
	public class StarlingViewMap implements IStarlingViewMap
	{
		/*============================================================================*/
		/* Public Properties                                                         */
		/*============================================================================*/
		
		[Inject]
		/** Collection of Starling views which will receive display objects. **/
		public var starlingCollection:StarlingCollection;
		
		[Inject]
		/** Map for mediating views. **/
		public var mediatorMap:IMediatorMap;
		
		/*============================================================================*/
		/* Constructor
		/*============================================================================*/
		
		[PostConstruct]
		/**
		 * Initialize listeners on Starling views.
		 */		
		public function init():void
		{	
			var s:Starling;
			
			for each (s in starlingCollection.items) 
			{
				// listen for display object events
				s.stage.addEventListener( Event.ADDED, onStarlingAdded );
				s.stage.addEventListener( Event.REMOVED, onStarlingRemoved );
				
				// adds stage as view to allow a Starling Stage Mediator.
				s.addEventListener( Event.ROOT_CREATED, onRootCreated );
			}
		}
		
		/*============================================================================*/
		/* Public Methods
		/*============================================================================*/
		
		/** @inheritDoc **/		
		public function addStarlingView(view : DisplayObject) : void
		{
			if (view is IDisplayObject)
				IDisplayObject(view).init();
			mediatorMap.mediate(view);
		}
		
		/** @inheritDoc **/		
		public function removeStarlingView(view : DisplayObject) : void
		{
			if (view is IDisplayObject)
				IDisplayObject(view).destroy();
			mediatorMap.unmediate(view);
		}
		
		/*============================================================================*/
		/* Private Methods
		/*============================================================================*/
		
		/**
		 * Handle Starling view added on display list.
		 * 
		 * @param event Starling view added on stage.
		 */		
		private function onStarlingAdded( event:Event ):void
		{
			addStarlingView( event.target as DisplayObject );
		}
		
		/**
		 * Handle Starling view removed from display list.
		 * 
		 * @param event Starling view removed from stage.
		 */		
		private function onStarlingRemoved( event:Event ):void
		{
			removeStarlingView( event.target as DisplayObject );
		}
		
		/**
		 * Add Starling stage to mediation.
		 * 
		 * @param event Starling had been initialized.
		 * 
		 */		
		private function onRootCreated( event:Event ):void
		{
			Starling(event.target).removeEventListener( Event.ROOT_CREATED, onRootCreated );
			
			addStarlingView( Starling(event.target).stage );
		}
	}
}