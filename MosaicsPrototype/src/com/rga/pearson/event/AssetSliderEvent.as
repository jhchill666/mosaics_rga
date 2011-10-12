package com.rga.pearson.event
{
	import flash.events.Event;

	public class AssetSliderEvent extends Event
	{
		public static const UPDATE_ASSET : String = "update_asset";

		public static const UPDATE_ASSETS : String = "update_assets";

		public var slider : String;

		public var value : Number;


		/**
		 *Constructor.
		 */
		public function AssetSliderEvent(type:String, slider:String = "", value:Number = 0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.slider = slider;
			this.value = value;

			super(type, bubbles, cancelable);
		}


		override public function clone():Event
		{
			return new AssetSliderEvent( type, slider, value, bubbles, cancelable );
		}
	}
}
