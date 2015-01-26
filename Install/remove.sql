/*

	remove.sql Removes functions into the database
	Copyright (C) 2000 Rachel Bowyer.

	Author: Rachel Bowyer (rachbowyer@gmail.com)

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation version 2.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

   	You should have received a copy of the GNU General Public License
   	along with this program; if not, write to the Free Software
   	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/




/* Abs functions */
drop external function absdbl;
drop external function absflt;
drop external function absint;
drop external function abssml;


/* Min functions */
drop external function mindbl;
drop external function minflt;
drop external function minint;
drop external function minsml;

/* Max functions */
drop external function maxdbl;
drop external function maxflt;
drop external function maxint;
drop external function maxsml;


/* Trig and numeric functions */
drop external function fud_cos;
drop external function fud_acos;
drop external function fud_sin;
drop external function fud_asin;
drop external function fud_tan;
drop external function fud_atan;
drop external function fud_atan2;
drop external function ceiling;
drop external function fud_floor;
drop external function degrees;
drop external function radians;
drop external function exp;
drop external function fact;
drop external function fud_PI;
drop external function fud_log;
drop external function fud_log10;
drop external function pow;
drop external function pow10;
drop external function round;
drop external function truncate;
drop external function fud_truncate;
drop external function fud_sqrt;
drop external function modquot;
drop external function modrem;

/* Version functions */
drop external function ver;
drop external function fud_ver;

/* Trim  functions */
drop external function alltrim;
drop external function valltrim;
drop external function alltrimc;
drop external function valltrimc;
drop external function vltrim;
drop external function ltrimc;
drop external function vltrimc;
drop external function vrtrim;
drop external function rtrimc;
drop external function vrtrimc;


/* Soundex */
drop external function fud_soundex;


/* Pad  functions */
drop external function pad;
drop external function vpad;
drop external function lpad;
drop external function vlpad;
drop external function centre;
drop external function vcentre;
drop external function center;
drop external function vcenter;


/* Misc string functions*/
drop external function len;
drop external function vlen;
drop external function fud_lower;
drop external function vlower;
drop external function cstradd;
drop external function vcharadd;
drop external function cstrdel;
drop external function vchardel;
drop external function cstr_plus_int;
drop external function int_plus_cstr;
drop external function cstr_to_dbl;
drop external function ascii;
drop external function chr;
drop external function parse;
drop external function vparse;
drop external function pos;
drop external function vpos;
drop external function proper;
drop external function vproper;
drop external function reverse;
drop external function vreverse;
drop external function lefts;
drop external function vlefts;
drop external function rights;
drop external function vrights;
drop external function substring;
drop external function vsubstring;
drop external function replicate;
drop external function vreplicate;


/* Date functions*/
drop external function fud_ttoc;
drop external function mer_year;
drop external function mer_month;
drop external function month_of_year;
drop external function mer_day;
drop external function day_of_week;
drop external function dow;
drop external function julian;
drop external function mer_hour;
drop external function mer_minute;
drop external function sec;
drop external function msec;
drop external function maxtime;
drop external function zerotime;
drop external function firstday;
drop external function lastday;
drop external function week;
drop external function quarter;
drop external function add_time;
drop external function sub_time;
drop external function makedate;
drop external function diffdate;









