package robotlegs.bender.extensions.sarsIntegration.api
{
	/**
	 * The <code>IDisplayObject</code> interface defines methods which will be 
	 * invoked when object is added to/removed from display list.
	 */	
	public interface IDisplayObject
	{
		/**
		 * Object is added on display list so it is safe to begin initialization.
		 */		
		function init():void;
		
		/**
		 * Object has been removed from display list so perform disposing.
		 */		
		function destroy():void;
	}
}