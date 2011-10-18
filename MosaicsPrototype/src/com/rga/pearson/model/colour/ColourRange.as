package com.rga.pearson.model.colour
{
	import com.rga.pearson.model.vo.ColourVO;
	import com.rga.pearson.utils.ColourUtils;

	public class ColourRange
	{
		public var colour : uint;

		public var id : int;

		public var quantity : int;

		public var percentOfTotal : int;

		public var next : ColourRange;

		public var mergeRatio : int = 4;

		public var randomisation : Number;

		public var mergePoint : int;

		public var startPoint : int;

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
			for( var i:int = startPoint ; i < quantity ; ++ i )
			{
				swatches.push( new ColourVO( colour, colour ) );
			}
		}


		/**
		 * Extrapolate this ColourRange and blend with the next range in sequence
		 */
		private function extrapolateSequence():void
		{
			var i:int, mergeRange:int, colourStep:uint, step:int, progress:Number, blended:uint;

			mergePoint = ( quantity - mergeRatio );
			next.startPoint = mergeRatio;

			mergeRange = ( quantity - mergePoint ) + next.startPoint;
			colourStep = ( next.colour - colour ) / mergeRange;

			for( i = startPoint ; i < ( quantity + next.startPoint ) ; ++ i )
			{
				blended = colour;
				if( i >= mergePoint )
				{
					progress = ( i - mergePoint ) * ( mergeRange / 255 );
					colour = ColourUtils.randomInterpolate( colour, next.colour, progress, 20 );

					step ++;
				}
				swatches.push( new ColourVO( colour, blended ) );
			}

			next.extrapolate();
		}
	}
}
