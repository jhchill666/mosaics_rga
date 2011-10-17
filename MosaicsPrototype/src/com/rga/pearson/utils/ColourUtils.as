package com.rga.pearson.utils
{

	public class ColourUtils
	{
		public static function interpolate(fromColor:uint, toColor:uint, progress:Number, random:Number = 0 ):uint
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
	}
}
