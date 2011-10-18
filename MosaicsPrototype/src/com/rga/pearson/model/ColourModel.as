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
				percentOfTotal = NumberUtils.percent( numAssets, assetsVo.active );

				range = new ColourRange( colours[i], i, randomisation );
				range.quantity = Math.floor( assetsVo.active * percentOfTotal );

				if( i > 0 )
					spectrum[ i - 1 ].next = range;

				spectrum.push( range );
			}

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
				range = new ColourRange( ColourConstants.INACTIVE_CELL, 0, randomisation );
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

				segment.rawColour = colours[segCount].raw;
				segment.blendedColour = colours[segCount].blended;
				segCount ++;
			}
			return new ArrayCollection( arr );
		}
	}
}
