
package com.rga.pearson.view.grid
{
	import com.rga.pearson.event.ColourModelEvent;
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

			dispatch( new RenderEvent( RenderEvent.FULL_RENDER ));
		}


		/**
		 * Re-renders the grid with the new distribution
		 */
		private function renderFullHandler( event:RenderEvent = null ):void
		{
			var currentSubCategory:int, numSubCategories:int, distribution:Array2, colourDistribution:ArrayCollection;

			currentSubCategory = categoryModel.currentSubCategory;
			numSubCategories = categoryModel.getSubCategories( currentSubCategory ).length;

			distribution = gridModel.getNewDistribution( currentSubCategory, numSubCategories );
			colourDistribution = colourModel.colourDistribution( distribution, gridModel.getAssets() );

			view.renderSegments( colourDistribution );
			view.renderTitle( categoryModel.getCurrentTitle() );

			dispatch( new ColourModelEvent( ColourModelEvent.SWATCHES_UPDATED ));
		}


		/**
		 * Renders a new segment to the grid
		 */
		private function renderSegmentHandler( event:RenderEvent ):void
		{
			var currentSubCategory:int, numSubCategories:int, distribution:Array2, colourDistribution:ArrayCollection;

			distribution = gridModel.getDistribution();
			colourDistribution = colourModel.colourDistribution( distribution, gridModel.getAssets() );

			view.renderSegments( colourDistribution );

			dispatch( new ColourModelEvent( ColourModelEvent.SWATCHES_UPDATED ));
		}


		/**
		 * New discipline drop down chosen
		 */
		private function newDisciplineHandler( event:DisciplineEvent ):void
		{
			view.gridMask.setShape( event.discipline );
			view.renderTitle( categoryModel.getCategories()[ event.discipline ] );
		}
	}
}
