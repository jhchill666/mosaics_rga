package com.rga.pearson.view.grid
{
	import com.rga.pearson.event.DisciplineEvent;
	import com.rga.pearson.event.RenderEvent;
	import com.rga.pearson.model.CategoryModel;
	import com.rga.pearson.model.ColourModel;
	import com.rga.pearson.model.GridModel;
	
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

			eventMap.mapListener( eventDispatcher, RenderEvent.FULL_RENDER, renderFullHandler );
			eventMap.mapListener( eventDispatcher, RenderEvent.SEGMENT_RENDER, renderSegmentHandler );
			eventMap.mapListener( eventDispatcher, DisciplineEvent.NEW_DISCIPLINE, newDisciplineHandler );
			
			renderFullHandler();
		}


		/**
		 * Re-renders the grid with the new distribution
		 */
		private function renderFullHandler( event:RenderEvent = null ):void
		{
			var currentSubCategory:int, numSubCategories:int, distribution:Array2, colourDistribution:ArrayCollection;

			currentSubCategory = categoryModel.currentSubCategory;
			numSubCategories = categoryModel.getSubCategories( currentSubCategory ).length;

			distribution = gridModel.getDistribution( currentSubCategory, numSubCategories );
			colourDistribution = colourModel.colourDistribution( distribution, gridModel.getAssets() );

			dispatch( new RenderEvent( RenderEvent.SAVE_GRID ));
			view.renderSegments( colourDistribution );
		}


		/**
		 * Renders a new segment to the grid
		 */
		private function renderSegmentHandler( event:RenderEvent ):void
		{
			var currentSubCategory:int, numSubCategories:int, distribution:Array2, colourDistribution:ArrayCollection;

			distribution = gridModel.updateDistribution( currentSubCategory, numSubCategories );
			colourDistribution = colourModel.colourDistribution( distribution, gridModel.getAssets() );

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
