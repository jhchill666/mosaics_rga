package com.rga.pearson.model
{
	import com.rga.pearson.event.ColourModelEvent;
	import com.rga.pearson.model.colour.ColourRange;
	import com.rga.pearson.model.constants.AssetConstants;
	import com.rga.pearson.model.constants.ColourConstants;
	import com.rga.pearson.model.constants.GridConstants;
	import com.rga.pearson.model.vo.AssetConfigVO;
	import com.rga.pearson.model.vo.ColourVO;
	import com.rga.pearson.model.vo.Segment;
	import com.rga.pearson.utils.NumberUtils;

	import de.polygonal.ds.Array2;

	import mx.collections.ArrayCollection;

	import org.robotlegs.mvcs.Actor;

	public class ColourModel extends Actor
	{
		private var assetsVo:AssetConfigVO;

		private var mergePoints:Vector.<int>;

		public var swatches : Vector.<ColourVO>;

		public var randomisation : Number;


		/**
		 * Returns the colours for each segment
		 *
		 * ( Extrapolate out to include biased distribution colouring )
		 */
		public function colourDistribution( array:Array2, assetsVo:AssetConfigVO ):ArrayCollection
		{
			var spectrum:Vector.<ColourRange>, collection:ArrayCollection;

			this.assetsVo = assetsVo;

			spectrum = getSpectrum();
			spectrum[0].extrapolate();

			swatches = spectrum[0].getSwatches();
//			swatches = transposeColours( swatches );

			return getColouredDistribution( array, swatches );
		}


		/**
		 * Generates a ColourRange for each assets type.  The ColourRange is responsibile
		 * for blending colours between it and the next ColourRange, taking the merge
		 * percentage into account.
		 */
		private function getSpectrum():Vector.<ColourRange>
		{
			var i:int, range:ColourRange, percentOfTotal:Number, numAssets:int, colours:Vector.<uint>, types:Vector.<String>, spectrum:Vector.<ColourRange> = new Vector.<ColourRange>();

			colours = ColourConstants.getColours();
			types = AssetConstants.getTypes();

			for( i = 0 ; i < types.length ; ++ i )
			{
				numAssets = assetsVo.getAsset( types[i] );

//				trace("NumAssets :: "+numAssets );

				if( numAssets == 0 )
					continue;

				range = new ColourRange( colours[i], i, randomisation );
//				range.percent = NumberUtils.percent( numAssets, assetsVo.active );
				range.quantity = numAssets;
				range.active = assetsVo.active;

				trace( "Total :: "+assetsVo.active+", Percent :: "+range.quantity );

				if( spectrum.length > 0 )
				{
					range.previous = spectrum[ spectrum.length - 1 ];
					spectrum[ spectrum.length - 1 ].next = range;
				}

				spectrum.push( range );
			}

			trace("NumberColourRanges :: "+spectrum.length );

			return checkHaveSpectrum( spectrum );
		}


		/**
		 * Check we have a valid spectrum, otherwise create a blank one
		 */
		private function checkHaveSpectrum( spectrum:Vector.<ColourRange> ):Vector.<ColourRange>
		{
			var range:ColourRange;

			if( spectrum.length == 0 )
			{
				range = new ColourRange( 0x000001, 0, randomisation );
				range.quantity = assetsVo.active;

				spectrum.push( range );
			}
			return spectrum;
		}


		/**
		 * Assigns the extrapolated colour swatches to each of the segments
		 */
		private function getColouredDistribution( array:Array2, colours:Vector.<ColourVO> ):ArrayCollection
		{
			var i:int, segCount:int, segment:Segment, arr:Array = array.toArray();

			segCount = 0;

			for( i = 0 ; i < arr.length ; i ++ )
			{
				segment = arr[i] as Segment;

				if( segment.rawColour == ColourConstants.INACTIVE_CELL )
					continue;

				if( segCount < colours.length )
					segment.rawColour = colours[segCount].raw;

				if( segment.rawColour == 0xFFFFFF )
					segment.rawColour = colours[ colours.length - 1 ].raw;

				segCount ++;
			}
			return new ArrayCollection( arr );
		}
	}
}
