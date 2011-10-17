package com.rga.pearson.event
{
	import flash.events.Event;

	public class RenderEvent extends Event
	{
		public static const FULL_RENDER : String = "RenderEvent.FULL_RENDER";

		public static const SEGMENT_RENDER : String = "RenderEvent.SEGMENT_RENDER";
		
		public static const SAVE_GRID : String = "RenderEvent.SAVE_GRID";


		/**
		 *Constructor.
		 */
		public function RenderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}


		override public function clone():Event
		{
			return new RenderEvent( type, bubbles, cancelable );
		}
	}
}
