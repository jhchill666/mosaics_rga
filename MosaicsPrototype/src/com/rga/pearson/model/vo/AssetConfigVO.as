package com.rga.pearson.model.vo
{
	import com.rga.pearson.model.constants.AssetConstants;
	import com.tiltdigital.data.HashMap;

	public class AssetConfigVO
	{
		private var assets : HashMap;

		private var _mergePercent : int = 20;

		private var _active : int;

		private var _maximum : int;


		/**
		 * Adds an assets to the vo to be included in assets totals
		 */
		public function updateAsset( asset:String, value:int, updateTotal:Boolean = true ):void
		{
			var oldValue:int = assets.get( asset );
			if( oldValue == value )
				return;

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
		public function updateTotals():void
		{
			var value:Number;
			active = 0;

			for each( value in assets.getKeys())
				active += value;
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
