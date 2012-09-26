package robotlegs.bender.extensions.sarsContextView.api
{
	/**
	 * The <code>ISARSContextView</code> interface defines contract between 
	 * core SARS application and another external application.
	 * 
	 * <p>This interface is created so that SARS context view can be rendered
	 * on demand. This is usefull when creating multiple components which are
	 * also based on SARS. You should also pass stage3DProxy instance and register
	 * it in its context so that they can draw on the same canvas.</p>
	 * 
	 * <p>For example lets take that you are loading gallery which is using SARS 
	 * extension and defines 3 layers:
	 * <ul>
	 * <li>Starling layer showing gallery background</li>
	 * <li>Away3D layer with images as planes with bitmap textures</li>
	 * <li>Starling layer having artsy fartsy particle effects for browsing through collection</li>
	 * </ul></p>
	 * 
	 * <p>Now you need to use this gallery in your fancy pants application based using
	 * SARS extension as well. So you need to render your gallery at on point because its
	 * layers need to keep the same structure and order and not mix with your application.</p>
	 * 
	 * <p>Lets define your sample app layers:
	 * <ul>
	 * <li>Starling layer presenting app background</li>
	 * <li>Away3D layer with some funny looking ambient 3D stuff</li>
	 * <li>Layer for your SARS gallery</li>
	 * <li>Starling layer containing 2D navigation for your app</li>
	 * </ul></p>
	 * 
	 * <p>So your app would define following rendering order:
	 * <listing version="3.0">
	 * stage3DProxy.clear();
	 * 
	 * myAppBackground.nextFrame();
	 * someAmbient3DStuffView3D.render();
	 * gallery.render();
	 * appNavigation.nextFrame();
	 * 
	 * stage3DProxy.present();
	 * </listing></p>
	 */	
	public interface ISARSContextView
	{
		/**
		 * Render all Starling and Away3D instances.
		 * 
		 * <p>On Starling instances, call <code>nextFrame</code> function and 
		 * on View3D instance call <code>render</code> function.</p>
		 */		
		function render():void;
	}
}