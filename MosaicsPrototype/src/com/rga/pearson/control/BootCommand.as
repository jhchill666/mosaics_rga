package com.rga.pearson.control
{
	import com.rga.pearson.view.MainView;

	import org.robotlegs.mvcs.Command;

	public class BootCommand extends Command
	{
		/**
		 * @inheritDoc
		 */
		override public function execute():void
		{
			super.execute();

			MosaicsPrototype( contextView ).setCurrentState( "start" );
		}
	}
}
