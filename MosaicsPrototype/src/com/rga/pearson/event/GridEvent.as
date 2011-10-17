package com.rga.pearson.event
{
	import com.rga.pearson.view.grid.GridView;
	
	import flash.events.Event;

	public class GridEvent extends Event
	{
		public static const SAVE : String = "GridEvent.SAVE";

		public var view:GridView;
		
		/**
		 *Constructor.
		 */
		public function GridEvent(type:String, view:GridView, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.view = view;
			
			super(type, bubbles, cancelable);
		}


		override public function clone():Event
		{
			return new GridEvent( type, view, bubbles, cancelable );
		}
	}
}
