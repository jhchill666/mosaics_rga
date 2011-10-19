package com.rga.pearson.model.colour
{
	import com.rga.pearson.model.vo.ColourVO;
	import com.rga.pearson.utils.ColourUtils;
	import com.rga.pearson.utils.NumberUtils;

	public class ColourRange
	{
		public var colour : uint;

		public var id : int;

		public var quantity : Number;

		public var active : Number;

		public var previous : ColourRange;

		public var next : ColourRange;

		public var mergeRatio : int = 4;

		public var mergePercent : Number = 0.2;

		public var randomisation : Number;

		public var mergeFrom : int;

		public var mergeTo : int;

		public var randomAmount : int = 15;

		public var swatches : Vector.<ColourVO> = new Vector.<ColourVO>();


		/**
		 * Constructor.
		 */
		public function ColourRange( colour:uint, id:int, randomisation:Number = 0 )
		{
			this.colour = colour;
			this.id = id;
			this.randomisation = randomisation;
		}


		/**
		 * Returns all colours in the sequence
		 */
		public function getSwatches():Vector.<ColourVO>
		{
			if( next )
				return swatches.concat( next.getSwatches() );

			else
				return swatches;
		}


		/**
		 * Extrapolate this ColourRange into a colour profile,
		 * merged with the next ColourRange in sequence
		 */
		public function extrapolate():void
		{
			if( next == null )
				extrapolateThis();

			else
				extrapolateSequence();
		}


		/**
		 * Extrapolate this ColourRange only as there isn't one in sequence following this one
		 */
		private function extrapolateThis():void
		{
			var i:int, colourVo:ColourVO;

			for( i = 0 ; i < quantity ; ++ i )
			{
				colourVo = extrapolateSegment( i );
				swatches.push( colourVo );
			}
			trace( "ColourRange"+id+" :: "+swatches.length );
		}


		/**
		 * Extrapolate this ColourRange and blend with the next range in sequence
		 */
		private function extrapolateSequence():void
		{
			var i:int, colourVo:ColourVO;

			for( i = 0 ; i < quantity ; ++ i )
			{
				colourVo = extrapolateSegment( i );
				swatches.push( colourVo );
			}

			trace( "ColourRange"+id+" :: "+swatches.length );

			next.extrapolate();
		}


		/**
		 * Extrapolate this ColourRange and blend with the next range in sequence
		 */
		private function extrapolateSegment( index:int ):ColourVO
		{
			var newColour:uint, percentOfTotal:Number, randomise:Boolean, useAssetColour:Boolean;

			mergeFrom = ( quantity - ( quantity * mergePercent ));
			mergeTo = ( quantity * mergePercent );

			if( previous && index < mergeTo )
			{
				useAssetColour = NumberUtils.weight(( mergeTo / 100 ) * index );
				newColour = ( useAssetColour ) ? colour : previous.colour;
			}
			else if( next && index > mergeFrom )
			{
				useAssetColour = NumberUtils.weight((( quantity - mergeFrom ) / 100 ) * ( index - mergeFrom ));
				newColour = ( useAssetColour ) ? next.colour : colour;

			}
			else
				newColour = colour;

			percentOfTotal = NumberUtils.percent( quantity, active );
			randomise = NumberUtils.weight( percentOfTotal );

//			trace( "percentOfTotal :: "+percentOfTotal+", Randomise :: "+randomise );

			if( randomise )
				newColour = ColourUtils.varyColour( newColour, randomSign( randomAmount ));

			return new ColourVO( newColour, newColour );
		}


		private function randomSign( amount:int ):Number
		{
			var r:Number = Math.floor( Math.random() * 3 );

			switch( r )
			{
				case 0:
					return ( amount * -1 );
					break;
				case 1:
					return 0;
					break;
				case 2:
					return ( amount );
					break;
			}
			return 0;
		}
	}
}
