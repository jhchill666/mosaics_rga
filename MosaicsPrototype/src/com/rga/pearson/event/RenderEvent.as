package com.rga.pearson.event
{
	import flash.events.Event;
	
	public class RenderEvent extends Event
	{
		public static const RENDER : String = "RenderEvent.RENDER";
		
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