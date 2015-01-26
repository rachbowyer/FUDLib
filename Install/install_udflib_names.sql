/*
	install_udflib_names.sql - Installs UFDLib names
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



declare external function cos double precision  returns double precision by value
	entry_point  'fudlib_cos' module_name 'fudlib';

declare external function acos double precision  returns double precision by value
	entry_point  'fudlib_acos' module_name 'fudlib';

declare external function sin double precision  returns double precision by value
	entry_point  'fudlib_sin' module_name 'fudlib';

declare external function asin double precision  returns double precision by value
	entry_point  'fudlib_asin' module_name 'fudlib';

declare external function tan double precision  returns double precision by value
	entry_point  'fudlib_tan' module_name 'fudlib';

declare external function atan double precision  returns double precision by value
	entry_point  'fudlib_atan' module_name 'fudlib';

declare external function atan2 double precision, double precision  returns double precision by value
	entry_point  'fudlib_atan2' module_name 'fudlib';

declare external function floor double precision returns double precision by value
	entry_point  'fudlib_floor' module_name 'fudlib';

declare external function log double precision  returns double precision by value
	entry_point  'fudlib_log' module_name 'fudlib';

declare external function log10 double precision returns double precision by value
	entry_point  'fudlib_log10' module_name 'fudlib';

declare external function sqrt double precision returns double precision by value
	entry_point  'fudlib_sqrt' module_name 'fudlib';

declare external function PI returns double precision by value
	entry_point  'fudlib_PI' module_name 'fudlib';

declare external function ltrim cstring(256) returns cstring(256) free_it 
	entry_point  'fudlib_ltrim' module_name 'fudlib';

declare external function rtrim cstring(256) returns cstring(256) free_it 
	entry_point  'fudlib_rtrim' module_name 'fudlib';

declare external function lower cstring(256) returns cstring(256)
	entry_point  'fudlib_lower' module_name 'fudlib';
