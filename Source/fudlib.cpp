//----------------------------------------------------------------------------------------------------
//	FUDLib.cpp Set of User Defined Functions for Interbase
//  Copyright (C) 2000 Rachel Bowyer.
//
//  Author: Rachel Bowyer (rachbowyer@gmail.com)
//
//	This program is free software; you can redistribute it and/or modify
//	it under the terms of the GNU General Public License version 2 as published by
//	the Free Software Foundation.
//
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//   	You should have received a copy of the GNU General Public License
//   	along with this program; if not, write to the Free Software
//   	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//----------------------------------------------------------------------------------------------------

#include <math.h>
//#include <algorithm>
#include <ctype.h> 
#include <ibase.h>
#include <string.h>
#include <malloc.h>
#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include <limits.h>
#include <stdlib.h>

extern "C" {
#include <ib_util.h>
};


//----------------------------------------------------------------------------------------------------
// Preconditions, postconditions and checks
//----------------------------------------------------------------------------------------------------


// #define _DEBUG 1

#if (defined(_DEBUG) && defined(WIN32))
#include "windows.h"
#include <string>
#include <sstream.h>

void fud_assert_helper(const char * type, const char * file, int num, const char * description)
{
    std::string title(type);
    title+= " failed";

    std::stringstream  message;
    message << "Condition: " << description << "\nAt " <<  file << " line " << num;

    ::MessageBox(0, message.str().c_str(), title.c_str(), MB_ICONEXCLAMATION | MB_OK);
}


#define fud_precondition(f)							\
    if (!(f))									\
      fud_assert_helper("Precondition", __FILE__, __LINE__, #f)

#define fud_postcondition(f)							\
    if (!(f))									\
      fud_assert_helper( "Postcondition", __FILE__, __LINE__, #f)

#define fud_check(f)								\
    if (!(f))									\
      fud_assert_helper("Check", __FILE__, __LINE__, #f)

      
#else
#define fud_precondition(f) ((void)0)
#define fud_postcondition(f) ((void)0)
#define fud_check(f) ((void)0)
#endif


const double 	NaN 	= -999999;
const int	intNaN 	= -999999;
const double 	PI 	= 3.1415926535897932384626433832795;


//!RCB in case bool is not supported
typedef unsigned short 	fud_bool;
const fud_bool 		fud_true 	= 1;
const fud_bool 		fud_false 	= 0;


//----------------------------------------------------------------------------------------------------
// abs value suite
//----------------------------------------------------------------------------------------------------


extern "C" double ISC_EXPORT fudlib_absdbl(double const * a) 
{
  return fabs(*a);
}

extern "C" float ISC_EXPORT fudlib_absflt(float const * a )
{
  return (float)fabs(*a);
}

extern "C" int ISC_EXPORT fudlib_absint(int const * a) 
{
  return abs(*a);
}

extern "C" short ISC_EXPORT fudlib_abssml(short const * a) 
{
  return (short)abs(*a);
}


//----------------------------------------------------------------------------------------------------
// max suite
//----------------------------------------------------------------------------------------------------

extern "C" double ISC_EXPORT fudlib_maxdbl(double const * a, double const* b) 
{
  //  return std::max(*a, *b);
  return (*a) > (*b) ? (*a) : (*b);
}


extern "C" float ISC_EXPORT fudlib_maxflt(float const * a, float const * b)
{
  //  return std::max(*a, *b);
  return (*a) > (*b) ? (*a) : (*b);
}


extern "C" int ISC_EXPORT fudlib_maxint(int const * a, int const * b) 
{
  //  return std::max(*a, *b);
  return (*a) > (*b) ? (*a) : (*b);
}

extern "C" short ISC_EXPORT fudlib_maxsml(short const * a, short const * b) 
{
  //  return std::max(*a, *b);
  return (*a) > (*b) ? (*a) : (*b);
}

//----------------------------------------------------------------------------------------------------
// min suite
//----------------------------------------------------------------------------------------------------

extern "C" double ISC_EXPORT fudlib_mindbl(double const * a, double const* b) 
{
  //  return std::min(*a, *b);
  return (*a) < (*b) ? (*a) : (*b);
}


extern "C" float ISC_EXPORT fudlib_minflt(float const * a, float const * b)
{
  //  return std::min(*a, *b);
  return (*a) < (*b) ? (*a) : (*b);
}


extern "C" int ISC_EXPORT fudlib_minint(int const * a, int const * b) 
{
  //  return std::min(*a, *b);
  return (*a) < (*b) ? (*a) : (*b);
}

extern "C" short ISC_EXPORT fudlib_minsml(short const * a, short const * b) 
{
  //  return std::min(*a, *b);
  return (*a) < (*b) ? (*a) : (*b);
}




//----------------------------------------------------------------------------------------------------
// trig suite
//----------------------------------------------------------------------------------------------------

extern "C" double ISC_EXPORT fudlib_cos(double const * a)
{
  return cos(*a);
}

extern "C" double ISC_EXPORT fudlib_acos(double const * a)
{
  return ((*a) >= -1 && (*a) <= 1) ? acos(*a) : NaN;
}

extern "C" double ISC_EXPORT fudlib_asin(double const * a)
{
  return ((*a) >= -1 && (*a) <= 1) ? asin(*a) : NaN;
}

extern "C" double ISC_EXPORT fudlib_sin(double const * a)
{
  return sin(*a);
}

extern "C" double ISC_EXPORT fudlib_atan(double const * a)
{
  return atan(*a);
}

extern "C" double ISC_EXPORT fudlib_tan(double const * a)
{
  return tan(*a);
}

extern "C" double ISC_EXPORT fudlib_atan2(double const * y, double const * x)
{
  return (fabs(*x) > 1e-10) ? atan(*y / *x) : NaN;
}

extern "C" double ISC_EXPORT fudlib_ceiling(double const * a)
{
  return ceil(*a);
}

extern "C" double ISC_EXPORT fudlib_floor(double const * a)
{
  return floor(*a);
}

extern "C" double ISC_EXPORT fudlib_degrees(double const * a)
{
  return (*a / PI) * 180.0;
}

extern "C" double ISC_EXPORT fudlib_radians(double const * a)
{
  return (*a / 180.0) * PI;
}


extern "C" double ISC_EXPORT fudlib_exp(double const * a)
{
  if ((*a < -700.0 ) || (*a > 700.0))
    return NaN;
  else
    return exp(*a);
}

extern "C" double ISC_EXPORT fudlib_fact(double const * a)
{
  long temp = long(*a);

  if (temp <= 0 || temp > 100)
    return NaN;
  else {
    
    long result = 1;    
    while (temp > 1) {
      result *= temp;
      temp--;
    }
    
    return result;
  }
}

extern "C" double ISC_EXPORT fudlib_PI()
{
  return PI;
}

extern "C" double ISC_EXPORT fudlib_log(double const * a)
{
  return ((*a) >= 1.0e-304) ? log(*a) : NaN;
}

extern "C" double ISC_EXPORT fudlib_log10(double const * a)
{
  return ((*a) >= 1.0e-304) ? log10(*a) : NaN;
}

extern "C" double ISC_EXPORT fudlib_pow(double const * a, double const* b)
{
  return (*a >= 0.0) ? pow(*a, *b) : NaN;
}

extern "C" double ISC_EXPORT fudlib_pow10(double const * a)
{
  long temp = long(*a);

  if (temp > -305 && temp < 305)
    return pow(10.0, temp);
  else 
    return NaN;
}

//!RCB Later
//namespace {
static double precisionHelper(double a, int precision, fud_bool round, bool UDFCompHack)
{
  if (precision  >= -304 && precision <= 304) {
    
    double factor 	= pow (10.0, precision);
    double temp 	= factor * a;
    double adjust	= (round) ? 0.5 : 0.0;

    if (temp >= 0) 
      temp = floor(temp + adjust);
    else if (round || !UDFCompHack)      
      temp = ceil(temp - adjust);      
    else
      // Truncating && UFDCompatibility hack
      // !RCB I think truncating -723.123 to 2dp should yield -723.12, but
      // UFDLib thinks it is -723.13.  For compatibility we stick with UFDLib.
      temp = floor(temp - adjust);

    
    temp /= factor;

    return temp; 
   
  } else
    return NaN;
}
// };

extern "C" double ISC_EXPORT fudlib_round(double const * a, int const* b)
{
  return precisionHelper(*a, *b, fud_true /*round */, fud_true /*UDFCompHack*/);
}

extern "C" double ISC_EXPORT fudlib_udftruncate(double const * a, int const* b)
{
  return precisionHelper(*a, *b, fud_false /*round */, fud_true /*UDFCompHack*/);
}

extern "C" double ISC_EXPORT fudlib_truncate(double const * a, int const* b)
{
  return precisionHelper(*a, *b, fud_false /*round */, fud_false /*UDFCompHack*/);
}

extern "C" double ISC_EXPORT fudlib_sqrt(double const * a)
{
  return ((*a) >= 0.0) ? sqrt(*a) : NaN;
}


extern "C" int ISC_EXPORT fudlib_modquot(int const * a, int const * b)
{
  // We handle negative numbers specially for consistent behaviour

  if (*b != 0) {

    int quot = abs(*a) / abs(*b);

    if ( 
	     ((*a) < 0 && (*b) > 0)		||
	     ((*a) > 0 && (*b) < 0)
    )
      // Flip sign
      quot *= -1;

    return quot;
  }
  else
    return intNaN;
}

extern "C" int ISC_EXPORT fudlib_modrem(int const * a, int const * b)
{
  // We do not use % because we want consistent behaviour with negative numbers

  if (*b != 0)
    return int(fmod(*a, *b));
  else
    return intNaN;
}

//----------------------------------------------------------------------------------------------------
// Version numbers
//----------------------------------------------------------------------------------------------------


extern "C" double ISC_EXPORT fudlib_ver()
{
  // None of the documentation from Mer gives a ver number for UFDLib.  
  // So I will have to guess
  return 1.0;
}

extern "C" int  ISC_EXPORT fudlib_fud_ver()
{
  // Version number of FUDLibrary * 100
  return 50;	// For version 0.5
}


//----------------------------------------------------------------------------------------------------
// Trim functions
//----------------------------------------------------------------------------------------------------

typedef fud_bool (*FNisRubbish)(char, char);


//!RCB Later
//namespace {

static char * alloc_string(long length)
{
  return (char *)ib_util_malloc(length); 
}

static fud_bool isChar(char value, char compare)
{
  return (compare == value) ? fud_true : fud_false;
}

static fud_bool isBlank(char value, char)
{
  return (' ' == value) ? fud_true : fud_false;
}

static fud_bool isWhitespace(char value, char)
{
  return isspace(value) ? fud_true : fud_false;
}



char* alltrim_helper(const char * str, FNisRubbish isRubbish, fud_bool leading, fud_bool trailing, char extra = '\0')
{
  // Skip leading blanks
  if (leading)
    while (isRubbish(*str, extra) && '\0' != (*str))
      str++;
  
  // Find end of string
  long length  = 0;

  if (trailing) {
    for (long i = 0; '\0' != str[i]; i++)
      if (!isRubbish(str[i], extra))
	length = i + 1;
  } else {
    length = strlen(str);
  }

  // Just in case a string longer than 255 characters is snuck in
  if (length > 255) 
    length = 255;

  char * result = alloc_string(256);
  strncpy(result, str, length);
  result[length] = '\0';
   
  return result;
}


extern "C" char* ISC_EXPORT fudlib_alltrim(const char * str)
{
  return alltrim_helper(str, isBlank, fud_true /* leading */, fud_true /* trailing */);
}

extern "C" char* ISC_EXPORT fudlib_fud_alltrim(const char * str)
{
  return alltrim_helper(str, isWhitespace, fud_true /* leading */, fud_true /* trailing */);
}

extern "C" char* ISC_EXPORT fudlib_alltrimc(const char * str, const char* compare)
{
   return alltrim_helper(str, isChar, fud_true /* leading */, fud_true /* trailing */, compare[0]);
}

extern "C" char* ISC_EXPORT fudlib_ltrim(const char * str)
{
  return alltrim_helper(str, isBlank, fud_true /* leading */, fud_false /* trailing */);
}

extern "C" char* ISC_EXPORT fudlib_fud_ltrim(const char * str)
{
  return alltrim_helper(str, isWhitespace, fud_true /* leading */, fud_false /* trailing */);
}

extern "C" char* ISC_EXPORT fudlib_ltrimc(const char * str, const char * compare)
{
  if ('\0' == compare[0])
    return strcpy(alloc_string(256), str);
  else
    return alltrim_helper(str, isChar, fud_true /* leading */, fud_false /* trailing */, compare[0]);
}

extern "C" char* ISC_EXPORT fudlib_rtrim(const char * str)
{
  return alltrim_helper(str, isBlank, fud_false /* leading */, fud_true /* trailing */);
}

extern "C" char* ISC_EXPORT fudlib_fud_rtrim(const char * str)
{
  return alltrim_helper(str, isWhitespace, fud_false /* leading */, fud_true /* trailing */);
}

extern "C" char* ISC_EXPORT fudlib_rtrimc(const char * str, const char * compare)
{
  if ('\0' == compare[0])
    return strcpy(alloc_string(256), str);
  else
    return alltrim_helper(str, isChar, fud_false /* leading */, fud_true /* trailing */, compare[0]);
}

//----------------------------------------------------------------------------------------------------
// Soundex search
//----------------------------------------------------------------------------------------------------

static inline fud_bool isHorW(char c)
{
  return ('H' == c || 'W' == c) ? fud_true : fud_false; 
}


static const char g_soundexCodes[26] =
{
    '\0',	// A
    '1',	// B
    '2',	// C
    '3',	// D
    '\0',	// E
    '1',	// F
    '2',	// G
    '\0',	// H
    '\0',	// I
    '2',	// J
    '2',	// K
    '4',	// L
    '5',	// M
    '5',	// N
    '\0',	// O
    '1',	// P
    '2',	// Q
    '6',	// R
    '2',	// S
    '3',	// T
    '\0',	// U
    '1',	// V
    '\0',	// W
    '2',	// X
    '\0',	// Y
    '2'		// Z
};

static inline fud_bool getSoundexCode(const char c, char& code)
{ 
  if (c >= 'A' && c <= 'Z') {
    code = g_soundexCodes[c - 'A'];
    return ('\0' != code) ? fud_true : fud_false;
  }
  else
    return fud_false;
}

extern "C" char* ISC_EXPORT fudlib_soundex(const char * str)
{
  //
  // Converts a string into a Soundex Code.
  //  This function uses the algorithm described by Donald Knuth in
  //  The Art of Computer Programming Volume 3.
  //  Soundex searching was originally invented by Margaret Odell and Robert Russell 
  //

  char * result = alloc_string(256);

  if ('\0' == str[0])
    // For an empty string we return an empty string
    result[0] ='\0';
  else {
    
    // First letter comes across straight
    result[0] = char(toupper(str[0]));		// ANSI defines toupper as returning an int!

    char firstLetterSoundex;
    if (!getSoundexCode(result[0], firstLetterSoundex))
	    firstLetterSoundex = '\0';

    fud_bool adjacent = fud_true;
    int writeTo = 1;

    for (int i = 1; ; i++) {
      
      char currentChar = char(toupper(str[i]));

      if ('\0' == currentChar || 4 == writeTo)
	       // End of word or we have our code
	       break;
      
      if (isHorW(currentChar))
	     continue;
  
      char soundexCode;
      if (getSoundexCode(currentChar, soundexCode)) {
	
      	// Note previousSoundex = '\0' if there has not been one
      	char previousSoundex = (1 == writeTo) ? firstLetterSoundex : result[writeTo - 1];  	  
      	
      	if  (
      	   '\0' == previousSoundex		||	// No previous Soundex character
      	   previousSoundex != soundexCode	||	// Different soundex character
      	   fud_false == adjacent		        // H or W so fine 
      	) {
      	  result[writeTo++] = soundexCode;
      	  adjacent = fud_true;
      	}
      	else
      	  adjacent = fud_false;
      }
      else
	      adjacent = fud_false;
    }

    // Expand the soundex code so
    // it is 4 characters
      
    while (writeTo < 4)
      result[writeTo++] = '0';
      
    // Truncate it at 4 characters
    result[4] = '\0';
  } 

  return result;
}


//----------------------------------------------------------------------------------------------------
// Pad functions
//----------------------------------------------------------------------------------------------------

extern "C" char* ISC_EXPORT fudlib_pad(const char * str, char const * c, int const *  number)
{
  char * result    = alloc_string(256);
  int 	 length    = strlen(str);
  int 	 add 	   = (*number) - length;		

  if (
      '\0' == c[0]	||	// Pad character blank
      add < 0		||	// Make string smaller
      (*number)  > 255		// Buffer would overflow
  )    
    return strcpy(result, "Bad parameters in rpad");

  strcpy(result, str);
  while (add > 0) {
    result[length++] = c[0];
    add--;
  }
  result[length] = '\0';

  return result;
}

extern "C" char* ISC_EXPORT fudlib_lpad(const char * str, char const * c, int const * number)
{
  char * result    = alloc_string(256);
  int 	 length    = strlen(str);
  int 	 add 	   = (*number) - length;		

  if (
      '\0' == c[0]	||	// Pad character blank
      add < 0		||	// Make string smaller
      (*number) > 255		// Buffer would overflow
  )    
    return strcpy(result, "Bad parameters in lpad");

  int pos = 0;
  while (pos < add) {
    result[pos++] = c[0];
  }
  strcpy(result + pos, str);
  

  return result;
}


extern "C" char* ISC_EXPORT fudlib_centre(const char * str, char const * c, int const * number)
{
  char * result    = alloc_string(256);
  int 	 length    = strlen(str);
  int 	 add 	   = (*number) - length;		

  if (
      '\0' == c[0]	||	// Pad character blank
      add < 0		||	// Make string smaller
      (*number) > 255		// Buffer would overflow
  )    
    return strcpy(result, "Bad parameters in center");

  int lhs = add / 2;
  int rhs = lhs + (add % 2);

  // Left hand padding
  int pos = 0;
  while (pos < lhs) {
    result[pos++] = c[0];
  }

  // String itself
  strcpy(result + pos, str);

  // Right hand padding
  pos+= length;
  while (rhs > 0) {
    result[pos++] = c[0];
    rhs--;
  }
  result[pos] = '\0';
  
  return result;
}

extern "C" int ISC_EXPORT fudlib_len(const char * str)
{
  return strlen(str);
}


extern "C" char * ISC_EXPORT fudlib_lower(const char * str)
{
  char * result = alloc_string(256);
  
  int i = 0;
  do {
    result[i] = char(tolower(str[i]));
  } 
  while ('\0' != str[i++]);

  return result;
}

extern "C" char * ISC_EXPORT fudlib_stradd(const char * str1, const char * str2)
{
  char * result = alloc_string(512);

  int length1 = strlen(str1);
  int count = 511 - length1;

  strcpy(result, str1);
  if (count > 0) {
    strncat(result, str2, count);
    result[length1 + count] = '\0'; 
  }

  return result;
}

extern "C" char * ISC_EXPORT fudlib_strdel(const char * str, int const * pos, int const * substr_length)
{
  char * result = alloc_string(256);
  int 	 length = strlen(str);

  if (
      (*pos) < 0			||
      length < 0			||
      (*pos) + (*substr_length) > length
  )
    return strcpy(result, "Bad paramaters in chrdelete");

  
  strncpy(result, str, (*pos));
  result[(*pos)] = '\0';
  strcat(result, str + (*pos) + (*substr_length));

  return result;
}

extern "C" char * ISC_EXPORT fudlib_cstr_plus_int(const char * str, int* value)
{
  char * result = alloc_string(256);
  int length = strlen(str);
  
  // An integer can take up 33 characters
  if (length + 33 > 255)
    return strcpy(result, "Bad parameters in cstr_plus_int");

  strcpy(result, str);
  itoa(*value, result + length, 10 /* radix */);

  return result;
}


extern "C" char * ISC_EXPORT fudlib_int_plus_cstr(const char * str, int const * value)
{
  char * result = alloc_string(256);
  int length = strlen(str);
  
  // An integer can take up 33 characters
  if (length + 33 > 255)
    return strcpy(result, "Bad parameters in cstr_int_plus_cstr");

  itoa(*value, result, 10 /* radix */);
  strcat(result, str);

  return result;
}



extern "C" double ISC_EXPORT fudlib_cstr_to_dbl(const char * str)
{
  return atof(str);
}


extern "C" int ISC_EXPORT fudlib_ascii(const char * str)
{
  if ('\0' == str[0])
    return 0;
  else
    return str[0];
}


extern "C" char * ISC_EXPORT fudlib_chr(int const * value)
{
  char * result = alloc_string(256);

  if (value < 0 || (*value) > 255)
    return strcpy(result, "Value out of range");

  result[0] = char(*value);
  result[1] = '\0';

  return result;
}

extern "C" char * ISC_EXPORT fudlib_parse(const char * str, const char * token, int const * pos)
{
  char * result = alloc_string(256);

  if ('\0' == token[0] || (*pos) <= 0)
    // Spelling mistake for fudlib compatibility
    return strcpy(result, "Bad Paramaters in Parse");
  
  int writePos 		= 0;
  int currentSubstr	= 1;

  for (int i = 0; '\0' != str[i] ; i++) {
    
    if (token[0] == str[i]) {
      if (++currentSubstr > (*pos))
	break;
    } 
    else if (currentSubstr == (*pos))
      result[writePos++] = str[i];    
  }

  if (currentSubstr < (*pos))
    // This time we put a grammar mistake in the error
    // message for fudlib compatibility
    return strcpy(result, "Token to long in parse");

  result[writePos] = '\0';
  return result;
}


extern "C" int ISC_EXPORT fudlib_pos(const char * str, const char * substr, int* start, int* occurrence)
{
  // Start 	- zero based position to start searching
  // occurence	- 1 for first substr, 2 for the second
  // Returns	- 0 based index of substr, -1 not found and intNan if bad parameters

  int length = strlen(str);

  if ((*start) < 0 || (*start) >= length || (*occurrence) < 1)
    return intNaN;

  const char * startSubstr = str + (*start);

  for (int i = (*occurrence); i > 0; i--) {

    startSubstr = strstr(startSubstr,  substr);
    if (!startSubstr)
      // String not found
      return -1;
    
    startSubstr++;
  } 

  return startSubstr - 1 - str;
}

extern "C" char * ISC_EXPORT fudlib_proper(const char * str)
{
  char * result = alloc_string(256);

  fud_bool prevCharWhiteSpace  = fud_true;

  int i = 0;
  for (; '\0' != str[i]; i++) {    
    result[i] = (prevCharWhiteSpace) ? char(toupper(str[i])) : str[i];
    prevCharWhiteSpace = isspace(str[i]) ? fud_true : fud_false; 
  }
  
  result[i] = '\0';

  return result;
}

extern "C" char * ISC_EXPORT fudlib_reverse(const char * str)
{
  char * result = alloc_string(256);
  int length 	= strlen(str);

  for (int i = 0; i < length; i++)
    result[length -1 - i] = str[i];

  result[length] = '\0';
  
  return result;
}

extern "C" char * ISC_EXPORT fudlib_lefts(const char * str, int const * number)
{
  char * result = alloc_string(256);
  //  int length = strlen(str);
  
  if ((*number) < 1 /* || (*number) > length*/)
    return strcpy(result, "Bad parameters in substring");

  strncpy(result, str, (*number));
  result[*number] = '\0'; 

  return result;
}

extern "C" char * ISC_EXPORT fudlib_rights(const char * str, int const *  number)
{
  char * result = alloc_string(256);
  int length = strlen(str);

  if ((*number) < 1  || (*number) > length)
    return strcpy(result, "Bad parameters in substring");

  return strcpy(result, str + length - (*number));
}


extern "C" char * ISC_EXPORT fudlib_substr(const char * str, int const * start, int const *  end)
{
  //
  // start - 1 based index, substring starts
  // end  - 1 based index where it ends

  char * result = alloc_string(256);
  int length = strlen(str);

  if ((*start) < 1 || (*end) < 1 || (*end) < (*start) || (*end) >= length)
    return strcpy(result, "Bad parameters in substring");    

  if ((*start) != (*end))
    strncpy(result, str - 1  + (*start), (*end) - (*start));

  result[(*end) - (*start)] = '\0';

  return result;
}

extern 
"C" char * ISC_EXPORT fudlib_replicate(const char * str, int const * count)
{
  char * result = alloc_string(256);

  if ((*count) < 0 || (*count) > 255 || '\0' == str)
    return strcpy(result, "Bad parameters");

  for (int i = 0; i < (*count); i++)
    result[i] = str[0];

  result[(*count)]='\0';

  return result;
}


//----------------------------------------------------------------------------------------------------
// CIBTimeStamp
//----------------------------------------------------------------------------------------------------

class CIBTimeStamp{
public:  
  CIBTimeStamp();
  CIBTimeStamp(const ISC_TIMESTAMP& ibTimeStamp);

  void set(const ISC_TIMESTAMP& ibTimeStamp);
  void get(ISC_TIMESTAMP& ibTimeStamp) const;
  ISC_TIMESTAMP* createNew() const;
  long getMsec() const;
  void setMsec(long);
  long getYear() const;
  void zeroTime();
  void maxTime();
  void normalise();
  int daysInMonth() const;
  int daysInYear() const;
  static int daysInYear(int year);

  static fud_bool isLeap(int year);
  friend int compare(const CIBTimeStamp & timeStamp1, const CIBTimeStamp&  timeStamp2);

  tm	 	tmstruct;
  long 		msec;
 

private:
  static ISC_TIMESTAMP * alloc_timestamp();
  static int daysInMonth(int year, int month);
  static void normaliseYearMonth(int& year, int& month);
  inline void validate() const;
};


//----------------------------------------------------------------------------------------------------
// CIBTimeStamp - operations
//----------------------------------------------------------------------------------------------------


CIBTimeStamp::CIBTimeStamp() : msec(0)
{
  memset(&tmstruct, '\0', sizeof(tm));  
}

CIBTimeStamp::CIBTimeStamp(const ISC_TIMESTAMP& ibTimeStamp)
{
  set(ibTimeStamp);
}

void CIBTimeStamp::set(const ISC_TIMESTAMP& ibTimeStamp)
{
  // Thanks to Bill Karwin for the method of getting milliseconds to and from a 
  // time stamp
  isc_decode_timestamp((ISC_TIMESTAMP *)&ibTimeStamp, &tmstruct);
  msec = long(ibTimeStamp.timestamp_time % 10000);
}

void CIBTimeStamp::get(ISC_TIMESTAMP& ibTimeStamp) const
{
  validate();
  isc_encode_timestamp((tm*)&tmstruct, &ibTimeStamp);
  ibTimeStamp.timestamp_time -= long(ibTimeStamp.timestamp_time % 10000);
  ibTimeStamp.timestamp_time += msec;
}

ISC_TIMESTAMP* CIBTimeStamp::createNew() const
{
  ISC_TIMESTAMP* result = alloc_timestamp();
  get(*result);
  return result;
}


long CIBTimeStamp::getMsec() const
{
  return msec / 10;
}

void CIBTimeStamp::setMsec(long s)
{
  msec = s * 10;
}

long CIBTimeStamp::getYear() const
{
  return tmstruct.tm_year + 1900;
}

void CIBTimeStamp::zeroTime()
{
  tmstruct.tm_hour = 0;
  tmstruct.tm_min = 0;
  tmstruct.tm_sec = 0;
  setMsec(0);
}

void CIBTimeStamp::maxTime()
{
  tmstruct.tm_hour = 23;
  tmstruct.tm_min = 59;
  tmstruct.tm_sec = 59;
  msec = 9999;
}

inline void CIBTimeStamp::validate() const
{
  fud_check(msec >= 0 && msec <= 9999);
  fud_check(tmstruct.tm_sec >= 0 && tmstruct.tm_sec <= 59);
  fud_check(tmstruct.tm_min >= 0 && tmstruct.tm_min <= 59);
  fud_check(tmstruct.tm_hour >= 0 && tmstruct.tm_hour <= 23);
  fud_check(tmstruct.tm_mday >= 1 && tmstruct.tm_mday <= daysInMonth());
  fud_check(tmstruct.tm_mon >= 0 && tmstruct.tm_mon <= 12);
}

void CIBTimeStamp::normalise()
{
  //
  // Convert all values to their normal range
  //

  // Destroys day in year  numbers - which I don't need at the moment
  // In the future I will write a setDayInYear function 
  
  // Does not use the C runtime function for this because they
  // only go back to 1970


  tmstruct.tm_yday = -1; // As it would be wrong

  //
  // Millisec
  //
  int secAdjust = 0;

  while (msec < 0) {
    secAdjust--;
    msec+= 10000;
  }

  secAdjust += (msec / 10000);
  msec = msec % 10000;

  //
  // Sec
  //
  tmstruct.tm_sec += secAdjust;
  int minAdjust = 0;

  while (tmstruct.tm_sec < 0) {
    minAdjust--;
    tmstruct.tm_sec += 60;
  }
  
  minAdjust += (tmstruct.tm_sec / 60);
  tmstruct.tm_sec = tmstruct.tm_sec % 60;


  //
  // Min
  //
  tmstruct.tm_min += minAdjust;
  int hourAdjust = 0;

  while (tmstruct.tm_min < 0) {
    hourAdjust--;
    tmstruct.tm_min += 60;
  }
  
  hourAdjust += (tmstruct.tm_min / 60);
  tmstruct.tm_min = tmstruct.tm_min % 60;


  //
  // Hour
  //
  tmstruct.tm_hour += hourAdjust;
  int dayAdjust = 0;

  while (tmstruct.tm_hour < 0) {
    dayAdjust--;
    tmstruct.tm_hour += 24;
  }
  
  dayAdjust += (tmstruct.tm_hour / 24);
  tmstruct.tm_hour = tmstruct.tm_hour % 24;


  //
  // Day, month and year
  //

  tmstruct.tm_mday += dayAdjust;
  int year = tmstruct.tm_year + 1900;
  normaliseYearMonth(year, tmstruct.tm_mon);
  tmstruct.tm_year = year - 1900;

  for (;;) {

    if (tmstruct.tm_mday < 1) {
      
      // Go back a month
      tmstruct.tm_mon--;
      year = tmstruct.tm_year + 1900;
      normaliseYearMonth(year, tmstruct.tm_mon);
      tmstruct.tm_year = year - 1900;
      tmstruct.tm_mday += daysInMonth(tmstruct.tm_mon, getYear());

    } else if (tmstruct.tm_mday > daysInMonth()) {

      // Go forward a month

      tmstruct.tm_mday -= daysInMonth(tmstruct.tm_mon, getYear());
      tmstruct.tm_mon++;
      year = tmstruct.tm_year + 1900;
      normaliseYearMonth(year, tmstruct.tm_mon);
      tmstruct.tm_year = year - 1900;

    } else
      break;   
  }


  //
  // Postconditions
  //
  validate();
}


int CIBTimeStamp::daysInMonth() const
{
  return daysInMonth(tmstruct.tm_mon, getYear());
}

int CIBTimeStamp::daysInYear() const
{
  return daysInYear(getYear());
}

fud_bool operator>(const CIBTimeStamp & timeStamp1, const CIBTimeStamp&  timeStamp2)
{
  return 1 == compare(timeStamp1, timeStamp2);
}

fud_bool operator<(const CIBTimeStamp & timeStamp1, const CIBTimeStamp&  timeStamp2)
{
  return -1 == compare(timeStamp1, timeStamp2);
}


int compare(const CIBTimeStamp & timeStamp1, const CIBTimeStamp&  timeStamp2)
{
  // 1  ts1 > ts2
  // 0  ts1 == ts2
  // =1 ts1 < ts2

  // Note daysInYear might not be valid so do not use

  if (timeStamp1.tmstruct.tm_year > timeStamp2.tmstruct.tm_year)
    return 1;
  else if (timeStamp1.tmstruct.tm_year == timeStamp2.tmstruct.tm_year)  {

    if (timeStamp1.tmstruct.tm_mon > timeStamp2.tmstruct.tm_mon)
      return 1;
   
   else if (timeStamp1.tmstruct.tm_mon == timeStamp2.tmstruct.tm_mon) {

      if (timeStamp1.tmstruct.tm_mday > timeStamp2.tmstruct.tm_mday)
	return 1;
      
      else if (timeStamp1.tmstruct.tm_mday == timeStamp2.tmstruct.tm_mday) {
	
	if (timeStamp1.tmstruct.tm_hour > timeStamp2.tmstruct.tm_hour) 
	  return 1;

	else if (timeStamp1.tmstruct.tm_hour == timeStamp2.tmstruct.tm_hour) {

	  if (timeStamp1.tmstruct.tm_min > timeStamp2.tmstruct.tm_min) 
	    return 1;

	  else if (timeStamp1.tmstruct.tm_min == timeStamp2.tmstruct.tm_min) {

	    if (timeStamp1.tmstruct.tm_sec > timeStamp2.tmstruct.tm_sec) 
	      return 1;
	    else if (timeStamp1.tmstruct.tm_sec == timeStamp2.tmstruct.tm_sec) {
	      
	      if (timeStamp1.msec > timeStamp2.msec)
		return 1;
	      else if (timeStamp1.msec == timeStamp2.msec)
		return 0;
	    }
	  }	  
	}
      }
    }
  }

  return -1;
}

//----------------------------------------------------------------------------------------------------
// CIBTimeStamp - helpers
//----------------------------------------------------------------------------------------------------


ISC_TIMESTAMP * CIBTimeStamp::alloc_timestamp()
{
  return (ISC_TIMESTAMP*)ib_util_malloc(sizeof(ISC_TIMESTAMP)); 
}

/*static*/ fud_bool CIBTimeStamp::isLeap(int year)
{
  fud_precondition(year >= 1800 && year <= 2800);

  return ( (0 == year % 4) && ((0 != year % 100) || (0 == year % 400)) ) ? fud_true : fud_false;
}

/*static*/ int CIBTimeStamp::daysInYear(int year)
{
  fud_precondition(year >= 1800 && year <= 2800);

  return isLeap(year) ? 366 : 365;
}

/*static*/ int CIBTimeStamp::daysInMonth(int month, int year)
{
 // Month 0 Jan, 1 Feb, ...., 11 Dec

  fud_precondition(year >= 1800 && year <= 2800);
  fud_precondition(month >= 0 && month <= 11);

  const int days[12] = {
    31,	// Jan
    28,	// Feb
    31, // Mar
    30, // Apr
    31,	// May
    30, // June
    31, // July
    31, // Aug
    30, // Sep
    31, // Oct
    30, // Nov
    31  // Dec
  };
  
  if (1 != month)
    return days[month];

  // February is a special case
  return isLeap(year) ? 29 : 28;
}

/*static*/ void CIBTimeStamp::normaliseYearMonth(int& year, int& month)
{
  fud_precondition(year >= 1800 && year <= 2800);

  /*   char buffer[255];
   itoa(year,buffer,10);
    ::MessageBox(0, buffer, "year", MB_ICONEXCLAMATION | MB_OK);

  itoa(month,buffer,10);
    ::MessageBox(0, buffer, "month", MB_ICONEXCLAMATION | MB_OK);
  */

  // Bring year + month into normal range ... 
  // Month 0 Jan, 1 Feb, ...., 11 Dec

  while (month < 0) {
    year--;
    month +=12;
  }
  
  year += (month / 12);
  month = month % 12;

  fud_postcondition(month >= 0 && month <= 11);
}



//----------------------------------------------------------------------------------------------------
// Date + time functions
//----------------------------------------------------------------------------------------------------



extern "C" char * ISC_EXPORT fudlib_ttoc(ISC_TIMESTAMP* ibTimeStamp)
{
  CIBTimeStamp timeStamp(*ibTimeStamp);

  char * result = alloc_string(256);
  
  sprintf(
	  result, 
	  "Year %d Month %d Day %d  == Hours %d Mins %d  Secs %d  Millisecs %d Fractional mmsec %d",
	  timeStamp.tmstruct.tm_year,
	  timeStamp.tmstruct.tm_mon,
	  timeStamp.tmstruct.tm_mday,
	  timeStamp.tmstruct.tm_hour,
	  timeStamp.tmstruct.tm_min,
	  timeStamp.tmstruct.tm_sec,
	  timeStamp.getMsec(),
	  timeStamp.msec % 10
	  );

  return result;
}


extern "C" int ISC_EXPORT fudlib_mer_year(ISC_TIMESTAMP* ibTimeStamp)
{
  return CIBTimeStamp(*ibTimeStamp).getYear();
}

extern "C" int ISC_EXPORT fudlib_mer_month(ISC_TIMESTAMP* ibTimeStamp)
{
  return CIBTimeStamp(*ibTimeStamp).tmstruct.tm_mon + 1;
}

extern "C" char * ISC_EXPORT fudlib_month_of_year(ISC_TIMESTAMP* ibTimeStamp)
{
  char * 	result = alloc_string(256);
  CIBTimeStamp 	timeStamp(*ibTimeStamp);
  strftime(result, 256, "%B", &timeStamp.tmstruct);
  return result; 
}

extern "C" int ISC_EXPORT fudlib_mer_day(ISC_TIMESTAMP* ibTimeStamp)
{
  return CIBTimeStamp(*ibTimeStamp).tmstruct.tm_mday;
}

extern "C" int ISC_EXPORT fudlib_dow(ISC_TIMESTAMP* ibTimeStamp)
{
  return CIBTimeStamp(*ibTimeStamp).tmstruct.tm_wday + 1;
}

extern "C" char * ISC_EXPORT fudlib_day_of_week(ISC_TIMESTAMP* ibTimeStamp)
{
  char * 	result = alloc_string(256);
  CIBTimeStamp 	timeStamp(*ibTimeStamp);
  strftime(result, 256, "%A", &timeStamp.tmstruct);
  return result; 
}

extern "C" int ISC_EXPORT fudlib_julian(ISC_TIMESTAMP* ibTimeStamp)
{
  return CIBTimeStamp(*ibTimeStamp).tmstruct.tm_yday + 1;
}

extern "C" int ISC_EXPORT fudlib_mer_hour(ISC_TIMESTAMP* ibTimeStamp)
{
  return CIBTimeStamp(*ibTimeStamp).tmstruct.tm_hour;
}

extern "C" int ISC_EXPORT fudlib_mer_minute(ISC_TIMESTAMP* ibTimeStamp)
{
  return CIBTimeStamp(*ibTimeStamp).tmstruct.tm_min;
}

extern "C" int ISC_EXPORT fudlib_sec(ISC_TIMESTAMP* ibTimeStamp)
{
  return CIBTimeStamp(*ibTimeStamp).tmstruct.tm_sec;
}

extern "C" int ISC_EXPORT fudlib_msec(ISC_TIMESTAMP* ibTimeStamp)
{
  return CIBTimeStamp(*ibTimeStamp).getMsec();
}


extern "C" ISC_TIMESTAMP* ISC_EXPORT fudlib_maxtime(ISC_TIMESTAMP* ibTimeStamp)
{
  CIBTimeStamp timeStamp(*ibTimeStamp);
  timeStamp.maxTime();
  return timeStamp.createNew();
}

extern "C" ISC_TIMESTAMP* ISC_EXPORT fudlib_zerotime(ISC_TIMESTAMP* ibTimeStamp)
{
  CIBTimeStamp timeStamp(*ibTimeStamp);
  timeStamp.zeroTime();
  return timeStamp.createNew();
}

extern "C" ISC_TIMESTAMP* ISC_EXPORT fudlib_firstday(ISC_TIMESTAMP* ibTimeStamp)
{
  CIBTimeStamp timeStamp(*ibTimeStamp);
  timeStamp.zeroTime();
  timeStamp.tmstruct.tm_mday = 1;
  return timeStamp.createNew();
}


extern "C" ISC_TIMESTAMP* ISC_EXPORT fudlib_lastday(ISC_TIMESTAMP* ibTimeStamp)
{
  CIBTimeStamp timeStamp(*ibTimeStamp);
  timeStamp.maxTime();
  timeStamp.tmstruct.tm_mday = timeStamp.daysInMonth();
  return timeStamp.createNew();
}

extern "C" int ISC_EXPORT fudlib_week(ISC_TIMESTAMP* ibTimeStamp)
{
  int yday = CIBTimeStamp(*ibTimeStamp).tmstruct.tm_yday;
  
  fud_check(yday >= 0 && yday <= 365);

  return (yday / 7) + 1;
}


extern "C" char * ISC_EXPORT fudlib_quarter(ISC_TIMESTAMP* ibTimeStamp, int* fiscalYear)
{
  // fiscalYear - 1 starts jan , 2 feb etc
  // Return string like 96Q1 

  char * result = alloc_string(256);
  CIBTimeStamp timeStamp(*ibTimeStamp);

  if ((*fiscalYear) < 1 || (*fiscalYear) > 12)
    return strcpy(result, "Bad Par");
 
  // First year
  int yearEnd = (11 + (*fiscalYear - 1)) % 12;

  // If the month is larger than the year end then it falls into next year
  int bumpYear = (timeStamp.tmstruct.tm_mon > yearEnd) ? 1 : 0;

  int twoDigitYear = (timeStamp.tmstruct.tm_year + bumpYear) % 100;
  sprintf(result, "%02d", twoDigitYear);

  // Q
  result[2] = 'Q';

  int temp = (timeStamp.tmstruct.tm_mon + 12  - (*fiscalYear - 1)) % 12;
  // So temp = 0 for 1st month in fiscal year, 1 for 2nd month and so on

  temp = (temp / 3) + 1;
  // Convert temp from months to quarters and make it 1 based 

  sprintf(result + 3, "%d", temp); 

  fud_postcondition( 4 == strlen(result) );
  return result;
}


extern "C" ISC_TIMESTAMP* ISC_EXPORT 
fudlib_addtime(ISC_TIMESTAMP* ibTimeStamp, int* day, int* hour, int* min, int* sec, int* msec)
{
  fud_precondition(day);
  fud_precondition(hour);
  fud_precondition(min);
  fud_precondition(sec);
  fud_precondition(msec);

  CIBTimeStamp timestamp(*ibTimeStamp);
  timestamp.tmstruct.tm_mday += (*day);
  timestamp.tmstruct.tm_hour += (*hour);
  timestamp.tmstruct.tm_min += (*min);
  timestamp.tmstruct.tm_sec += (*sec);
  timestamp.setMsec(timestamp.getMsec() + (*msec));
  timestamp.normalise();
  return timestamp.createNew();
}

extern "C" ISC_TIMESTAMP* ISC_EXPORT 
fudlib_subtime(ISC_TIMESTAMP* ibTimeStamp, int *day, int *hour, int *min, int *sec, int *msec)
{
  fud_precondition(day);
  fud_precondition(hour);
  fud_precondition(min);
  fud_precondition(sec);
  fud_precondition(msec);

  CIBTimeStamp timestamp(*ibTimeStamp);
  timestamp.tmstruct.tm_mday -= (*day);
  timestamp.tmstruct.tm_hour -= (*hour);
  timestamp.tmstruct.tm_min -= (*min);
  timestamp.tmstruct.tm_sec -= (*sec);
  timestamp.setMsec(timestamp.getMsec() - (*msec));
  timestamp.normalise();
  return timestamp.createNew();
}

extern "C" ISC_TIMESTAMP* ISC_EXPORT 
fudlib_makedate(int* year, int* month, int* day, int* hour, int* min, int* sec)
{
  fud_precondition(year);
  fud_precondition(month);
  fud_precondition(day);
  fud_precondition(hour);
  fud_precondition(min);
  fud_precondition(sec);

  CIBTimeStamp timestamp;
  timestamp.tmstruct.tm_year = (*year) - 1900;
  timestamp.tmstruct.tm_mon = (*month) - 1;
  timestamp.tmstruct.tm_mday = *day;
  timestamp.tmstruct.tm_hour = *hour;
  timestamp.tmstruct.tm_min = *min;
  timestamp.tmstruct.tm_sec = *sec;

  timestamp.normalise();
  return timestamp.createNew();
}

/*
static void adjustDayInYear(int& dayInYear, int oldYear, int newYear)
{
  fud_precondition(oldYear >= 1800 && oldYear <= 2800);
  fud_precondition(newYear >= 1800 && newYear <= 2800);
  fud_precondition(dayInYear >= 0 && dayInYear <= 364);

  const int normalLastDayFeb = 57;

  if (dayInYear >= normalLastDayFeb) {
    
    if (CIBTimeStamp::isLeap(oldYear) && !CIBTimeStamp::isLeap(newYear))
      // Going from leap year to non-leap year
      dayInYear--;
    else if (!CIBTimeStamp::isLeap(oldYear) && CIBTimeStamp::isLeap(newYear))
      // Going from non-leap year to leap year
      dayInYear++;
  }   
}*/

extern "C" int ISC_EXPORT fudlib_diffdate(ISC_TIMESTAMP* ibTimeStamp1, ISC_TIMESTAMP* ibTimeStamp2, int* control)
{
  // +ve if ts1 > ts2.

  // control is
  // 4 days
  // 3 hours
  // 2 minutes
  // 1 seconds
  // 0 millseconds


  // Note the UDFLib function will happily let the return value overflow as indicated
  // in the help.  We don't.

  if ((*control) < 0 || (*control) > 4)
    return intNaN;   

  CIBTimeStamp timestamp1(*ibTimeStamp1);
  CIBTimeStamp timestamp2(*ibTimeStamp2);

  int result = 0;

  //
  // Calculate difference in days
  //

  int dayInYear1 = timestamp1.tmstruct.tm_yday;
  int dayInYear2 = timestamp2.tmstruct.tm_yday;

  // Bring timestamp2 year into line with timestamp1
  while (timestamp2.tmstruct.tm_year < timestamp1.tmstruct.tm_year) {    
    result += timestamp2.daysInYear();
    timestamp2.tmstruct.tm_year++;
  } 

  while (timestamp2.tmstruct.tm_year > timestamp1.tmstruct.tm_year) {    
    timestamp2.tmstruct.tm_year--;
    result -= timestamp2.daysInYear();
  } 

  result += dayInYear1 - dayInYear2;

  /*  char buffer[255];
  itoa(dayInYear1,buffer,10);
  ::MessageBox(0, buffer, "dayInYear1", MB_ICONEXCLAMATION | MB_OK);
  */

  if (4 == (*control)) {
    
    // Answers in days 
    if (timestamp2 > timestamp1 && result > 1)
      result--;
    else if (timestamp2 < timestamp1 && result < -1)
      result++;

  } else {

    // Switch to hours 
    int diffHours = timestamp1.tmstruct.tm_hour - timestamp2.tmstruct.tm_hour;    
    timestamp2.tmstruct.tm_hour = timestamp1.tmstruct.tm_hour;

    if ((double(result) * 24.0 + diffHours) > double(INT_MAX))
      return intNaN;

    result = (result * 24) + diffHours;

    if (3 == (*control)) {

     // Answers in hours 
     if (timestamp2 > timestamp1 && result >1)
       result--;
     else if (timestamp2 < timestamp1 && result < -1)
       result++;
 
    } else {

      // Switch to minutes
      int diffMins = timestamp1.tmstruct.tm_min - timestamp2.tmstruct.tm_min;    
      timestamp2.tmstruct.tm_min = timestamp1.tmstruct.tm_min;

      if ((double(result) * 60.0 + diffMins) > double(INT_MAX))
	return intNaN;

      result = (result * 60) + diffMins;


      if (2 == (*control)) {

	// Answers in mins
	if (timestamp2 > timestamp1 && result >1)
	  result--;
	else if (timestamp2 < timestamp1 && result < -1)
         result++;

      } else {

	// Switch to seconds
	int diffSecs = timestamp1.tmstruct.tm_sec - timestamp2.tmstruct.tm_sec;    
	timestamp2.tmstruct.tm_sec = timestamp1.tmstruct.tm_sec;

	if ((double(result) * 60.0 + diffSecs) > double(INT_MAX))
	  return intNaN;

	result = result * 60 + diffSecs;

	if (1 == (*control)) {

	  // Answers in secs
	  if (timestamp2 > timestamp1 && result >1)
	    result--;
	  else if (timestamp2 < timestamp1 && result < -1)
	    result++;

	} else {

	  // Answer in milliseconds
	  int diffMSecs = timestamp1.getMsec() - timestamp2.getMsec();    

	  if ((double(result) * 1000.0 + diffMSecs) > double(INT_MAX))
	    return intNaN;
	  
	  result = result * 1000 + diffMSecs;
	}
      }
    }
  }

  if (result < 0)
    result = 0 - result;


  fud_postcondition(result >= 0 || intNaN == result);

  return result;
} 



 
