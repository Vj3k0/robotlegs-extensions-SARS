package robotlegs.bender.bundles
{
	import robotlegs.bender.bundles.shared.configs.ContextViewListenerConfig;
	import robotlegs.bender.extensions.commandCenter.CommandCenterExtension;
	import robotlegs.bender.extensions.sarsContextView.SARSContextViewExtension;
	import robotlegs.bender.extensions.eventCommandMap.EventCommandMapExtension;
	import robotlegs.bender.extensions.eventDispatcher.EventDispatcherExtension;
	import robotlegs.bender.extensions.localEventMap.LocalEventMapExtension;
	import robotlegs.bender.extensions.logging.LoggingExtension;
	import robotlegs.bender.extensions.logging.TraceLoggingExtension;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapExtension;
	import robotlegs.bender.extensions.modularity.ModularityExtension;
	import robotlegs.bender.extensions.sarsIntegration.SARSIntegrationExtension;
	import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
	import robotlegs.bender.extensions.sarsStageSync.SARSStageSyncExtension;
	import robotlegs.bender.extensions.viewManager.ManualStageObserverExtension;
	import robotlegs.bender.extensions.viewManager.StageObserverExtension;
	import robotlegs.bender.extensions.viewManager.ViewManagerExtension;
	import robotlegs.bender.framework.api.IBundle;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.LogLevel;
	
	public class SARSBundle implements IBundle
	{
		
		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			context.extend(
				LoggingExtension,
				TraceLoggingExtension,
				SARSIntegrationExtension, 
				SARSContextViewExtension,
				EventDispatcherExtension,
				ModularityExtension,
				CommandCenterExtension,
				EventCommandMapExtension,
				LocalEventMapExtension,
				ViewManagerExtension,
				StageObserverExtension,
				ManualStageObserverExtension,
				MediatorMapExtension,
				SignalCommandMapExtension,
				SARSStageSyncExtension);
			
			context.configure(ContextViewListenerConfig);
		}
	}
}