package com.rga.pearson.model.colour
{
	import com.rga.pearson.utils.ColourUtils;
	import com.rga.pearson.utils.NumberUtils;

	public class ColourRange
	{
		public var colour : uint;

		public var id : int;

		public var quantity : int;

		public var next : ColourRange;

		public var mergeRatio : int = 4;

		public var mergePoint : int;

		public var startPoint : int;

		public var swatches : Vector.<uint> = new Vector.<uint>();


		/**
		 * Constructor.
		 */
		public function ColourRange( colour:uint, id:int )
		{
			this.colour = colour;
			this.id = id;
		}


		/**
		 * Returns all colours in the sequence
		 */
		public function getSwatches():Vector.<uint>
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
			for( var i:int = startPoint ; i < quantity ; ++ i )
			{
				swatches.push( colour );
			}
		}


		/**
		 * Extrapolate this ColourRange and blend with the next range in sequence
		 */
		private function extrapolateSequence():void
		{
			var i:int, mergeRange:int, colourStep:uint, step:int, progress:Number;

			mergePoint = ( quantity - mergeRatio );
			next.startPoint = mergeRatio;

			mergeRange = ( quantity - mergePoint ) + next.startPoint;
			colourStep = ( next.colour - colour ) / mergeRange;

			trace( "StartColour :: "+colour+" EndColour ::" +next.colour );

			for( i = startPoint ; i < ( quantity + next.startPoint ) ; ++ i )
			{
				if( i >= mergePoint )
				{
					progress = ( i - mergePoint ) * ( mergeRange / 255 );
//					progress += NumberUtils.randomRange( -2, 2 );
					colour = ColourUtils.interpolate( colour, next.colour, progress );

					step ++;
				}
				swatches.push( colour );
			}

//			trace( id+" :: ColourRange.swatches( "+swatches.length+" )" );

			next.extrapolate();
		}
	}
}
