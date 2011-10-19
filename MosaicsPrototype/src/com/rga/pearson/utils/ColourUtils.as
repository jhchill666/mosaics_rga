package com.rga.pearson.utils
{

	public class ColourUtils
	{
		public static function randomInterpolate(fromColor:uint, toColor:uint, progress:Number, random:Number = 0 ):uint
		{
			var rand:Number, weight:Number = 0.3;

			var q:Number = 1-progress;
			var fromA:uint = (fromColor >> 24) & 0xFF;
			var fromR:uint = (fromColor >> 16) & 0xFF;
			var fromG:uint = (fromColor >>  8) & 0xFF;
			var fromB:uint =  fromColor        & 0xFF;
			var toA:uint = (toColor >> 24) & 0xFF;
			var toR:uint = (toColor >> 16) & 0xFF;
			var toG:uint = (toColor >>  8) & 0xFF;
			var toB:uint =  toColor        & 0xFF;

			rand = ( NumberUtils.weight( weight ) )
				? NumberUtils.randomRange( -random, random )
				: 0;

			var resultA:uint = (fromA*q + toA*progress) + rand;
			rand = ( NumberUtils.weight( weight ) )
				? NumberUtils.randomRange( -random, random )
				: 0;
			var resultR:uint = (fromR*q + toR*progress) + rand;
			rand = ( NumberUtils.weight( weight ) )
				? NumberUtils.randomRange( -random, random )
				: 0;
			var resultG:uint = (fromG*q + toG*progress) + rand;
			rand = ( NumberUtils.weight( weight ) )
				? NumberUtils.randomRange( -random, random )
				: 0;
			var resultB:uint = (fromB*q + toB*progress) + rand;
			var resultColor:uint = resultA << 24 | resultR << 16 | resultG << 8 | resultB;
			return resultColor;
		}


		public static function varyColour(colour:uint, amount:Number = 0 ):uint
		{
			var alpha:uint = ( colour >> 24 ) & 0xFF;
			var red:uint = ( colour >> 16 ) & 0xFF;
			var green:uint = ( colour >>  8 ) & 0xFF;
			var blue:uint =   colour         & 0xFF;

			var resultA:uint = ( alpha + amount );
			var resultR:uint = ( red + amount );
			var resultG:uint = ( green + amount );
			var resultB:uint = ( blue + amount );
			var resultColor:uint = resultA << 24 | resultR << 16 | resultG << 8 | resultB;

			return resultColor;
		}


		public static function interpolate(fromColor:uint, toColor:uint, progress:Number ):uint
		{
			var q:Number = 1-progress;
			var fromA:uint = (fromColor >> 24) & 0xFF;
			var fromR:uint = (fromColor >> 16) & 0xFF;
			var fromG:uint = (fromColor >>  8) & 0xFF;
			var fromB:uint =  fromColor        & 0xFF;
			var toA:uint = (toColor >> 24) & 0xFF;
			var toR:uint = (toColor >> 16) & 0xFF;
			var toG:uint = (toColor >>  8) & 0xFF;
			var toB:uint =  toColor        & 0xFF;
			var resultA:uint = fromA*q + toA*progress;
			var resultR:uint = fromR*q + toR*progress;
			var resultG:uint = fromG*q + toG*progress;
			var resultB:uint = fromB*q + toB*progress;
			var resultColor:uint = resultA << 24 | resultR << 16 | resultG << 8 | resultB;
			return resultColor;
		}
	}
}
