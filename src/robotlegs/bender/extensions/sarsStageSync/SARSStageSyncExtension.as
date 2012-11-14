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

import robotlegs.bender.extensions.contextView.ContextView;

import robotlegs.bender.extensions.sarsIntegration.api.StarlingCollection;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.impl.UID;
	
	import starling.core.Starling;
	import starling.events.Event;

	/**
	 * <p>This Extension waits for a DisplayObjectContainer to be added as a configuration,
	 * and all Starling view instances defined to be initialized. When all of them are ready,
	 * context is initialized. On the other hand losing reference to stage will destroy 
	 * context.</p>
	 *
	 * <p>It should be installed before context initialization.</p>
	 */
	public class SARSStageSyncExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		/** Extension UID. **/
		private const _uid:String = UID.create(SARSStageSyncExtension);

		/** Context being initialized. **/
		private var _context:IContext;

		/** Reference to regular view in Flash display list. **/
		private var _contextView:flash.display.DisplayObjectContainer;
		
		/** Logger used to log messaged when using this extension. **/
		private var _logger:ILogger;
		
		/** Boolean indicating if context view is on stage. **/
		private var _contextReady:Boolean;
		
		/** Collection of Starling view instances. **/
		private var _starlingCollection:StarlingCollection;
		
		/** Number of Starling instances which are not initialized. **/
		private var _numStarlingsInQueue:int = 0;
		
		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/** @inheritDoc **/
		public function extend(context:IContext):void
		{
			_context = context;
			_logger = context.getLogger(this);
			_context.addConfigHandler(
				instanceOf(ContextView),
				handleContextView);
			_context.addConfigHandler(
				instanceOf(StarlingCollection),
				handleStarlingCollection);
		}

		/**
		 * Returns the string representation of the specified object.
		 */		
		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		/**
		 * Initialize context view. 
		 * 
		 * @param view View being set as context view.
		 */		
		private function handleContextView(contextView:ContextView):void
		{
			if (_contextView)
			{
				_logger.warn('A contextView has already been set, ignoring {0}', [contextView.view]);
				return;
			}
			_contextView = contextView.view;
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
		
		/**
		 * Context view is ready so try to initialize context.
		 * 
		 * @param event View has been added to stage.
		 */		
		private function onAddedToStage(event:flash.events.Event):void
		{
			_logger.debug("Context view added on stage.");
			_contextView.removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
			_contextView.addEventListener(flash.events.Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_contextReady = true;
			
			initializeContext();
		}

		/**
		 * Context view doesn't have reference to stage, so destroy the context.
		 * 
		 * @param event View has been removed from stage.
		 */		
		private function onRemovedFromStage(event:flash.events.Event):void
		{
			_logger.debug("Context view has left the stage. Destroying context...");
			_contextView.removeEventListener(flash.events.Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_context.lifecycle.destroy();
		}
		
		//---------------------------------------------------------------
		// Handling Starling
		//---------------------------------------------------------------
		
		/**
		 * Initialize all Starling view instances in collection.
		 * 
		 * @param collection Collection of Starling view instances used in context.
		 */		
		private function handleStarlingCollection(collection:StarlingCollection):void
		{
			if (_starlingCollection)
			{
				_logger.warn('A Starling collection has already been set, ignoring {0}', [collection]);
			}
			_starlingCollection = collection;
			_numStarlingsInQueue = collection.length;
			
			var s:Starling;
			for each (s in _starlingCollection.items) 
			{
				handleStarlingContextView(s);
			}
			
		}
		
		/**
		 * Initialize Starling context view.
		 * 
		 * @param currentStarling Starling view that needs to be initialized.
		 * 
		 */		
		private function handleStarlingContextView(currentStarling:Starling):void
		{
			if (currentStarling.stage.numChildren > 0)
			{
				initializeContext();
			}
			else
			{
				_logger.debug("Starling context view is not yet on stage. Waiting...");
				currentStarling.addEventListener(starling.events.Event.CONTEXT3D_CREATE, onContextCreated);
			}
		}
		
		/**
		 * Context view is ready so try to initialize context.
		 * 
		 * @param event Context created for Starling view.
		 * 
		 */		
		private function onContextCreated(event:starling.events.Event):void
		{
			_logger.debug("Starling context view added on stage.");
			_numStarlingsInQueue--;
			
			initializeContext();
		}

		//---------------------------------------------------------------
		// Initialization
		//---------------------------------------------------------------
		
		/**
		 * Initialize context if default context view is ready and if
		 * all Starling view instances have their context prepared.
		 */		
		private function initializeContext():void
		{
			// if all views are not on stage, postpone initialization
			if (!_contextReady || (_numStarlingsInQueue > 0))
				return;
			
			_logger.debug("Default and Starling context views are now on stage. Initializing context...");
			_context.lifecycle.initialize();
		}

	}
}
