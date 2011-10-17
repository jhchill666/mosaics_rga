package com.rga.pearson.model.vo
{
	import com.rga.pearson.model.constants.ColourConstants;

	public class Segment
	{
		public var col : int;
		
		public var row : int;
		
		public var rawColour : uint = ColourConstants.INACTIVE_CELL;
		
		public var blendedColour: uint;
		
		public var id : String;
		
		
		public function Segment( col:Number = -1, row:Number = -1 )
		{
			this.col = Math.ceil(col);
			this.row = Math.ceil(row);
			this.id = String( col+":"+row );
		}
	}
}