package com.rga.pearson.control
{
	import com.rga.pearson.model.GridModel;
	import com.rga.pearson.model.constants.GridConstants;
	import com.rga.pearson.model.vo.AssetConfigVO;

	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Command;

	public class StartupCommand extends Command
	{
		private static const STARTING_PERCENTAGE : int = 35;

		[Inject]
		public var gridModel : GridModel;


		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			super.execute();

			buildAssets();
			dispatch( new ContextEvent( ContextEvent.STARTUP_COMPLETE ));
		}


		/**
		 * Build the Ass
		 */
		private function buildAssets():void
		{
			var assetsVo:AssetConfigVO;

			assetsVo = new AssetConfigVO();
			assetsVo.maximum = ( GridConstants.NUM_COLS * 2 ) * GridConstants.NUM_ROWS;
			assetsVo.active = (( assetsVo.maximum / 100 ) * STARTING_PERCENTAGE );
			assetsVo.distributeAssets();

			gridModel.setAssets( assetsVo );
		}
	}
}
