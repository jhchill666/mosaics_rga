package com.rga.pearson.utils
{

	public class StringUtils
	{
		public static var LEFT:Number = 1 << 1;

		public static var RIGHT:Number = 1 << 2;


		/**
		 * converts hexadecimal string to int.
		 *
		 * @param hex	hexadecimal String (w/ or w/o #)
		 *
		 * @return		corresponding int value
		 */
		public static function hexStringToInt( hex:String ):int
		{
			hex = replace( hex , "#" , "" );
			return parseInt( "0x" + hex.substr( 0 , 6 ) );
		}


		public static function intToHex( number:int , flashHex:Boolean = true ):String
		{
			var hex:String = number.toString( 16 );
			while( hex.length < 6 )
			{
				hex += "0"
			}
			return flashHex ? "0x" + hex : hex;
		}


		/**
		 * dumps Object to String.
		 *
		 * @param obj	Object to be dumped
		 */
		public static function objectToString( obj:Object ):String
		{
			var s:String = "";
			var looped:Boolean = false;
			s += "{";

			for( var p:* in obj )
			{
				if( !looped )
					looped = true;
				if( obj[ p ] is Array )
					s += p + ": [" + obj[ p ] + "], ";
				else if( obj[ p ] is Object )
					s += StringUtils.objectToString( obj[ p ] ) + ", ";
				else if( obj[ p ] is Function )
					s += p + ": (function), ";
				else
					s += p + ": " + obj[ p ] + ", ";
			}

			if( looped )
				return s.slice( 0 , -2 ) + "}";
			return s + "}";
		}


		/**
		 * Resize a given string to a greater length and fill it up with a custom
		 * character.
		 *
		 * @usage   StringUtils.padString("4", 3, "0", StringUtils.LEFT); // "004"
		 *
		 * @param   val           The value that will be modified
		 * @param   strLength     The length of the new string
		 * @param   padChar       The string will be padded with this character
		 * @param  padDirection  Where will the characters be added?
		 * @return
		 */
		public static function padString( val:String , strLength:Number , padChar:String , padDirection:Number = NaN ):String
		{
			if( isNaN( padDirection ))
			{
				padDirection = StringUtils.LEFT;
			}
			// If the input value is already as long as the result should be, return
			// the unchanged input value.
			// Also do nothing if padChar is not a single character.
			if( val.length >= strLength || padChar.length != 1 )
			{
				return val;
			}
			var fill:String = "";
			for( var i:Number = 0 ; i < strLength - val.length ; i++ )
			{
				fill += padChar;
			}
			var out:String = padDirection == StringUtils.LEFT ? ( fill + val ) : ( val + fill );
			return out;
		}


		/**
		 * capitalizes first character of String.
		 *
		 * @param haystack	String to search in
		 * @param needle	String that we are looking for
		 * @param replace	If needle is found replace is with this String
		 */
		public static function replace( haystack:String , needle:String , replace:String ):String
		{
			return haystack.split( needle ).join( replace );
		}


		/**
		 * capitalizes first character of String.
		 *
		 * @param str	String to edit
		 */
		public static function toTitleCase( str:String ):String
		{
			return str.substr( 0 , 1 ).toUpperCase() + str.substr( 1 ).toLowerCase();
		}


		/**
		 * capitalizes first character of every word in String.
		 *
		 * @param str	String to edit
		 */
		public static function ucWords( str:String ):String
		{
			var newStr:String = "";
			var chunks:Array = str.split( " " );

			for( var i:int = 0 ; i < chunks.length ; i++ )
			{
				newStr += StringUtils.toTitleCase( chunks[ i ] );
				if( i < chunks.length - 1 )
					newStr += " ";
			}

			return newStr;
		}

		/**
		 * Classic dummy text for use when wireframing with TextFields
		 */
		public static var LOREM_IPSUM:String = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";

		/**
		 * Standard ASCII alphabet (used in stripSpecialChars())
		 */
		public static var ALPHABET:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHJIKLMNOPQRSTUVWXYZ";

		/**
		 * Standard numerals (used in stripSpecialChars())
		 */
		public static var NUMERALS:String = "0123456789";

		/**
		 * Types used in {@link#pad()} function
		 */
		public static var PAD_RIGHT:Number = 0;

		public static var PAD_LEFT:Number = 1;

		public static var PAD_BOTH:Number = 2;


		/**
		 * This functions returns the sourceString string padded on the left, the right, or both sides
		 * to the specified padding length. If the optional argument pad is not supplied,
		 * the sourceString is padded with spaces, otherwise it is padded with characters from pad
		 * up to the limit.
		 *
		 * Optional argument type can be StringUtils.PAD_RIGHT, StringUtils.PAD_LEFT, or StringUtils.PAD_BOTH. If pad
		 * is not specified it is assumed to be StringUtils.PAD_RIGHT.
		 *
		 * If the value of length is negative or less than the length of the sourceString string, no
		 * padding takes place.
		 *
		 * @param sourceString The string to pad out
		 * @param length The final length (desired length) of the string
		 * @param padStr The string to use to pad it out (e.g. 1 character repeated)
		 * @param type The type of padding to use, PAD_RIGHT, PAD_LEFT, PAD_BOTH
		 * @return The modified string
		 */
		public static function pad( sourceString:String , length:Number , padStr:String , type:Number ):String
		{
			var padded:String;
			var charsToPad:Number = length - sourceString.length;
			if( charsToPad <= 0 )
				return sourceString;

			var padding:String = "";
			while( padding.length < charsToPad )
			{
				padding += padStr;
			}

			padding = padding.substr( 0 , charsToPad );

			switch( type )
			{
				case PAD_LEFT:
					padded = padding + sourceString;
					break;
				case PAD_BOTH:
					var left:Number = Math.floor( charsToPad / 2 );
					var right:Number = charsToPad - left;
					padded = padding.substr( 0 , left ) + sourceString + padding.substr( -right , right );
					break;
				case PAD_RIGHT:
				default:
					padded = sourceString + padding;
			}

			return padded;
		}


		/**
		 * Returns {@code str} repeated {@code multiplier} times. multiplier has to be greater than
		 * or equal to 0. If the multiplier is set to 0, the function will return an empty
		 * string.
		 *
		 * @param str The string to multiply
		 * @param multiplier The number of times to add str
		 * @return The new string
		 */
		public static function repeat( str:String , multiplier:Number ):String
		{
			var output:String = "";
			for( var i:Number = 0 ; i < multiplier ; i++ )
			{
				output += str;
			}
			return output;
		}


		/**
		 * Replaces all occurences of strings in a search array
		 *
		 * @param sourceStr The string to search
		 * @param searchArray Array of strings to look for in sourceStr
		 * @param replaceStr The string to replace found strings with
		 * @return The modified string
		 */
		public static function replaceMany( sourceStr:String , searchArray:Array , replaceStr:String ):String
		{
			for( var i:Number = 0 ; i < searchArray.length ; i++ )
			{
				sourceStr = sourceStr.split( searchArray[ i ] ).join( replaceStr );
			}
			return sourceStr;
		}


		/**
		 * Works like {@link #replaceMany()} but allows you to have multiple replace strings.
		 * <p>
		 * Replaces all occurences of search elements with correponding replace elements within subject
		 *
		 * @param sourceStr The string to search
		 * @param searchArray An array of search terms
		 * @param replaceArray An array of replace strings for given search terms
		 * @return The modified string
		 */
		public static function replaceManyWithMany( sourceStr:String , searchArray:Array , replaceArray:Array ):String
		{
			for( var i:Number = 0 ; i < searchArray.length ; i++ )
			{
				sourceStr = sourceStr.split( searchArray[ i ] ).join( replaceArray[ i ] );
			}
			return sourceStr;
		}


		/**
		 * This function performs the ROT13 encoding on the sourceString argument and returns the
		 * resulting string. The ROT13 encoding simply shifts every letter by 13 places
		 * in the alphabet while leaving non-alpha characters untouched. Encoding and
		 * decoding are done by the same function, passing an encoded string as argument
		 * will return the original version.
		 *
		 * @param sourceString The string to rotate
		 * @return The rotated string
		 */
		public static function rot13( sourceString:String ):String
		{
			var sourceString_arr:Array = sourceString.split( "" );
			var alphabet:Array = new String( ALPHABET ).split( "" );
			var alphaRot:Array = new String( "nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHJIKLM" ).split( "" );
			var encoder:Array = new Array();
			for( var i:Number = 0 ; i < alphabet.length ; i++ )
			{
				encoder[ alphabet[ i ] ] = alphaRot[ i ];
			}
			for( i = 0 ; i < sourceString_arr.length ; i++ )
			{
				if( encoder[ sourceString_arr[ i ] ] != undefined )
				{
					sourceString_arr[ i ] = encoder[ sourceString_arr[ i ] ];
				}
			}
			return sourceString_arr.join( "" );
		}


		/**
		 * Shuffles a string (mixes it up). One permutation of all possible is created.
		 *
		 * @param sourceString	String to shuffle
		 * @return the modified string
		 */
		public static function shuffle( sourceString:String ):String
		{
			var letters:Array = sourceString.split( "" );
			var rnd:Number;
			var tmp:String;
			for( var i:Number = 0 ; i < letters.length ; i++ )
			{
				rnd = Math.floor( Math.random() * letters.length );
				tmp = letters[ i ];
				letters[ i ] = letters[ rnd ];
				letters[ rnd ] = tmp;
			}
			return letters.join( "" );
		}


//		/**
//		 * Removes any white space from the end of a string
//		 * 
//		 * @param		String
//		 * @return		The modified string
//		 */
//		public static function rtrim( str:String ) : String
//		{
//			var str_arr:Array = str.split("");
//			var char:String;
//			while(true) {
//				char = str_arr[str_arr.length - 1];
//				if(char == "\r" || char == "\n" || char == "\t" || char == " ") {
//					str_arr.pop();
//					continue;
//				}
//				break;
//			}
//			return str_arr.join("");
//		}
//		
//		/**
//		 * Removes any white space from the begining of a string
//		 * 
//		 * @param		String
//		 * @return		The modified string
//		 */
//		public static function ltrim( str:String ) : String
//		{
//			var str_arr:Array = str.split("");
//			var char:String;
//			while(true) {
//				char = str_arr[0];
//				if(char == "\r" || char == "\n" || char == "\t" || char == " ") {
//					str_arr.shift();
//					continue;
//				}
//				break;
//			}
//			return str_arr.join("");
//		}
//		
//		/**
//		 * Removes any white space from the begining and end of a string
//		 * 
//		 * @param		String
//		 * @return		The modified string
//		 */
//		public static function trim( str:String ) : String
//		{
//			return rtrim(ltrim(str));
//		}

		/**
		 * Capitilizes the first letter of each word in a string (Standard English alphabet only)
		 *
		 * @param sourceString The string to upper case
		 * @return The modified string
		 */
		public static function upperCaseWords( sourceString:String ):String
		{
			var lower:Array = new String( "abcdefghijklmnopqrstuvwxyz" ).split( "" );
			var upper:Array = new String( "ABCDEFGHJIKLMNOPQRSTUVWXYZ" ).split( "" );
			var converter:Array = new Array();
			for( var i:Number = 0 ; i < lower.length ; i++ )
			{
				converter[ lower[ i ] ] = upper[ i ];
			}

			var words:Array = sourceString.split( " " );
			var letters:Array;
			for( i = 0 ; i < words.length ; i++ )
			{
				letters = words[ i ].split( "" );
				if( converter[ letters[ 0 ] ] != undefined )
				{
					letters[ 0 ] = converter[ letters[ 0 ] ];
				}
				words[ i ] = letters.join( "" );
			}
			return words.join( " " );
		}


//		/**
//		 * Counts the number of words in a string
//		 * @param sourceString The string to analyse
//		 * @return The number of words in a string
//		 */
//		public static function wordCount( sourceString:String ) : Number
//		{
//			return sourceString.split("").length;
//		}		

//		/**
//		 *	Returns a string truncated to a specified length with optional suffix
//		 *
//		 *	@param p_string The string.
//		 *
//		 *	@param p_len The length the string should be shortend to
//		 *
//		 *	@param p_suffix (optional, default=...) The string to append to the end of the truncated string.
//		 *
//		 *	@returns String
//		 *
//		 * 	@langversion ActionScript 3.0
//		 *	@playerversion Flash 9.0
//		 *	@tiptext
//		 */
//		public static function truncate( p_string:String , p_len:uint , p_suffix:String = "..." ):String
//		{
//			if( p_string == null )
//			{
//				return '';
//			}
//			p_len -= p_suffix.length;
//			var trunc:String = p_string;
//			if( trunc.length > p_len )
//			{
//				trunc = trunc.substr( 0 , p_len );
//				if( /[^\s]/.test( p_string.charAt( p_len )))
//				{
//					trunc = rtrim( trunc.replace( /\w+$|\s+$/ , '' ));
//				}
//				trunc += p_suffix;
//			}
//			
//			return trunc;
//		}

		// ADDED THE REGEX STUFF FROM SKINNERS SITE

		/**
		 *	Returns everything after the first occurrence of the provided character in the string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_begin The character or sub-string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function afterFirst( p_string:String , p_char:String ):String
		{
			if( p_string == null )
			{
				return '';
			}
			var idx:int = p_string.indexOf( p_char );
			if( idx == -1 )
			{
				return '';
			}
			idx += p_char.length;
			return p_string.substr( idx );
		}


		/**
		 *	Returns everything after the last occurence of the provided character in p_string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_char The character or sub-string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function afterLast( p_string:String , p_char:String ):String
		{
			if( p_string == null )
			{
				return '';
			}
			var idx:int = p_string.lastIndexOf( p_char );
			if( idx == -1 )
			{
				return '';
			}
			idx += p_char.length;
			return p_string.substr( idx );
		}


		/**
		 *	Determines whether the specified string begins with the specified prefix.
		 *
		 *	@param p_string The string that the prefix will be checked against.
		 *
		 *	@param p_begin The prefix that will be tested against the string.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function beginsWith( p_string:String , p_begin:String ):Boolean
		{
			if( p_string == null )
			{
				return false;
			}
			return p_string.indexOf( p_begin ) == 0;
		}


		/**
		 *	Returns everything before the first occurrence of the provided character in the string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_begin The character or sub-string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function beforeFirst( p_string:String , p_char:String ):String
		{
			if( p_string == null )
			{
				return '';
			}
			var idx:int = p_string.indexOf( p_char );
			if( idx == -1 )
			{
				return '';
			}
			return p_string.substr( 0 , idx );
		}


		/**
		 *	Returns everything before the last occurrence of the provided character in the string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_begin The character or sub-string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function beforeLast( p_string:String , p_char:String ):String
		{
			if( p_string == null )
			{
				return '';
			}
			var idx:int = p_string.lastIndexOf( p_char );
			if( idx == -1 )
			{
				return '';
			}
			return p_string.substr( 0 , idx );
		}


		/**
		 *	Returns everything after the first occurance of p_start and before
		 *	the first occurrence of p_end in p_string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_start The character or sub-string to use as the start index.
		 *
		 *	@param p_end The character or sub-string to use as the end index.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function between( p_string:String , p_start:String , p_end:String ):String
		{
			var str:String = '';
			if( p_string == null )
			{
				return str;
			}
			var startIdx:int = p_string.indexOf( p_start );
			if( startIdx != -1 )
			{
				startIdx += p_start.length; // RM: should we support multiple chars? (or ++startIdx);
				var endIdx:int = p_string.indexOf( p_end , startIdx );
				if( endIdx != -1 )
				{
					str = p_string.substr( startIdx , endIdx - startIdx );
				}
			}
			return str;
		}


		/**
		 *	Description, Utility method that intelligently breaks up your string,
		 *	allowing you to create blocks of readable text.
		 *	This method returns you the closest possible match to the p_delim paramater,
		 *	while keeping the text length within the p_len paramter.
		 *	If a match can't be found in your specified length an  '...' is added to that block,
		 *	and the blocking continues untill all the text is broken apart.
		 *
		 *	@param p_string The string to break up.
		 *
		 *	@param p_len Maximum length of each block of text.
		 *
		 *	@param p_delim delimter to end text blocks on, default = '.'
		 *
		 *	@returns Array
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function block( p_string:String , p_len:uint , p_delim:String = "." ):Array
		{
			var arr:Array = new Array();
			if( p_string == null || !contains( p_string , p_delim ))
			{
				return arr;
			}
			var chrIndex:uint = 0;
			var strLen:uint = p_string.length;
			var replPatt:RegExp = new RegExp( "[^" + escapePattern( p_delim ) + "]+$" );
			while( chrIndex < strLen )
			{
				var subString:String = p_string.substr( chrIndex , p_len );
				if( !contains( subString , p_delim ))
				{
					arr.push( truncate( subString , subString.length ) );
					chrIndex += subString.length;
				}
				subString = subString.replace( replPatt , '' );
				arr.push( subString );
				chrIndex += subString.length;
			}
			return arr;
		}


		/**
		 *	Capitallizes the first word in a string or all words..
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_all (optional) Boolean value indicating if we should
		 *	capitalize all words or only the first.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function capitalize( p_string:String , ... args ):String
		{
			var str:String = trimLeft( p_string );
			trace( 'capl' , args[ 0 ] )
			if( args[ 0 ] === true )
			{
				return str.replace( /^.|\b./g , _upperCase );
			}
			else
			{
				return str.replace( /(^\w)/ , _upperCase );
			}
		}


		/**
		 *	Determines whether the specified string contains any instances of p_char.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_char The character or sub-string we are looking for.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function contains( p_string:String , p_char:String ):Boolean
		{
			if( p_string == null )
			{
				return false;
			}
			return p_string.indexOf( p_char ) != -1;
		}


		/**
		 *	Determines the number of times a charactor or sub-string appears within the string.
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_char The character or sub-string to count.
		 *
		 *	@param p_caseSensitive (optional, default is true) A boolean flag to indicate if the
		 *	search is case sensitive.
		 *
		 *	@returns uint
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function countOf( p_string:String , p_char:String , p_caseSensitive:Boolean = true ):uint
		{
			if( p_string == null )
			{
				return 0;
			}
			var char:String = escapePattern( p_char );
			var flags:String = ( !p_caseSensitive ) ? 'ig' : 'g';
			return p_string.match( new RegExp( char , flags ) ).length;
		}


		/**
		 *	Levenshtein distance (editDistance) is a measure of the similarity between two strings,
		 *	The distance is the number of deletions, insertions, or substitutions required to
		 *	transform p_source into p_target.
		 *
		 *	@param p_source The source string.
		 *
		 *	@param p_target The target string.
		 *
		 *	@returns uint
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function editDistance( p_source:String , p_target:String ):uint
		{
			var i:uint;

			if( p_source == null )
			{
				p_source = '';
			}
			if( p_target == null )
			{
				p_target = '';
			}

			if( p_source == p_target )
			{
				return 0;
			}

			var d:Array = new Array();
			var cost:uint;
			var n:uint = p_source.length;
			var m:uint = p_target.length;
			var j:uint;

			if( n == 0 )
			{
				return m;
			}
			if( m == 0 )
			{
				return n;
			}

			for( i = 0 ; i <= n ; i++ )
			{
				d[ i ] = new Array();
			}
			for( i = 0 ; i <= n ; i++ )
			{
				d[ i ][ 0 ] = i;
			}
			for( j = 0 ; j <= m ; j++ )
			{
				d[ 0 ][ j ] = j;
			}

			for( i = 1 ; i <= n ; i++ )
			{

				var s_i:String = p_source.charAt( i - 1 );
				for( j = 1 ; j <= m ; j++ )
				{

					var t_j:String = p_target.charAt( j - 1 );

					if( s_i == t_j )
					{
						cost = 0;
					}
					else
					{
						cost = 1;
					}

					d[ i ][ j ] = _minimum( d[ i - 1 ][ j ] + 1 , d[ i ][ j - 1 ] + 1 , d[ i - 1 ][ j - 1 ] + cost );
				}
			}
			return d[ n ][ m ];
		}


		/**
		 *	Determines whether the specified string ends with the specified suffix.
		 *
		 *	@param p_string The string that the suffic will be checked against.
		 *
		 *	@param p_end The suffix that will be tested against the string.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function endsWith( p_string:String , p_end:String ):Boolean
		{
			return p_string.lastIndexOf( p_end ) == p_string.length - p_end.length;
		}


		/**
		 *	Determines whether the specified string contains text.
		 *
		 *	@param p_string The string to check.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function hasText( p_string:String ):Boolean
		{
			var str:String = removeExtraWhitespace( p_string );
			return !!str.length;
		}


		/**
		 *	Determines whether the specified string contains any characters.
		 *
		 *	@param p_string The string to check
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function isEmpty( p_string:String ):Boolean
		{
			if( p_string == null )
			{
				return true;
			}
			return !p_string.length;
		}


		/**
		 *	Determines whether the specified string is numeric.
		 *
		 *	@param p_string The string.
		 *
		 *	@returns Boolean
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function isNumeric( p_string:String ):Boolean
		{
			if( p_string == null )
			{
				return false;
			}
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return regx.test( p_string );
		}


		/**
		 * Pads p_string with specified character to a specified length from the left.
		 *
		 *	@param p_string String to pad
		 *
		 *	@param p_padChar Character for pad.
		 *
		 *	@param p_length Length to pad to.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function padLeft( p_string:String , p_padChar:String , p_length:uint ):String
		{
			var s:String = p_string;
			while( s.length < p_length )
			{
				s = p_padChar + s;
			}
			return s;
		}


		/**
		 * Pads p_string with specified character to a specified length from the right.
		 *
		 *	@param p_string String to pad
		 *
		 *	@param p_padChar Character for pad.
		 *
		 *	@param p_length Length to pad to.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function padRight( p_string:String , p_padChar:String , p_length:uint ):String
		{
			var s:String = p_string;
			while( s.length < p_length )
			{
				s += p_padChar;
			}
			return s;
		}


		/**
		 *	Properly cases' the string in "sentence format".
		 *
		 *	@param p_string The string to check
		 *
		 *	@returns String.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function properCase( p_string:String ):String
		{
			if( p_string == null )
			{
				return '';
			}
			var str:String = p_string.toLowerCase().replace( /\b([^.?;!]+)/ , capitalize );
			return str.replace( /\b[i]\b/ , "I" );
		}


		/**
		 *	Escapes all of the characters in a string to create a friendly "quotable" sting
		 *
		 *	@param p_string The string that will be checked for instances of remove
		 *	string
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function quote( p_string:String ):String
		{
			var regx:RegExp = /[\\"\r\n]/g;
			return '"' + p_string.replace( regx , _quote ) + '"'; //"
		}


		/**
		 *	Removes all instances of the remove string in the input string.
		 *
		 *	@param p_string The string that will be checked for instances of remove
		 *	string
		 *
		 *	@param p_remove The string that will be removed from the input string.
		 *
		 *	@param p_caseSensitive An optional boolean indicating if the replace is case sensitive. Default is true.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function remove( p_string:String , p_remove:String , p_caseSensitive:Boolean = true ):String
		{
			if( p_string == null )
			{
				return '';
			}
			var rem:String = escapePattern( p_remove );
			var flags:String = ( !p_caseSensitive ) ? 'ig' : 'g';
			return p_string.replace( new RegExp( rem , flags ) , '' );
		}


		/**
		 *	Removes extraneous whitespace (extra spaces, tabs, line breaks, etc) from the
		 *	specified string.
		 *
		 *	@param p_string The String whose extraneous whitespace will be removed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function removeExtraWhitespace( p_string:String ):String
		{
			if( p_string == null )
			{
				return '';
			}
			var str:String = trim( p_string );
			return str.replace( /\s+/g , ' ' );
		}


		/**
		 *	Returns the specified string in reverse character order.
		 *
		 *	@param p_string The String that will be reversed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function reverse( p_string:String ):String
		{
			if( p_string == null )
			{
				return '';
			}
			return p_string.split( '' ).reverse().join( '' );
		}


		/**
		 *	Returns the specified string in reverse word order.
		 *
		 *	@param p_string The String that will be reversed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function reverseWords( p_string:String ):String
		{
			if( p_string == null )
			{
				return '';
			}
			return p_string.split( /\s+/ ).reverse().join( '' );
		}


		/**
		 *	Determines the percentage of similiarity, based on editDistance
		 *
		 *	@param p_source The source string.
		 *
		 *	@param p_target The target string.
		 *
		 *	@returns Number
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function similarity( p_source:String , p_target:String ):Number
		{
			var ed:uint = editDistance( p_source , p_target );
			var maxLen:uint = Math.max( p_source.length , p_target.length );
			if( maxLen == 0 )
			{
				return 100;
			}
			else
			{
				return ( 1 - ed / maxLen ) * 100;
			}
		}


		/**
		 *	Remove's all < and > based tags from a string
		 *
		 *	@param p_string The source string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function stripTags( p_string:String ):String
		{
			if( p_string == null )
			{
				return '';
			}
			return p_string.replace( /<\/?[^>]+>/igm , '' );
		}


		/**
		 *	Swaps the casing of a string.
		 *
		 *	@param p_string The source string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function swapCase( p_string:String ):String
		{
			if( p_string == null )
			{
				return '';
			}
			return p_string.replace( /(\w)/ , _swapCase );
		}


		/**
		 *	Removes whitespace from the front and the end of the specified
		 *	string.
		 *
		 *	@param p_string The String whose beginning and ending whitespace will
		 *	will be removed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function trim( p_string:String ):String
		{
			if( p_string == null )
			{
				return '';
			}
			return p_string.replace( /^\s+|\s+$/g , '' );
		}


		/**
		 *	Removes whitespace from the front (left-side) of the specified string.
		 *
		 *	@param p_string The String whose beginning whitespace will be removed.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function trimLeft( p_string:String ):String
		{
			if( p_string == null )
			{
				return '';
			}
			return p_string.replace( /^\s+/ , '' );
		}


		/**
		 *	Removes whitespace from the end (right-side) of the specified string.
		 *
		 *	@param p_string The String whose ending whitespace will be removed.
		 *
		 *	@returns String	.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function trimRight( p_string:String ):String
		{
			if( p_string == null )
			{
				return '';
			}
			return p_string.replace( /\s+$/ , '' );
		}


		/**
		 *	Determins the number of words in a string.
		 *
		 *	@param p_string The string.
		 *
		 *	@returns uint
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function wordCount( p_string:String ):uint
		{
			if( p_string == null )
			{
				return 0;
			}
			return p_string.match( /\b\w+\b/g ).length;
		}


		/**
		 *	Returns a string truncated to a specified length with optional suffix
		 *
		 *	@param p_string The string.
		 *
		 *	@param p_len The length the string should be shortend to
		 *
		 *	@param p_suffix (optional, default=...) The string to append to the end of the truncated string.
		 *
		 *	@returns String
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function truncate( p_string:String , p_len:uint , p_suffix:String = "..." ):String
		{
			if( p_string == null )
			{
				return '';
			}
			p_len -= p_suffix.length;
			var trunc:String = p_string;
			if( trunc.length > p_len )
			{
				trunc = trunc.substr( 0 , p_len );
				if( /[^\s]/.test( p_string.charAt( p_len ) ))
				{
					trunc = trimRight( trunc.replace( /\w+$|\s+$/ , '' ) );
				}
				trunc += p_suffix;
			}

			return trunc;
		}


		/**
		 * returns domain from url - WORK ON regexp, not generic enough
		 *
		 * @param url
		 * @return
		 *
		 */
		public static function getDomainFromUrl( url:String ):String
		{
			var pattern:RegExp = new RegExp( "^(?:http://)?([^/]+)" , "i" );
			return pattern.exec( url )[ 0 ];
		}


		/**
		 *
		 * @param s
		 * @return whether a string only contains alpha characters
		 *
		 */
		public static function isAlpha( s:String ):Boolean
		{
			var pattern:RegExp = new RegExp( "[^a-zA-Z]" );
			return !s.match( pattern );
		}


		/**
		 *
		 * @param s
		 * @return whether a string only contains alpha numeric characters
		 *
		 */
		public static function isAlphaNumeric( s:String ):Boolean
		{
			var pattern:RegExp = new RegExp( "[^0-9a-zA-Z]" );
			return !s.match( pattern );
		}


		/* **************************************************************** */
		/*	These are helper methods used by some of the above methods.		*/
		/* **************************************************************** */
		private static function escapePattern( p_pattern:String ):String
		{
			// RM: might expose this one, I've used it a few times already.
			return p_pattern.replace( /(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g , '\\$1' );
		}


		private static function _minimum( a:uint , b:uint , c:uint ):uint
		{
			return Math.min( a , Math.min( b , Math.min( c , a ) ) );
		}


		private static function _quote( p_string:String , ... args ):String
		{
			switch( p_string )
			{
				case "\\":
					return "\\\\";
				case "\r":
					return "\\r";
				case "\n":
					return "\\n";
				case '"':
					return '\\"';
				default:
					return '';
			}
		}


		private static function _upperCase( p_char:String , ... args ):String
		{
			trace( 'cap latter ' , p_char )
			return p_char.toUpperCase();
		}


		private static function _swapCase( p_char:String , ... args ):String
		{
			var lowChar:String = p_char.toLowerCase();
			var upChar:String = p_char.toUpperCase();
			switch( p_char )
			{
				case lowChar:
					return upChar;
				case upChar:
					return lowChar;
				default:
					return p_char;
			}
		}

	}
}
