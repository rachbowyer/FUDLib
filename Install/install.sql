/*
	install.sql Installs functions into the database
	Copyright (C) 2000 Rachel Bowyer.

	Author: Rachel Bowyer (rachbowyer@gmail.com)


	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License version 2 as published by
	the Free Software Foundation.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

   	You should have received a copy of the GNU General Public License
   	along with this program; if not, write to the Free Software
   	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/



/* Abs functions */

declare external function absdbl double precision returns double precision by value
	entry_point  'fudlib_absdbl' module_name 'fudlib';

declare external function absflt float returns float by value
	entry_point  'fudlib_absflt' module_name 'fudlib';

declare external function absint integer returns integer by value
	entry_point  'fudlib_absint' module_name 'fudlib';

declare external function abssml smallint returns smallint by value
	entry_point  'fudlib_abssml' module_name 'fudlib';



/* Min functions */

declare external function mindbl double precision, double precision returns double precision by value
	entry_point  'fudlib_mindbl' module_name 'fudlib';

declare external function minflt float, float returns float by value
	entry_point  'fudlib_minflt' module_name 'fudlib';

declare external function minint integer, integer  returns integer by value
	entry_point  'fudlib_minint' module_name 'fudlib';

declare external function minsml smallint, smallint  returns smallint by value
	entry_point  'fudlib_minsml' module_name 'fudlib';



/* Max functions */


declare external function maxdbl double precision, double precision  returns double precision by value
	entry_point  'fudlib_maxdbl' module_name 'fudlib';

declare external function maxflt float, float returns float by value
	entry_point  'fudlib_maxflt' module_name 'fudlib';

declare external function maxint integer, integer returns integer by value
	entry_point  'fudlib_maxint' module_name 'fudlib';

declare external function maxsml smallint, smallint returns smallint by value
	entry_point  'fudlib_maxsml' module_name 'fudlib';




/* Trig and numeric functions */

declare external function fud_cos double precision  returns double precision by value
	entry_point  'fudlib_cos' module_name 'fudlib';

declare external function fud_acos double precision  returns double precision by value
	entry_point  'fudlib_acos' module_name 'fudlib';

declare external function fud_sin double precision  returns double precision by value
	entry_point  'fudlib_sin' module_name 'fudlib';

declare external function fud_asin double precision  returns double precision by value
	entry_point  'fudlib_asin' module_name 'fudlib';

declare external function fud_tan double precision  returns double precision by value
	entry_point  'fudlib_tan' module_name 'fudlib';

declare external function fud_atan double precision  returns double precision by value
	entry_point  'fudlib_atan' module_name 'fudlib';

declare external function fud_atan2 double precision, double precision  returns double precision by value
	entry_point  'fudlib_atan2' module_name 'fudlib';

declare external function ceiling double precision returns double precision by value
	entry_point  'fudlib_ceiling' module_name 'fudlib';

declare external function fud_floor double precision returns double precision by value
	entry_point  'fudlib_floor' module_name 'fudlib';

declare external function degrees double precision returns double precision by value
	entry_point  'fudlib_degrees' module_name 'fudlib';

declare external function radians double precision returns double precision by value
	entry_point  'fudlib_radians' module_name 'fudlib';

declare external function exp double precision returns double precision by value
	entry_point  'fudlib_exp' module_name 'fudlib';

declare external function fact double precision returns double precision by value
	entry_point  'fudlib_fact' module_name 'fudlib';

declare external function fud_PI returns double precision by value
	entry_point  'fudlib_PI' module_name 'fudlib';

declare external function fud_log double precision  returns double precision by value
	entry_point  'fudlib_log' module_name 'fudlib';

declare external function fud_log10 double precision returns double precision by value
	entry_point  'fudlib_log10' module_name 'fudlib';

declare external function pow double precision, double precision returns double precision by value
	entry_point  'fudlib_pow' module_name 'fudlib';

declare external function pow10 double precision returns double precision by value
	entry_point  'fudlib_pow10' module_name 'fudlib';

declare external function round double precision, integer returns double precision by value
	entry_point  'fudlib_round' module_name 'fudlib';

declare external function truncate double precision, integer returns double precision by value
	entry_point  'fudlib_udftruncate' module_name 'fudlib';

declare external function fud_truncate double precision, integer returns double precision by value
	entry_point  'fudlib_truncate' module_name 'fudlib';

declare external function fud_sqrt double precision returns double precision by value
	entry_point  'fudlib_sqrt' module_name 'fudlib';

declare external function modquot integer, integer returns integer by value
	entry_point  'fudlib_modquot' module_name 'fudlib';

declare external function modrem integer, integer returns integer by value
	entry_point  'fudlib_modrem' module_name 'fudlib';




/* Version functions */

declare external function ver returns double precision by value
	entry_point  'fudlib_ver' module_name 'fudlib';

declare external function fud_ver returns integer by value
	entry_point  'fudlib_fud_ver' module_name 'fudlib';




/* Trim  functions */


/* all trim */
declare external function alltrim cstring(256) returns cstring(256) free_it 
	entry_point  'fudlib_alltrim' module_name 'fudlib';

declare external function valltrim cstring(256) returns cstring(256) free_it 
	entry_point  'fudlib_alltrim' module_name 'fudlib';

declare external function alltrimc cstring(256), char(1) returns cstring(256) free_it 
	entry_point  'fudlib_alltrimc' module_name 'fudlib';

declare external function valltrimc cstring(256), cstring(1) returns cstring(256) free_it 
	entry_point  'fudlib_alltrimc' module_name 'fudlib';

/*left trim*/
declare external function vltrim cstring(256) returns cstring(256) free_it 
	entry_point  'fudlib_ltrim' module_name 'fudlib';

declare external function ltrimc cstring(256), char(1) returns cstring(256) free_it 
	entry_point  'fudlib_ltrimc' module_name 'fudlib';

declare external function vltrimc cstring(256), cstring(1) returns cstring(256) free_it 
	entry_point  'fudlib_ltrimc' module_name 'fudlib';


/*right trim*/
declare external function vrtrim cstring(256) returns cstring(256) free_it 
	entry_point  'fudlib_rtrim' module_name 'fudlib';

declare external function rtrimc cstring(256), char(1) returns cstring(256) free_it 
	entry_point  'fudlib_rtrimc' module_name 'fudlib';

declare external function vrtrimc cstring(256), cstring(1) returns cstring(256) free_it 
	entry_point  'fudlib_rtrimc' module_name 'fudlib';


/* Soundex */
declare external function fud_soundex cstring(256) returns cstring(256) free_it 
	entry_point  'fudlib_soundex' module_name 'fudlib';


/* Pad  functions */

declare external function pad cstring(256), cstring(1), integer  returns cstring(256) free_it 
	entry_point  'fudlib_pad' module_name 'fudlib';

declare external function vpad cstring(256), cstring(1), integer  returns cstring(256) free_it 
	entry_point  'fudlib_pad' module_name 'fudlib';

declare external function lpad cstring(256), cstring(1), integer  returns cstring(256) free_it 
	entry_point  'fudlib_lpad' module_name 'fudlib';

declare external function vlpad cstring(256), cstring(1), integer  returns cstring(256) free_it 
	entry_point  'fudlib_lpad' module_name 'fudlib';

declare external function centre cstring(256), cstring(1), integer  returns cstring(256) free_it 
	entry_point  'fudlib_centre' module_name 'fudlib';

declare external function vcentre cstring(256), cstring(1), integer  returns cstring(256) free_it 
	entry_point  'fudlib_centre' module_name 'fudlib';

declare external function center cstring(256), cstring(1), integer  returns cstring(256) free_it 
	entry_point  'fudlib_centre' module_name 'fudlib';

declare external function vcenter cstring(256), cstring(1), integer  returns cstring(256) free_it 
	entry_point  'fudlib_centre' module_name 'fudlib';


/* Misc string functions*/

declare external function len cstring(256) returns integer by value
	entry_point  'fudlib_len' module_name 'fudlib';

declare external function vlen cstring(256) returns integer by value
	entry_point  'fudlib_len' module_name 'fudlib';

declare external function fud_lower cstring(256) returns cstring(256)
	entry_point  'fudlib_lower' module_name 'fudlib';

declare external function vlower cstring(256) returns cstring(256)
	entry_point  'fudlib_lower' module_name 'fudlib';

declare external function cstradd cstring(256),cstring(256) returns cstring(512) free_it
	entry_point  'fudlib_stradd' module_name 'fudlib';

declare external function vcharadd cstring(256),cstring(256) returns cstring(512) free_it
	entry_point  'fudlib_stradd' module_name 'fudlib';

declare external function cstrdel cstring(256), integer, integer returns cstring(256) free_it
	entry_point  'fudlib_strdel' module_name 'fudlib';

declare external function vchardel cstring(256), integer, integer returns cstring(256) free_it
	entry_point  'fudlib_strdel' module_name 'fudlib';

declare external function cstr_plus_int cstring(256), integer  returns cstring(256) free_it
	entry_point  'fudlib_cstr_plus_int' module_name 'fudlib';

declare external function int_plus_cstr cstring(256), integer  returns cstring(256) free_it
	entry_point  'fudlib_int_plus_cstr' module_name 'fudlib';

declare external function cstr_to_dbl cstring(256)  returns double precision by value
	entry_point  'fudlib_cstr_to_dbl' module_name 'fudlib';

declare external function ascii cstring(1)  returns integer by value
	entry_point  'fudlib_ascii' module_name 'fudlib';

declare external function chr integer returns cstring(1) free_it 
	entry_point  'fudlib_chr' module_name 'fudlib';

declare external function parse cstring(256), cstring(1), integer returns cstring(256) free_it 
	entry_point  'fudlib_parse' module_name 'fudlib';

declare external function vparse cstring(256), cstring(1), integer returns cstring(256) free_it 
	entry_point  'fudlib_parse' module_name 'fudlib';

declare external function pos cstring(256), cstring(256), integer, integer returns integer by value 
	entry_point  'fudlib_pos' module_name 'fudlib';

declare external function vpos cstring(256), cstring(256), integer, integer returns integer by value 
	entry_point  'fudlib_pos' module_name 'fudlib';

declare external function proper cstring(256) returns cstring(256) free_it 
	entry_point  'fudlib_proper' module_name 'fudlib';

declare external function vproper cstring(256) returns cstring(256) free_it 
	entry_point  'fudlib_proper' module_name 'fudlib';

declare external function reverse cstring(256) returns cstring(256) free_it 
	entry_point  'fudlib_reverse' module_name 'fudlib';

declare external function vreverse cstring(256) returns cstring(256) free_it 
	entry_point  'fudlib_reverse' module_name 'fudlib';

declare external function lefts cstring(256), integer returns cstring(256) free_it 
	entry_point  'fudlib_lefts' module_name 'fudlib';

declare external function vlefts cstring(256), integer returns cstring(256) free_it 
	entry_point  'fudlib_lefts' module_name 'fudlib';

declare external function rights cstring(256), integer returns cstring(256) free_it 
	entry_point  'fudlib_rights' module_name 'fudlib';

declare external function vrights cstring(256), integer returns cstring(256) free_it 
	entry_point  'fudlib_rights' module_name 'fudlib';

declare external function substring cstring(256), integer, integer returns cstring(256) free_it 
	entry_point  'fudlib_substr' module_name 'fudlib';

declare external function vsubstring cstring(256), integer, integer returns cstring(256) free_it 
	entry_point  'fudlib_substr' module_name 'fudlib';

declare external function replicate cstring(1), integer returns cstring(256) free_it 
	entry_point  'fudlib_replicate' module_name 'fudlib';

declare external function vreplicate cstring(1), integer returns cstring(256) free_it 
	entry_point  'fudlib_replicate' module_name 'fudlib';




/* Date functions*/

declare external function fud_ttoc timestamp returns cstring(255) free_it
	entry_point  'fudlib_ttoc' module_name 'fudlib';

declare external function mer_year timestamp returns integer by value
	entry_point  'fudlib_mer_year' module_name 'fudlib';

declare external function mer_month timestamp returns integer by value
	entry_point  'fudlib_mer_month' module_name 'fudlib';

declare external function month_of_year timestamp returns cstring(255) free_it
	entry_point  'fudlib_month_of_year' module_name 'fudlib';

declare external function mer_day timestamp returns integer by value
	entry_point  'fudlib_mer_day' module_name 'fudlib';

declare external function day_of_week timestamp returns cstring(255) free_it
	entry_point  'fudlib_day_of_week' module_name 'fudlib';

declare external function dow timestamp returns integer by value
	entry_point  'fudlib_dow' module_name 'fudlib';

declare external function julian timestamp returns integer by value
	entry_point  'fudlib_julian' module_name 'fudlib';

declare external function mer_hour timestamp returns integer by value
	entry_point  'fudlib_mer_hour' module_name 'fudlib';

declare external function mer_minute timestamp returns integer by value
	entry_point  'fudlib_mer_minute' module_name 'fudlib';

declare external function sec timestamp returns integer by value
	entry_point  'fudlib_sec' module_name 'fudlib';

declare external function msec timestamp returns integer by value
	entry_point  'fudlib_msec' module_name 'fudlib';

declare external function maxtime timestamp returns timestamp free_it
	entry_point  'fudlib_maxtime' module_name 'fudlib';

declare external function zerotime timestamp returns timestamp free_it
	entry_point  'fudlib_zerotime' module_name 'fudlib';

declare external function firstday timestamp returns timestamp free_it
	entry_point  'fudlib_firstday' module_name 'fudlib';

declare external function lastday timestamp returns timestamp free_it
	entry_point  'fudlib_lastday' module_name 'fudlib';

declare external function week timestamp returns int by value
	entry_point  'fudlib_week' module_name 'fudlib';

declare external function quarter timestamp, integer  returns cstring(255) free_it
	entry_point  'fudlib_quarter' module_name 'fudlib';

declare external function add_time timestamp, integer, integer, integer, integer, integer returns timestamp free_it
	entry_point  'fudlib_addtime' module_name 'fudlib';

declare external function sub_time timestamp, integer, integer, integer, integer, integer returns timestamp free_it
	entry_point  'fudlib_subtime' module_name 'fudlib';

declare external function makedate integer, integer, integer, integer, integer, integer returns timestamp free_it
	entry_point  'fudlib_makedate' module_name 'fudlib';

declare external function diffdate timestamp, timestamp, integer returns integer by value
	entry_point  'fudlib_diffdate' module_name 'fudlib';





