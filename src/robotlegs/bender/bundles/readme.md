# SARS Bundle

This bundle installs a number of extensions and configurations for developers who are comfortable with the typical Robotlegs V1 MVCS setup providing ability to create application with combination of Away3D and Starling.

## Included Extensions

* LoggingExtension - allows you to inject loggers into clients
* TraceLoggingExtension - sets up a simple trace log target
* SARSIntegrationExtension - allows you to inject Starling (with named injection) and Away3D views
* SARSContextViewExtension - consumes a display object container as the contextView (reimplementation of ContextViewExtension to disallow View3D being mapped as context view)
* EventDispatcherExtension - makes a shared event dispatcher available
* ModularityExtension - allows the context to expose and/or inherit dependencies
* CommandMapExtension - the foundation for other command map extensions
* EventCommandMapExtension - an event driven command map
* LocalEventMapExtension - automatically cleans up listeners for its clients
* ViewManagerExtension - allows you to add multiple containers as "view roots"
* StageObserverExtension - watches the stage for view components using magic
* ManualStageObserverExtension - non-magical view wiring
* MediatorMapExtension - configures and creates mediators for view components
* SignalCommandMapExtension - an signal driven command map
* SARSStageSyncExtension - automatically initialize context when all Starling views and context view gain stage reference.

Note: for more information on these extensions please see the extensions package.

## Included Configs

* ContextViewListenerConfig - adds the contextView to the viewManager

## Usage

Example of using bundle:

	context.extend(SARSBundle).configure(view3D, starlingCollection, Config, this);

To initialize all extensions in bundle, you would have to provide:

* Reference to View3D instance
* StarlingCollection with Starling instances
* Class which contains application configuration
* Reference to context view