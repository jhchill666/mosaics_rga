package com.rga.pearson.view.grid
{
	import com.rga.pearson.event.DisciplineEvent;
	import com.rga.pearson.event.RenderEvent;
	import com.rga.pearson.model.constants.CategoryModel;
	import com.rga.pearson.model.constants.ColourModel;
	import com.rga.pearson.model.constants.GridModel;

	import de.polygonal.ds.Array2;

	import mx.collections.ArrayCollection;

	import org.robotlegs.mvcs.Mediator;

	public class GridViewMediator extends Mediator
	{

		[Inject]
		public var view:GridView;

		[Inject]
		public var gridModel : GridModel;

		[Inject]
		public var categoryModel : CategoryModel;

		[Inject]
		public var colourModel : ColourModel;


		/**
		 * @inheritDoc
		 */
		override public function onRegister():void
		{
			super.onRegister();

			eventMap.mapListener( eventDispatcher, RenderEvent.RENDER, renderHandler );
			eventMap.mapListener( eventDispatcher, DisciplineEvent.NEW_DISCIPLINE, newDisciplineHandler );
		}


		/**
		 * Re-renders the grid with the new distribution
		 */
		private function renderHandler( event:RenderEvent ):void
		{
			var currentSubCategory:int, numSubCategories:int, distribution:Array2, colourDistribution:ArrayCollection;

			currentSubCategory = categoryModel.currentSubCategory;
			numSubCategories = categoryModel.getSubCategories( currentSubCategory ).length;

			distribution = gridModel.getDistribution( currentSubCategory, numSubCategories );
			colourDistribution = colourModel.colourDistribution( distribution );

			view.renderSegments( colourDistribution );
		}


		/**
		 * New discipline drop down chosen
		 */
		private function newDisciplineHandler( event:DisciplineEvent ):void
		{
			view.gridMask.setShape( event.discipline );
		}
	}
}
