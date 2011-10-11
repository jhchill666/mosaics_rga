package com.rga.pearson
{
	import com.rga.pearson.control.StartupCommand;
	import com.rga.pearson.model.constants.CategoryModel;
	import com.rga.pearson.model.constants.GridModel;
	import com.rga.pearson.view.MainView;
	import com.rga.pearson.view.MainViewMediator;
	import com.rga.pearson.view.grid.GridView;
	import com.rga.pearson.view.grid.GridViewMediator;
	import com.rga.pearson.view.ui.UIView;
	import com.rga.pearson.view.ui.UIViewMediator;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	
	public class PearsonContext extends Context
	{
		/**
		 * @inheritDoc
		 */
		override public function startup():void
		{
			// model
			injector.mapSingleton( CategoryModel );
			injector.mapSingleton( GridModel );
			
			// view
			mediatorMap.mapView( UIView, UIViewMediator );
			mediatorMap.mapView( GridView, GridViewMediator );
			
			// commands
			commandMap.mapEvent( ContextEvent.STARTUP, StartupCommand );
			
			// startup
			dispatchEvent( new ContextEvent( ContextEvent.STARTUP ));
			
			mediatorMap.mapView( MainView, MainViewMediator );
			mediatorMap.createMediator( contextView );
		}
	}
}