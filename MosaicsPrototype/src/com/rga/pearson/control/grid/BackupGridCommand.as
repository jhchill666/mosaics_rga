package com.rga.pearson.control.grid
{
	import com.rga.pearson.model.constants.GridConstants;
	import com.rga.pearson.view.MainViewMediator;
	import com.rga.pearson.view.grid.GridView;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import org.robotlegs.mvcs.Command;
	
	public class BackupGridCommand extends Command
	{
		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			super.execute();
			
			var gridView:GridView, bitmapData:BitmapData, bitmap:Bitmap, mainViewMediator:MainViewMediator;
			
			gridView = MosaicsPrototype( contextView ).main.grid;
			
			bitmapData = new BitmapData( GridConstants.NUM_COLS * GridConstants.CELL_SIZE, GridConstants.NUM_ROWS * GridConstants.CELL_SIZE, true, 0x00FF00 );
			bitmapData.draw( gridView, null, null, null, new Rectangle( 0, 0, GridConstants.NUM_COLS * GridConstants.CELL_SIZE, GridConstants.NUM_ROWS * GridConstants.CELL_SIZE + 30 ));
			
			bitmap = new Bitmap( bitmapData );
			bitmap.alpha = 0.6;
			
			MosaicsPrototype( contextView ).main.thumnails.addThumb( bitmap );
		}
	}
}