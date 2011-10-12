package com.rga.pearson.view.ui
{
	import com.rga.pearson.event.AssetSliderEvent;
	import com.rga.pearson.event.DisciplineEvent;
	import com.rga.pearson.event.RenderEvent;
	import com.rga.pearson.model.CategoryModel;
	import com.rga.pearson.model.GridModel;

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

		[Inject]
		public var gridModel:GridModel;


		/**
		 * @inheritDoc
		 */
		override public function onRegister():void
		{
			super.onRegister();

			eventMap.mapListener( view.categories, DropDownEvent.CLOSE, categoryChosenhandler );
			eventMap.mapListener( view.subCategories, DropDownEvent.CLOSE, subCategoryChosenhandler );
			eventMap.mapListener( view.renderButton, MouseEvent.CLICK, renderHanler );
			eventMap.mapListener( view, AssetSliderEvent.UPDATE_ASSETS, updateAssetsHandler );

			view.setTotals( gridModel.getAssets() );
			view.setCategories( categoryModel.getCategories() );
		}


		/**
		 * Category drop down list handler
		 */
		private function categoryChosenhandler( event:DropDownEvent ):void
		{
			var index:int, subCategories:ArrayCollection;

			index = view.categories.selectedIndex;
			subCategories = categoryModel.getSubCategories( index );

			view.setSubCategories( subCategories );

			dispatch( new DisciplineEvent( DisciplineEvent.NEW_DISCIPLINE, index ));
		}


		/**
		 * Sub-category drop down list handler
		 */
		private function subCategoryChosenhandler( event:DropDownEvent ):void
		{

		}


		/**
		 * An asset slider has been updated so update the model
		 */
		private function updateAssetsHandler( event:AssetSliderEvent ):void
		{
			gridModel.setAssets( view.assetsVo );

			dispatch( new RenderEvent( RenderEvent.SEGMENT_RENDER ));
		}


		/**
		 * Context render handler - re-renders the grid cell segments
		 */
		private function renderHanler( event:MouseEvent ):void
		{
			dispatch( new RenderEvent( RenderEvent.FULL_RENDER ));
		}
	}
}
