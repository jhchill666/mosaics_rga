package com.rga.pearson.model
{
	import com.rga.pearson.model.constants.AssetConstants;
	import com.rga.pearson.model.constants.ColourConstants;
	import com.rga.pearson.model.vo.AssetSliderVO;
	import com.rga.pearson.utils.NumberUtils;
	
	import de.polygonal.ds.Array2;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;
	
	import spark.components.supportClasses.Range;

	public class ColourModel extends Actor
	{
		private var assetsVo:AssetSliderVO;
		
		private var mergePoints:Vector.<int>;


		/**
		 * Returns the colours for each segment
		 *
		 * ( Extrapolate out to include biased distribution colouring )
		 */
		public function colourDistribution( array:Array2, assetsVo:AssetSliderVO ):ArrayCollection
		{
			this.assetsVo = assetsVo;
			
			var spectrum:Vector.<Range>, unmergedColours:Vector.<uint>, mergedColours:Vector.<uint>;

			spectrum = getSpectrum();
			unmergedColours = rawSpectrum( spectrum );
			mergedColours = mergedSpectrum( spectrum, unmergedColours );

			return getColouredDistribution( array, mergedColours );
		}
		
		
		private function rawSpectrum ( spectrum:Vector.<Range> ) : Vector.<uint>
		{
			var i:int, j:int, colours:Vector.<uint>;
			
			colours = new Vector.<uint>();
			mergePoints = new Vector.<uint>();
			
			for( i = 0; i < spectrum.length; ++i )
			{
				if( i != 0 && i < spectrum.length - 1 )
					mergePoints.push( colours.length );
				
				for( j = 0; j < spectrum[ i ].size; ++j )
					colours.push( spectrum[ i ].colour );
				
			}
			
			/*
			
			if( i < spectrum.length - 1 )
			{
			next = spectrum[ i + 1 ] as Range;
			
			percent = ( current.size > next.size )
			? NumberUtils.percent( next.size, current.size )
			: NumberUtils.percent( current.size, next.size );
			
			currentStartMerge = current.size * percent;
			currentStartMerge = ( current.size - currentStartMerge );
			
			percent = ( current.size < next.size )
			? NumberUtils.percent( next.size, current.size )
			: NumberUtils.percent( current.size, next.size );
			
			nextStopMerge = next.size * percent;
			
			}
			
			*/
			
			
		}

		
		private function mergedSpectrum ( spectrum:Vector.<Range>, points:Vector.<Range ) : Vector.<uint>
		{
			var i:int, j:int, colours:Vector.<uint>, current:Range, next:Range, end:int, nextSize:int, percent:Number, currentStartMerge:Number, nextStopMerge:Number;
			
			
			for( i = 0; i < points; ++i )
			{
				current = spectrum[i];
				next = spectrum[i+1];
				
				percent = ( current.size > next.size )
					? NumberUtils.percent( next.size, current.size )
					: NumberUtils.percent( current.size, next.size );
				
				currentStartMerge = current.size * 
				nextStopMerge = 
			}
		}


		private function getSpectrum():Vector.<uint>
		{
			var assets:int, changeIndex:int, tmp:Vector.<Range> = new Vector.<Range>();

			if( assetsVo.hasAsset( AssetConstants.BOOKS ))
			{
				assets = assetsVo.getAsset( AssetConstants.BOOKS );
				tmp.push( new Range( 0, assets, ColourConstants.GREEN ));
				changeIndex = assets;
			}
			if( assetsVo.hasAsset( AssetConstants.DOCUMENTS ))
			{
				assets = assetsVo.getAsset( AssetConstants.DOCUMENTS )
				tmp.push( new Range( changeIndex, changeIndex+assets, ColourConstants.BLUE ));
				changeIndex += assets;
			}
			if( assetsVo.hasAsset( AssetConstants.IMAGES ))
			{
				assets = assetsVo.getAsset( AssetConstants.IMAGES )
				tmp.push( new Range( changeIndex, changeIndex+assets, ColourConstants.YELLOW ));
				changeIndex += assets;
			}
			if( assetsVo.hasAsset( AssetConstants.INTERACTIVE ))
			{
				assets = assetsVo.getAsset( AssetConstants.INTERACTIVE )
				tmp.push( new Range( changeIndex, changeIndex+assets, ColourConstants.ORANGE ));
				changeIndex += assets;
			}
			if( assetsVo.hasAsset( AssetConstants.VIDEOS ))
			{
				assets = assetsVo.getAsset( AssetConstants.VIDEOS )
				tmp.push( new Range( changeIndex, changeIndex+assets, ColourConstants.PINK ));
				changeIndex += assets;
			}
			return tmp;
		}


		private function getColouredDistribution( array:Array2, colours:Vector.<uint> ):ArrayCollection
		{
			var split:int, i:int, index:int, arr:Array, colour:uint, colourIndex:int;

			arr = array.toArray();
			split = assetsVo.total / 5;

			for( i = 0 ; i < arr.length ; i ++ )
			{
				if( arr[ i ] == ColourConstants.INACTIVE_CELL )
					continue;

				index ++;
				if( index > split )
				{
					index = 0;
					colourIndex ++;
				}

				switch( colourIndex )
				{
					case 0:
						colour = ColourConstants.GREEN;
						break;
					case 1:
						colour = ColourConstants.YELLOW;
						break;
					case 2:
						colour = ColourConstants.PINK;
						break;
					case 3:
						colour = ColourConstants.BLUE;
						break;
					case 4:
						colour = ColourConstants.ORANGE;
						break;
				}

				if( arr[ i ] == 0xFFFFFF )
					arr[ i ] = colour;
			}
			return new ArrayCollection( arr );
		}
	}
}

class Range
{
	public var start:int;

	public var end:int;

	public var colour:uint;

	public var startMerge:int;
	public var stopMerge:int;


	/**
	 * Constructor.
	 */
	public function Range( start:int, end:int, colour:uint )
	{
		this.start = start;
		this.end = end;
		this.colour = colour;
	}
	
	public function get size() : Number
	{
		return end - start;
	}
}
