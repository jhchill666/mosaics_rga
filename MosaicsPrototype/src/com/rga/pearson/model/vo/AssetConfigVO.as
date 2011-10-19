package com.rga.pearson.model.vo
{
	import com.rga.pearson.model.constants.AssetConstants;
	import com.rga.pearson.utils.NumberUtils;
	import com.tiltdigital.data.HashMap;

	public class AssetConfigVO
	{
		private var assets : HashMap;

		private var _mergePercent : int = 20;

		private var _active : int;

		private var _maximum : int;

		public var total : int;


		/**
		 * Adds an assets to the vo to be included in assets totals
		 */
		public function updateAsset( asset:String, value:int, updateTotal:Boolean = true ):void
		{
			var oldValue:int = assets.get( asset );
			if( oldValue == value )
				return;

//			trace("Assets :: "+asset+", Value :: "+value );

			assets.put( asset, value );

			if( updateTotal )
				updateTotals();
		}


		/**
		 * Distributes the total active assets betweenm the total asset types
		 */
		public function distributeAssets():void
		{
			var type:String, assetsPerType:int, offset:int, total:int, index:int, assetId:String, numAssets:int;

			assets = new HashMap();
			assetsPerType = int( active / AssetConstants.size() );

			for each( type in AssetConstants.getTypes())
				assets.put( type, assetsPerType );

			total = ( assetsPerType * assets.size() )
			if( total < active )
			{
				offset = ( active - total );

				index = Math.random() * assets.size();
				assetId = AssetConstants.getTypes()[ index ];

				numAssets = assets.get( assetId ) + offset;
				assets.put( assetId, numAssets );
			}
			updateTotals();
		}


		/**
		 * Update total assets to reflect any changes
		 */
		private function updateTotals():void
		{
			var value:int;
			total = 0;

			for each( value in assets.getKeys())
				total += value;
		}


		/**
		 * Update total assets to reflect percentage of total assets
		 */
		public function updatePercentages():void
		{
			var type:String, newValue:int, value:int, percent:Number, percentOfActive:Number;

			for each( type in AssetConstants.getTypes())
			{
				value = assets.get( type );

				percent = NumberUtils.percent( value, total );
				newValue  = ( _active * percent );

				assets.put( type, newValue );

				trace( "Active :: "+_active+", Total :: "+total+", New :: "+newValue+", PercentOfTotal :: "+percent+", Actual :: "+value );
			}

//			trace( "\n::::::::::::: \n");
		}


		/**
		 * Retrieves an assets details
		 */
		public function getAsset( asset:String ):Number
		{
			if( !hasAsset( asset ))
				return 0;

			return assets.get( asset );
		}


		/**
		 * Determins if an asset has any segments
		 */
		public function hasAsset( asset:String ):Boolean
		{
			var value:int;
			value = assets.get( asset );

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
		 * Returns the total number of active segments
		 */
		public function get active():int
		{
			return _active;
		}


		public function set active( val:int ):void
		{
			_active = val;
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
	}
}
