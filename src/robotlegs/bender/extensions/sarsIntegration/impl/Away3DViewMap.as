// ------------------------------------------------------------------------------
// Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
// NOTICE: You are permitted to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
// ------------------------------------------------------------------------------

package robotlegs.bender.extensions.sarsIntegration.impl
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.events.Scene3DEvent;
	
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.sarsIntegration.api.IAway3DViewMap;
	
	/**
	 * The <code>Away3DViewMap</code> class performs managing Away3D scene and 
	 * views automatic mediation. When view is added or removed from scene, it will
	 * automatically create or destroy its mediator.
	 */	
	public class Away3DViewMap implements IAway3DViewMap	
	{
		/*============================================================================*/
		/* Public Properties                                                         */
		/*============================================================================*/
		
		[Inject]
		/** Instance of View3D which contains scene receiving display objects. **/
		public var view3D:View3D;
		
		[Inject]
		/** Map for mediating views. **/
		public var mediatorMap : IMediatorMap;
		
		/*============================================================================*/
		/* Constructor
		/*============================================================================*/

		[PostConstruct]
		/**
		 * Initialize listeners on Away3D scene.
		 */		
		public function init() : void
		{
			// listen for ObjectContainer3D events
			view3D.scene.addEventListener( Scene3DEvent.ADDED_TO_SCENE, onSceneAdded );
			view3D.scene.addEventListener( Scene3DEvent.REMOVED_FROM_SCENE, onSceneRemoved );

			// add scene as view to allow a Away3D Scene Mediator
			// Note : we don't support swapping scenes now - one scene will do.
				
			addAway3DView( view3D.scene );
		}

		/*============================================================================*/
		/* Public Methods
		/*============================================================================*/
		
		/** @inheritDoc **/
		public function addAway3DView(view : *) : void
		{
			if( validateView(view))
			{
				mediatorMap.mediate(view);
			}
			else
				throw new Error("Not sure what to do with this view type..");
		}

		/** @inheritDoc **/
		public function removeAway3DView(view : *) : void
		{
			mediatorMap.unmediate(view);
		}

		/*============================================================================*/
		/* Private Methods
		/*============================================================================*/
		
		/**
		 * Validate if view added on scene is of type either <code>Scene3D</code> or 
		 * <code>ObjectContainer3D</code>, and this is required since <code>Scene3D</code> 
		 * doesn't extend <code>ObjectContainer3D</code>.
		 * 
		 * @param view View that needs to be validated.
		 * 
		 * @return Returns <code>true</code> if view is of valid type, or <code>false</code>
		 * otherwise.
		 */		
		private function validateView(view:*):Boolean
		{
			if( view is Scene3D || view is ObjectContainer3D ){
				return true;
			}else
				return false;
		}
		
		/**
		 * Handle view added to scene.
		 * 
		 * @param event View added to scene.
		 */	
		private function onSceneAdded(event : Scene3DEvent) : void
		{
			addAway3DView(event.objectContainer3D);
		}
		
		/**
		 * Handle view removed from scene.
		 * 
		 * @param event View removed from scene.
		 */	
		private function onSceneRemoved(event : Scene3DEvent) : void
		{
			removeAway3DView(event.objectContainer3D);
		}
	}
}
