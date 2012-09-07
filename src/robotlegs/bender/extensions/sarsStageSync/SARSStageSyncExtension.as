//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.sarsStageSync
{
	import away3d.containers.View3D;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import org.hamcrest.object.instanceOf;
	
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.impl.UID;
	
	import starling.core.Starling;
	import starling.events.Event;

	/**
	 * <p>This Extension waits for a DisplayObjectContainer to be added as a configuration,
	 * and initializes and destroys the context based on that container's stage presence.</p>
	 *
	 * <p>It should be installed before context initialization.</p>
	 */
	public class SARSStageSyncExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(SARSStageSyncExtension);

		private var _context:IContext;

		private var _contextView:flash.display.DisplayObjectContainer;
		
		private var _starling:Starling;

		private var _logger:ILogger;
		
		private var _contextReady:Boolean;
		
		private var _starlingReady:Boolean;
		
		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_context = context;
			_logger = context.getLogger(this);
			_context.addConfigHandler(
				instanceOf(flash.display.DisplayObjectContainer),
				handleContextView);
			_context.addConfigHandler(
				instanceOf(Starling),
				handleStarlingContextView);
		}

		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleContextView(view:flash.display.DisplayObjectContainer):void
		{
			// ignore Away3D view
			if (view is View3D)
				return;
			
			if (_contextView)
			{
				_logger.warn('A contextView has already been set, ignoring {0}', [view]);
				return;
			}
			_contextView = view;
			if (_contextView.stage)
			{
				_contextReady = true;
				initializeContext();
			}
			else
			{
				_logger.debug("Context view is not yet on stage. Waiting...");
				_contextView.addEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}
		
		private function onAddedToStage(event:flash.events.Event):void
		{
			_logger.debug("Context view added on stage.");
			_contextView.removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
			_contextView.addEventListener(flash.events.Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_contextReady = true;
			
			initializeContext();
		}

		private function onRemovedFromStage(event:flash.events.Event):void
		{
			_logger.debug("Context view has left the stage. Destroying context...");
			_contextView.removeEventListener(flash.events.Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_context.lifecycle.destroy();
		}
		
		//---------------------------------------------------------------
		// Handling Starling
		//---------------------------------------------------------------
		
		private function handleStarlingContextView(currentStarling:Starling):void
		{
			if (_starling)
			{
				_logger.warn('A Starling contextView has already been set, ignoring {0}', [currentStarling]);
				return;
			}
			_starling = currentStarling;
			if (currentStarling.stage.numChildren > 0)
			{
				_starlingReady = true;
				initializeContext();
			}
			else
			{
				_logger.debug("Starling context view is not yet on stage. Waiting...");
				currentStarling.addEventListener(starling.events.Event.CONTEXT3D_CREATE, onContextCreated);
			}
		}
		
		private function onContextCreated(event:starling.events.Event):void
		{
			_logger.debug("Starling context view added on stage.");
			_starlingReady = true;
			
			initializeContext();
		}

		//---------------------------------------------------------------
		// Initialization
		//---------------------------------------------------------------
		
		private function initializeContext():void
		{
			// if both of the views are not on stage, postpone initialization
			if (!_contextReady || !_starlingReady)
				return;
			
			_logger.debug("Default and Starling context views are now on stage. Initializing context...");
			_context.lifecycle.initialize();
		}

	}
}
