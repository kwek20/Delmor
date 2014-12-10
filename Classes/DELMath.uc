/**
 * This class contains a few useful mathematical functions.
 * 
 * @author Anders Egberts
 */
class DELMath extends Actor;

/**
 * Returns the sign of n.
 * @param n int The number for which you want to return the sign.
 */
function int sign( int n ){
	if ( n > 0 )
		return 1;
	if ( n == 0 )
		return 0;
	if ( n < 0 )
		return -1;
}

/**
 * Returns the module of n.
 * @param n     int The number to return the modulo from.
 * @param mod   int The modulo that should be applied to n.
 */
function int modulo( int n , int mod ){
	local int nn;

	if ( n <= mod )
		return n;
	else{
		nn = n;
		while( nn > mod ){
			nn -= mod;
		}

		return nn;
	}
}

static function int floor(float number){
	return number - number % 1;
}

static function int ceil(float number){
	return number + (1- number % 1);
}

static function int roud(float number){
	local float decimal;
	decimal = number%1;
	return number + decimal < 0.5 ? -decimal : 1-decimal;
}

DefaultProperties
{
}
