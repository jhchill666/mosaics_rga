package com.rga.pearson.event
{
	import flash.events.Event;

	public class DisciplineEvent extends Event
	{
		public static const NEW_DISCIPLINE : String = "DisciplineEvent.NEW_DISCIPLINE";

		public var discipline : int;


		/**
		 *Constructor.
		 */
		public function DisciplineEvent(type:String, discipline:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.discipline = discipline;

			super(type, bubbles, cancelable);
		}


		override public function clone():Event
		{
			return new DisciplineEvent( type, discipline, bubbles, cancelable );
		}
	}
}
