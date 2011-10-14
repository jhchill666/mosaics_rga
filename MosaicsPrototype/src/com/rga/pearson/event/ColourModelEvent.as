package com.rga.pearson.event
{
	import flash.events.Event;

	public class ColourModelEvent extends Event
	{
		public static const SWATCHES_UPDATED : String = "ColourModelEvent.SWATCHES_UPDATED";


		/**
		 *Constructor.
		 */
		public function ColourModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}


		override public function clone():Event
		{
			return new ColourModelEvent( type, bubbles, cancelable );
		}
	}
}
