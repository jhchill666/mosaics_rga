package com.rga.pearson.view.grid
{
	import com.rga.pearson.event.RenderEvent;
	import com.rga.pearson.model.constants.CategoryModel;
	import com.rga.pearson.model.constants.GridModel;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class GridViewMediator extends Mediator
	{
		[Inject]
		public var view:GridView;
		
		[Inject]
		public var gridModel : GridModel;
		
		[Inject]
		public var categoryModel : CategoryModel;
		
		/**
		 * @inheritDoc
		 */
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener( eventDispatcher, RenderEvent.RENDER, renderHandler );
		}
		
		/**
		 * Re-renders the grid with the new distribution
		 */
		private function renderHandler ( event:RenderEvent ) : void
		{
			var currentSubCategory:int, numSubCategories:int;
			
			currentSubCategory = categoryModel.currentSubCategory;
			numSubCategories = categoryModel.getSubCategories( currentSubCategory ).length;
			
			view.renderSegments(
				gridModel.getDistribution( currentSubCategory, numSubCategories ) );
		}
	}
}