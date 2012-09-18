//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.sarsContextView
{
	import away3d.containers.View3D;
	
	import flash.display.DisplayObjectContainer;
	
	import org.hamcrest.object.instanceOf;
	import org.swiftsuspenders.Injector;
	
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.impl.UID;

	/**
	 * <p>This Extension will map default context view to injector.</p>
	 */
	public class SARSContextViewExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		
		/** Extension UID. **/
		private const _uid:String = UID.create(SARSContextViewExtension);
		
		/** Injector used in context. **/
		private var _injector:Injector;

		/** Logger used to log messaged when using this extension. **/
		private var _logger:ILogger;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/** @inheritDoc **/
		public function extend(context:IContext):void
		{
			_injector = context.injector;
			_logger = context.getLogger(this);
			context.addConfigHandler(instanceOf(DisplayObjectContainer), handleContextView);
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
		 * Map default context view.
		 * 
		 * <p>Since <code>View3D</code> is based on <code>DisplayObjectContainer</code> it
		 * will also try to initialize as context view, but since it is handled differently
		 * as part of SARS, it is set to be ignored.</p>
		 * 
		 * @param view View being set as context view.
		 */		
		private function handleContextView(view:DisplayObjectContainer):void
		{
			// ignore Away3D view
			if (view is View3D)
				return;
			
			if (_injector.satisfiesDirectly(DisplayObjectContainer))
			{
				_logger.warn('A contextView has already been mapped, ignoring {0}', [view]);
			}
			else
			{
				_logger.debug("Mapping {0} as contextView", [view]);
				_injector.map(DisplayObjectContainer).toValue(view);
			}
		}
	}
}
