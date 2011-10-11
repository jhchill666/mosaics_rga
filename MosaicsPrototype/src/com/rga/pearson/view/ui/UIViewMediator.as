package com.rga.pearson.view.ui
{
	import com.rga.pearson.event.RenderEvent;
	import com.rga.pearson.model.constants.CategoryModel;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.events.DropDownEvent;
	
	public class UIViewMediator extends Mediator
	{
		[Inject]
		public var view:UIView;

		[Inject]
		public var categoryModel:CategoryModel;
		
		/**
		 * @inheritDoc
		 */
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener( view.categories, DropDownEvent.CLOSE, categoryChosenhandler );
			eventMap.mapListener( view.renderButton, MouseEvent.CLICK, renderHanler );
			
			view.setCategories( categoryModel.getCategories() );
		}
		
		/**
		 * Category drop down list handler
		 */
		private function categoryChosenhandler ( event:DropDownEvent ) : void
		{
			var index:int, subCategories:ArrayCollection;
			
			index = view.categories.selectedIndex;
			subCategories = categoryModel.getSubCategories( index );
			
			view.setSubCategories( subCategories );
		}

		/**
		 * Context render handler - re-renders the grid cell segments
		 */
		private function renderHanler ( event:MouseEvent ) : void
		{
			dispatch( new RenderEvent( RenderEvent.RENDER ));
		}
	}
}