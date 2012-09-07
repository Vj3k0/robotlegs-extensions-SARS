package robotlegs.bender.extensions.sarsIntegration.impl
{
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.sarsIntegration.api.IStarlingViewMap;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class StarlingViewMap implements IStarlingViewMap
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		
		[Inject]
		public var currentStarling:Starling;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
		
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		
		
		
		/*============================================================================*/
		/* Constructor
		/*============================================================================*/
		
		public function StarlingViewMap()
		{
			
		}
		
		[PostConstruct]
		public function init():void
		{	
			// listen for display object events
			currentStarling.stage.addEventListener( Event.ADDED, onStarlingAdded );
			currentStarling.stage.addEventListener( Event.REMOVED, onStarlingRemoved );
			
			// adds stage as view to allow a Starling Stage Mediator.
			currentStarling.addEventListener( Event.ROOT_CREATED, onRootCreated );
		}
		
		/*============================================================================*/
		/* Public Methods
		/*============================================================================*/
		
		public function addStarlingView(view : DisplayObject) : void
		{
			mediatorMap.mediate(view);
		}
		
		public function removeStarlingView(view : DisplayObject) : void
		{
			mediatorMap.unmediate(view);
		}
		
		/*============================================================================*/
		/* Private Methods
		/*============================================================================*/
		
		private function onStarlingAdded( event:Event ):void
		{
			addStarlingView( event.target as DisplayObject );
		}
		
		private function onStarlingRemoved( event:Event ):void
		{
			removeStarlingView( event.target as DisplayObject );
		}
		
		private function onRootCreated( event:Event ):void
		{
			currentStarling.removeEventListener( Event.ROOT_CREATED, onRootCreated );
			
			addStarlingView( currentStarling.stage );
		}
	}
}