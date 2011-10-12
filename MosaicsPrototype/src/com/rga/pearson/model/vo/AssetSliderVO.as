package com.rga.pearson.model.vo
{
	import de.polygonal.ds.HashMap;
	import de.polygonal.ds.Iterator;

	public class AssetSliderVO
	{
		private var assets : HashMap;

		private var _mergePercent : int = 20;

		private var _total : int;

		private var _maximum : int;


		/**
		 * Adds an assets to the vo to be included in assets totals
		 */
		public function updateAsset( asset:String, value:Number ):void
		{
			if( assets == null )
				assets = new HashMap();

			assets.insert( asset, value );
			updateTotals();

			trace( "AssetUpdate :: "+asset+", oldValue :: "+assets[ assets ] + ", newValue :: "+value+", Total :: "+total );
		}


		/**
		 * Retrieves an assets details
		 */
		public function getAsset( asset:String ):Number
		{
			if( !hasAsset( asset ))
				return 0;

			return assets.find( asset );
		}


		/**
		 * Determins if an asset has any segments
		 */
		public function hasAsset( asset:String ):Boolean
		{
			var value:int;
			value = assets.find( asset );

			return ( !isNaN( value ) && value > 0 );
		}


		/**
		 * Returns the merge percentage.  This is the percentage of the
		 * number of assets that should merge to the next colour in the spectrum
		 */
		public function get mergePercent():int
		{
			return _mergePercent;
		}


		/**
		 * Returns the totals of assets
		 */
		public function get total():int
		{
			return _total;
		}


		public function set total( val:int ):void
		{
			_total = val;
		}


		/**
		 * Returns the maximum number of assets allowed
		 */
		public function get maximum():int
		{
			return _maximum;
		}


		public function set maximum( val:int ):void
		{
			_maximum = val;
		}


		private function updateTotals():void
		{
			var iterator:Iterator;

			_total = 0;
			iterator = assets.getIterator();

			while( iterator.hasNext())
				_total += iterator.next();
		}
	}
}
