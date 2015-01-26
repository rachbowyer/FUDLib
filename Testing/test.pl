#!/usr/bin/perl -w
#
#	test.pl - Tests FUDLibrary
#	Copyright (C) 2000 Rachel Bowyer.
#
#	Author: Rachel Bowyer (rachbowyer@gmail.com)
#
#	This program is free software; you can redistribute it and/or modify
#	it under the terms of the GNU General Public License version 2 as published by
#	the Free Software Foundation.
#
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#   	You should have received a copy of the GNU General Public License
#   	along with this program; if not, write to the Free Software
#   	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#


use strict;
use IBPerl;


sub compareDbls
{
    my($first, $second, $precision) = @_;
    
#    print $first - $second, "\n";
#    print $first * $precision, "\n";

    return abs($first - $second) <= abs($first * $precision);
}

sub executeSQL
{
    my ($tr, $sql) = @_;
    my ($st, $ret);
    

    $st = new IBPerl::Statement(Transaction=>$tr, SQL=>$sql);
    ($st->{Handle} >= 0) || die "Failed to execute sql: $sql:  $st->{Error}\n";
    ($st->execute() == 0) || die "Failed to execute sql: $sql:  $st->{Error}\n";
}


sub executeSQL2
{
    my ($tr, $sql) = @_;
    my ($st, $result, %row);
    

    $st = new IBPerl::Statement(Transaction=>$tr, SQL=>$sql);
    ($st->{Handle} >= 0) || die "Failed to execute sql: $sql:  $st->{Error}\n";
    ($st->execute() == 0) || die "Failed to execute sql: $sql:  $st->{Error}\n";

    # Fetch result

    (0 == $st->fetch(\%row)) || die "Failed to fetch row: $st->{Error}\n";

    for my $k (keys %row) {
	$result = $row{$k};
	last;
    }
    
    # Trim trailing white space
    $result =~ s/ *$//;

    print "$result" . "\n";

    return $result;
}



sub executeFn
{
    my ($tr, $fnName, @args)= @_;
    my ($st, $sql, $argList, $arg, %row, $result);

    $argList = "";
    foreach $arg (@args) {
	$argList = $argList . ", " if (not  "" eq $argList);
	$argList = $argList . $arg;
    }
    $sql = "select $fnName($argList) from dual";

    # Execute statement
    print "Sql: $sql :";
    $st = new IBPerl::Statement(Transaction=>$tr, SQL=>$sql);
    ($st->{Handle} >= 0) || die "Failed to prepare sql: $st->{Error}\n";
    ($st->execute() == 0) || die "Failed to execute sql: $st->{Error}\n";

    # Fetch result
    (0 == $st->fetch(\%row)) || die "Failed to fetch row: $st->{Error}\n";

    $result = $row{uc($fnName)};
    
    # Trim trailing white space
    $result =~ s/ *$//;

    print "$result" . "\n";

    return $result;
}

sub importSql
{
    my ($tr, $fileName) = @_;
    my ($sqlFile, $sql);

    open (IMPFILE, $fileName) || die "Can not open file $fileName\n";
    
    # Read whole file into sql - should be quite small
    while (<IMPFILE>) {
	chomp $_;
	$sqlFile = $sqlFile . $_;
    }

    # Strip out comments - the ? stops it treating 2 comments as one large comment
   $sqlFile =~ s#/\*.*?\*/##g;

    while ($sqlFile =~ /;/) {	
	$sql = $`;
	#print "Execute $sql\n";
	executeSQL($tr, $sql);

	$sqlFile = $'; 
    } 
}


sub createDual
{
    my ($db) = @_;
    my($tr);

    $tr = new IBPerl::Transaction(Database=>$db);
    ($tr->{Handle} >= 0) || die "$0: $db->{Error}\n";    
    executeSQL($tr, "create table dual(dummy char(1))");
    $tr->commit;
 
    $tr = new IBPerl::Transaction(Database=>$db);
    ($tr->{Handle} >= 0) || die "$0: $db->{Error}\n";    
    executeSQL($tr, "insert into dual(dummy) values('1')");
    $tr->commit;
}

sub testAbs
{
    my ($tr) = @_; 
    
    print "Testing abs fucntions\n";
    compareDbls(1.2324, executeFn($tr, "absdbl", ("-1.2324")), 1e-14) || die "Failed on absdbl\n";
    compareDbls(0, executeFn($tr, "absdbl", ("0")), 1e-14) || die "Failed on absdbl\n";
    compareDbls(3112321, executeFn($tr, "absdbl", ("3112321")), 1e-14) || die "Failed on absdbl\n";

    compareDbls(3.1, executeFn($tr, "absflt", ("-3.1")), 1e-7) || die "Failed on absflt\n";
    compareDbls(0, executeFn($tr, "absflt", ("0")), 1e-7) || die "Failed on absflt\n";
    compareDbls(123123.21323, executeFn($tr, "absflt", ("123123.21323")), 1e-7) || die "Failed on absflt\n";

    (12121 == executeFn($tr, "absint", ("-12121"))) || die "Failed on absint\n";
    (0  == executeFn($tr, "absint", ("0"))) || die "Failed on absint\n";
    (2147483640  == executeFn($tr, "absint", ("2147483640"))) || die "Failed on absint\n";

    (12121 == executeFn($tr, "abssml", ("-12121"))) || die "Failed on abssml\n";
    (0  == executeFn($tr, "abssml", ("0"))) || die "Failed on abssml\n";
    (32767  == executeFn($tr, "abssml", ("32767"))) || die "Failed on abssml\n"; 
}

sub testMaxMin
{
    my ($tr) = @_; 

    compareDbls(33.33, executeFn($tr, "maxdbl", ("33.33", "11.2")),1e-14 ) || die "Failed on maxdbl\n"; 
    compareDbls(-11.2, executeFn($tr, "maxdbl", ("-33.33", "-11.2")),1e-14) || die "Failed on maxdbl\n"; 
    compareDbls(33.33, executeFn($tr, "maxdbl", ("33.33", "-11.2")),1e-14) || die "Failed on maxdbl\n"; 

    compareDbls(33.33, executeFn($tr, "maxflt", ("33.33", "11.2")),1e-7 ) || die "Failed on maxftl\n"; 
    compareDbls(-11.2, executeFn($tr, "maxflt", ("-33.33", "-11.2")),1e-7) || die "Failed on maxflt\n"; 
    compareDbls(33.33, executeFn($tr, "maxflt", ("33.33", "-11.2")),1e-7) || die "Failed on maxflt\n"; 

    (2147483640 ==  executeFn($tr, "maxint", ("2147483640", "11"))) || die "Failed on maxint\n"; 
    (-11 ==  executeFn($tr, "maxint", ("-2147483640", "-11"))) || die "Failed on maxint\n"; 
    (2147483640 == executeFn($tr, "maxint", ("2147483640", "-11"))) || die "Failed on maxint\n"; 

    (32767 ==  executeFn($tr, "maxsml", ("32767", "11"))) || die "Failed on maxsml\n"; 
    (-11 ==  executeFn($tr, "maxsml", ("-32767", "-11"))) || die "Failed on maxsml\n"; 
    (32767 == executeFn($tr, "maxsml", ("32767", "-11"))) || die "Failed on maxsml\n"; 
}


sub testNumeric
{
    my ($tr) = @_; 
    my ($pi);

    $pi = atan2(1,1) * 4;

    compareDbls(0.5, executeFn($tr, "cos", ("$pi/3.0")), 1e-14 ) || die "Failed on cos\n"; 
    compareDbls($pi/3, executeFn($tr, "acos", ("0.5")), 1e-14 ) || die "Failed on acos\n"; 
    compareDbls(-999999, executeFn($tr, "acos", ("1.1")), 1e-14 ) || die "Failed on acos\n"; 
    compareDbls(-999999, executeFn($tr, "acos", ("-1.1")), 1e-14 ) || die "Failed on acos\n"; 

    compareDbls(0.5, executeFn($tr, "sin", ("$pi/6.0")), 1e-14 ) || die "Failed on sin\n"; 
    compareDbls($pi/6, executeFn($tr, "asin", ("0.5")), 1e-14 ) || die "Failed on asin\n"; 

    compareDbls(1.0, executeFn($tr, "tan", ("$pi/4.0")), 1e-14 ) || die "Failed on tan\n"; 
    compareDbls($pi/4, executeFn($tr, "atan", ("1")), 1e-14 ) || die "Failed on atan\n"; 
    compareDbls($pi/4, executeFn($tr, "atan2", ("-4,-4")), 1e-14 ) || die "Failed on atan\n"; 
    compareDbls(-999999, executeFn($tr, "atan2", ("-0, 0")), 1e-14 ) || die "Failed on atan\n";

    compareDbls(2.0, executeFn($tr, "ceiling", ("1.23")), 1e-14 ) || die "Failed on ceiling\n";  
    compareDbls(-1, executeFn($tr, "ceiling", ("-1.23")), 1e-14 ) || die "Failed on ceiling\n";  
    compareDbls(-11.0, executeFn($tr, "ceiling", ("-11.23")), 1e-14 ) || die "Failed on ceiling\n";  
    compareDbls(0, executeFn($tr, "ceiling", ("0")), 1e-14 ) || die "Failed on ceiling\n";  

    compareDbls(1.0, executeFn($tr, "floor", ("1.23")), 1e-14 ) || die "Failed on floor\n";  
    compareDbls(-2.0, executeFn($tr, "floor", ("-1.23")), 1e-14 ) || die "Failed on floor\n";  
    compareDbls(-12.0, executeFn($tr, "floor", ("-11.23")), 1e-14 ) || die "Failed on floor\n";  
    compareDbls(0, executeFn($tr, "floor", ("0")), 1e-14 ) || die "Failed on floor\n";  

    compareDbls(180.0, executeFn($tr, "degrees", ("$pi")), 1e-14 ) || die "Failed on degrees\n";  
    compareDbls(0, executeFn($tr, "degrees", ("0")), 1e-14 ) || die "Failed on degrees\n";  

    compareDbls($pi, executeFn($tr, "radians", ("180")), 1e-14 ) || die "Failed on radians\n";  
    compareDbls(0, executeFn($tr, "radians", ("0")), 1e-14 ) || die "Failed on radians\n";  

    compareDbls($pi, executeFn($tr, "pi", ()), 1e-14 ) || die "Failed on pi\n";  

    compareDbls(3628800, executeFn($tr, "fact", ("10")), 1e-14 ) || die "Failed on factorial\n";  
    compareDbls(6, executeFn($tr, "fact", ("3.9")), 1e-14 ) || die "Failed on factorial\n";  
    compareDbls(-999999, executeFn($tr, "fact", ("0")), 1e-14 ) || die "Failed on factorial\n";  

    compareDbls(0.1826835240527347, executeFn($tr, "exp", ("-1.7")), 1e-14 ) || die "Failed on exp\n";  
    compareDbls(-999999, executeFn($tr, "exp", ("701")), 1e-14 ) || die "Failed on exp\n";  
    compareDbls(-999999, executeFn($tr, "exp", ("-701")), 1e-14 ) || die "Failed on exp\n";  

    compareDbls(0.7884573603642703, executeFn($tr, "log", ("2.2")), 1e-14 ) || die "Failed on log\n";  
    compareDbls(-999999, executeFn($tr, "log", ("0.9e-304")), 1e-14 ) || die "Failed on log\n";  
    compareDbls(-999999, executeFn($tr, "log", ("-1")), 1e-14 ) || die "Failed on log\n";  

    compareDbls(1000.0, executeFn($tr, "pow10", ("3")), 1e-14 ) || die "Failed on pow10\n";  
    compareDbls(10.0, executeFn($tr, "pow10", ("1.9")), 1e-14 ) || die "Failed on pow10\n";
    compareDbls(-999999, executeFn($tr, "pow10", ("305")), 1e-14 ) || die "Failed on pow10\n";  
    compareDbls(-999999, executeFn($tr, "pow10", ("-305")), 1e-14 ) || die "Failed on pow10\n";    

    compareDbls(3, executeFn($tr, "log10", ("1000")), 1e-14 ) || die "Failed on log10\n";  
    compareDbls(0, executeFn($tr, "log10", ("1")), 1e-14 ) || die "Failed on log10\n";  
    compareDbls(-999999, executeFn($tr, "log10", ("0.9e-304")), 1e-14 ) || die "Failed on log\n";  
    compareDbls(-999999, executeFn($tr, "log", ("-1")), 1e-14 ) || die "Failed on log\n";  

    compareDbls(4.287093850145173, executeFn($tr, "pow", ("2", "2.1")), 1e-14 ) || die "Failed on pow\n";  
    compareDbls(0.2332582478842019, executeFn($tr, "pow", ("2", "-2.1")), 1e-14 ) || die "Failed on pow\n";
    compareDbls(0.5, executeFn($tr, "pow", ("2", "-1")), 1e-14 ) || die "Failed on pow\n";    
    compareDbls(1, executeFn($tr, "pow", ("1000", "0")), 1e-14 ) || die "Failed on pow\n";    
    # -2^2 = 4, but UFDLib bans all negative numbers so we do the same
    compareDbls(-999999, executeFn($tr, "pow", ("-2", "2")), 1e-14 ) || die "Failed on pow\n";    
    compareDbls(-999999, executeFn($tr, "pow", ("-2", "-2.1")), 1e-14 ) || die "Failed on pow\n";    

    compareDbls(-1, executeFn($tr, "round", ("-0.5", "0")), 1e-14 ) || die "Failed on round\n";
    compareDbls(723.13, executeFn($tr, "round", ("723.125", "2")), 1e-14 ) || die "Failed on round\n";
    compareDbls(-723.12, executeFn($tr, "round", ("-723.123", "2")), 1e-14 ) || die "Failed on round\n";
    compareDbls(-700, executeFn($tr, "round", ("-723.123", "-2")), 1e-14 ) || die "Failed on round\n";
    compareDbls(700, executeFn($tr, "round", ("723.123", "-2")), 1e-14 ) || die "Failed on round\n";
    compareDbls(-999999, executeFn($tr, "round", ("723.123", "305")), 1e-14 ) || die "Failed on round\n";

    #!RCB  These test cases are from the UFDLibrary manual, but I disagree with how UFDLibrary
    #truncates negative numbers
    compareDbls(723.12, executeFn($tr, "truncate", ("723.123", "2")), 1e-14 ) || die "Failed on truncate\n";
    compareDbls(-723.13, executeFn($tr, "truncate", ("-723.123", "2")), 1e-14 ) || die "Failed on truncate\n";
    compareDbls(-800, executeFn($tr, "truncate", ("-723.123", "-2")), 1e-14 ) || die "Failed on truncate\n";
    compareDbls(700, executeFn($tr, "truncate", ("723.123", "-2")), 1e-14 ) || die "Failed on truncate\n";
    compareDbls(-999999, executeFn($tr, "truncate", ("723.123", "305")), 1e-14 ) || die "Failed on truncate\n";
    
    # These test cases illustrate what I believe the correct behaviour of truncate to be
    compareDbls(-0, executeFn($tr, "fud_truncate", ("-0.5", "0")), 1e-14 ) || die "Failed on fud_truncate\n";
    compareDbls(-0.54, executeFn($tr, "fud_truncate", ("-0.547", "2")), 1e-14 ) || die "Failed on fud_truncate\n";
    compareDbls(723.12, executeFn($tr, "fud_truncate", ("723.123", "2")), 1e-14 ) || die "Failed on fud_truncate\n";
    compareDbls(-723.12, executeFn($tr, "fud_truncate", ("-723.123", "2")), 1e-14 ) || die "Failed on fud_truncate\n";
    compareDbls(-700, executeFn($tr, "fud_truncate", ("-723.123", "-2")), 1e-14 ) || die "Failed on fud_truncate\n";
    compareDbls(700, executeFn($tr, "fud_truncate", ("723.123", "-2")), 1e-14 ) || die "Failed on fud_truncate\n";
    compareDbls(-999999, executeFn($tr, "fud_truncate", ("723.123", "305")), 1e-14 ) || die "Failed on fud_truncate\n";

    compareDbls(2, executeFn($tr, "sqrt", ("4")), 1e-14 ) || die "Failed on sqrt\n";    
    compareDbls(2.097617696340303, executeFn($tr, "sqrt", ("4.4")), 1e-14 ) || die "Failed on sqrt\n";    
    compareDbls(-999999, executeFn($tr, "sqrt", ("-4.4")), 1e-14 ) || die "Failed on sqrt\n";    

    compareDbls(3, executeFn($tr, "modquot", ("10", "3")), 1e-14 ) || die "Failed on modquot\n";
    compareDbls(5, executeFn($tr, "modquot", ("10", "2")), 1e-14 ) || die "Failed on modquot\n";
    compareDbls(-5, executeFn($tr, "modquot", ("10", "-2")), 1e-14 ) || die "Failed on modquot\n";
    compareDbls(-3, executeFn($tr, "modquot", ("10", "-3")), 1e-14 ) || die "Failed on modquot\n";
    compareDbls(-5, executeFn($tr, "modquot", ("-10", "2")), 1e-14 ) || die "Failed on modquot\n";
    compareDbls(0, executeFn($tr, "modquot", ("0", "-2")), 1e-14 ) || die "Failed on modquot\n";
    compareDbls(-999999, executeFn($tr, "modquot", ("-10", "0")), 1e-14 ) || die "Failed on modquot\n";

    compareDbls(1, executeFn($tr, "modrem", ("10", "-3")), 1e-14 ) || die "Failed on modrem\n";
    compareDbls(-1, executeFn($tr, "modrem", ("-10", "-3")), 1e-14 ) || die "Failed on modrem\n";
    compareDbls(-1, executeFn($tr, "modrem", ("-10", "3")), 1e-14 ) || die "Failed on modrem\n";
    compareDbls(-999999, executeFn($tr, "modrem", ("-10", "0")), 1e-14 ) || die "Failed on modrem\n";
}

sub testString
{
    my ($tr) = @_; 

    # All trim
    ("Fried Chicken" eq executeFn($tr, "alltrim", ("' Fried Chicken   '"))) || die "Failed on alltrim\n"; 
    ("\tFried Chicken\t" eq executeFn($tr, "alltrim", ("' \tFried Chicken\t   '"))) || die "Failed on alltrim\n"; 
    ("\tFried Chicken\t" eq executeFn($tr, "valltrim", ("' \tFried Chicken\t   '"))) || die "Failed on valltrim\n"; 
    ("bbbccc" eq executeFn($tr, "alltrimc", ("'aaabbbccc'", "'a'"))) || die "Failed on alltrimc\n"; 
    ("bbbccc" eq executeFn($tr, "valltrimc", ("'aaabbbccc'", "'a'"))) || die "Failed on valltrimc\n"; 
    ("aaabbb" eq executeFn($tr, "alltrimc", ("'aaabbbccc'", "'c'"))) || die "Failed on alltrimc\n"; 
    ("bbb" eq executeFn($tr, "alltrimc", ("'aaabbbaaa'", "'a'"))) || die "Failed on alltrimc\n"; 

    # Ltrim
    ("Fried Chicken" eq executeFn($tr, "ltrim", ("' Fried Chicken   '"))) || die "Failed on ltrim\n"; 
    ("\tFried Chicken\t" eq executeFn($tr, "ltrim", ("' \tFried Chicken\t   '"))) || die "Failed on ltrim\n"; 
    ("\tFried Chicken\t" eq executeFn($tr, "vltrim", ("' \tFried Chicken\t   '"))) || die "Failed on vltrim\n"; 
    ("bbbccc" eq executeFn($tr, "ltrimc", ("'aaabbbccc'", "'a'"))) || die "Failed on ltrimc\n"; 
    ("bbbccc" eq executeFn($tr, "vltrimc", ("'aaabbbccc'", "'a'"))) || die "Failed on vltrimc\n"; 
    ("aaabbbccc" eq executeFn($tr, "ltrimc", ("'aaabbbccc'", "'c'"))) || die "Failed on ltrimc\n"; 
    ("bbbaaa" eq executeFn($tr, "ltrimc", ("'aaabbbaaa'", "'a'"))) || die "Failed on ltrimc\n"; 

    # Rtrim
    (" Fried Chicken" eq executeFn($tr, "rtrim", ("' Fried Chicken   '"))) || die "Failed on rtrim\n"; 
    (" \tFried Chicken\t" eq executeFn($tr, "rtrim", ("' \tFried Chicken\t   '"))) || die "Failed on rtrim\n"; 
    (" \tFried Chicken\t" eq executeFn($tr, "vrtrim", ("' \tFried Chicken\t   '"))) || die "Failed on vrtrim\n"; 
    ("aaabbbccc" eq executeFn($tr, "rtrimc", ("'aaabbbccc'", "'a'"))) || die "Failed on rtrimc\n"; 
    ("aaabbbccc" eq executeFn($tr, "vrtrimc", ("'aaabbbccc'", "'a'"))) || die "Failed on vrtrimc\n"; 
    ("aaabbb" eq executeFn($tr, "rtrimc", ("'aaabbbccc'", "'c'"))) || die "Failed on rtrimc\n"; 
    ("aaabbb" eq executeFn($tr, "rtrimc", ("'aaabbbaaa'", "'a'"))) || die "Failed on rtrimc\n"; 

    # Soundex
    ("E460" eq executeFn($tr, "fud_soundex", ("'Euler'"))) || die "Failed on soundex\n"; 
    ("A200" eq executeFn($tr, "fud_soundex", ("'Achwg'"))) || die "Failed on soundex\n"; 
    ("A220" eq executeFn($tr, "fud_soundex", ("'Achwgag'"))) || die "Failed on soundex\n"; 
    ("G200" eq executeFn($tr, "fud_soundex", ("'Gauss'"))) || die "Failed on soundex\n"; 
    ("H416" eq executeFn($tr, "fud_soundex", ("'Hilbert'"))) || die "Failed on soundex\n"; 
    ("K530" eq executeFn($tr, "fud_soundex", ("'Knuth'"))) || die "Failed on soundex\n"; 
    ("L300" eq executeFn($tr, "fud_soundex", ("'LloYd'"))) || die "Failed on soundex\n"; 
    ("L222" eq executeFn($tr, "fud_soundex", ("'Lukasiewicz'"))) || die "Failed on soundex\n"; 
    ("W200" eq executeFn($tr, "fud_soundex", ("'Wachs'"))) || die "Failed on soundex\n"; 
    ("E460" eq executeFn($tr, "fud_soundex", ("'Ellery'"))) || die "Failed on soundex\n"; 
    ("G200" eq executeFn($tr, "fud_soundex", ("'Ghosh'"))) || die "Failed on soundex\n"; 
    ("H416" eq executeFn($tr, "fud_soundex", ("'Heilbronn'"))) || die "Failed on soundex\n"; 
    ("K530" eq executeFn($tr, "fud_soundex", ("'Kant'"))) || die "Failed on soundex\n"; 
    ("L300" eq executeFn($tr, "fud_soundex", ("'Liddy'"))) || die "Failed on soundex\n"; 
    ("L222" eq executeFn($tr, "fud_soundex", ("'Lissajous'"))) || die "Failed on soundex\n"; 
    ("W200" eq executeFn($tr, "fud_soundex", ("'Waugh'"))) || die "Failed on soundex\n"; 
    ("B600" eq executeFn($tr, "fud_soundex", ("'Bowyer'"))) || die "Failed on soundex\n"; 

    # Pad
    ("abcd111111" eq executeFn($tr, "pad", ("'abcd'", "'1'", "10"))) || die "Failed on pad\n"; 
    ("Bad parameters in rpad" eq executeFn($tr, "pad", ("'abcd'", "'1'", "1"))) || die "Failed on pad\n"; 
    ("abcd111111" eq executeFn($tr, "vpad", ("'abcd'", "'1'", "10"))) || die "Failed on vpad\n"; 
    ("Bad parameters in rpad" eq executeFn($tr, "vpad", ("'abcd'", "'1'", "1"))) || die "Failed on vpad\n"; 

    # LPad
    ("111111abcd" eq executeFn($tr, "lpad", ("'abcd'", "'1'", "10"))) || die "Failed on lpad\n"; 
    ("Bad parameters in lpad" eq executeFn($tr, "lpad", ("'abcd'", "'1'", "1"))) || die "Failed on lpad\n"; 
    ("111111abcd" eq executeFn($tr, "vlpad", ("'abcd'", "'1'", "10"))) || die "Failed on vlpad\n"; 
    ("Bad parameters in lpad" eq executeFn($tr, "vlpad", ("'abcd'", "'1'", "1"))) || die "Failed on vlpad\n"; 
    
    # Centre
    ("111abcd111" eq executeFn($tr, "centre", ("'abcd'", "'1'", "10"))) || die "Failed on centre\n";
    ("Bad parameters in center" eq executeFn($tr, "center", ("'abcd'", "'1'", "1"))) || die "Failed on vlpad\n";
    ("11abcd111" eq executeFn($tr, "centre", ("'abcd'", "'1'", "9"))) || die "Failed on centre\n";
    ("111abcd111" eq executeFn($tr, "center", ("'abcd'", "'1'", "10"))) || die "Failed on center\n";
    ("111abcd111" eq executeFn($tr, "vcentre", ("'abcd'", "'1'", "10"))) || die "Failed on vcentre\n";
    ("111abcd111" eq executeFn($tr, "vcenter", ("'abcd'", "'1'", "10"))) || die "Failed on vcenter\n";

    # Len
    (6 == executeFn($tr, "len", ("'123456'"))) || die "Failed on len\n";
    (9 == executeFn($tr, "len", ("'123456789'"))) || die "Failed on len\n";
    
    # Lower
    ("mer systems inc." eq executeFn($tr, "lower", ("'MER systems inc.'"))) || die "Failed on lower\n";
    ("deebee solutions ltd" eq executeFn($tr, "lower", ("'Deebee Solutions Ltd'"))) || die "Failed on lower\n";
    
    # cstradd
    ("this and that" eq executeFn($tr, "cstradd", ("'this'", "' and that'"))) || die "Failed on cstradd\n";
    ("this and that" eq executeFn($tr, "vcharadd", ("'this'", "' and that'"))) || die "Failed on cstradd\n";

    # cstrdel
    ("126789" eq executeFn($tr, "cstrdel", ("'123456789'", "2", "3"))) || die "Failed on cstrdel\n";
    ("456789" eq executeFn($tr, "cstrdel", ("'123456789'", "0", "3"))) || die "Failed on cstrdel\n";
    ("Bad paramaters in chrdelete" eq executeFn($tr, "cstrdel", ("'123456789'", "0", "15"))) || die "Failed on cstrdel\n";
    ("456789" eq executeFn($tr, "vchardel", ("'123456789'", "0", "3"))) || die "Failed on cstrdel\n";

    # cstr_plus_int
    ("R96-23" eq executeFn($tr, "cstr_plus_int", ("'R96-'", "23"))) || die "Failed on cstr_plus_int\n";

    # int_plus_cstr
    ("23-R96" eq executeFn($tr, "int_plus_cstr", ("'-R96'", "23"))) || die "Failed on intplus_cstr\n";

    # cstr_to_dbl
    compareDbls(-3.21, executeFn($tr, "cstr_to_dbl", ("'-3.21'")), 1e-14) || die "Failed on cstr_to_dbl\n";
    compareDbls(-321, executeFn($tr, "cstr_to_dbl", ("'-3.21e2'")), 1e-14) || die "Failed on cstr_to_dbl\n";

    # ascii
    (65  == executeFn($tr, "ascii", ("'A'"))) || die "Failed on ascii\n"; 
    (48  == executeFn($tr, "ascii", ("'0'"))) || die "Failed on ascii\n"; 

    # chr
    ("A" eq executeFn($tr, "chr", ("65"))) || die "Failed on chr\n"; 
    ("0" eq executeFn($tr, "chr", ("48"))) || die "Failed on chr\n"; 

    # parse
    ("34" eq executeFn($tr, "parse", ("'12x34x56x78'", "'x'", "2" ))) || die "Failed on parse\n"; 
    ("78" eq executeFn($tr, "parse", ("'12x34x56x78'", "'x'", "4" ))) || die "Failed on parse\n";
    ("Token to long in parse" eq executeFn($tr, "parse", ("'12x34x56x78'", "'x'", "5" ))) || die "Failed on parse\n";
    ("Bad Paramaters in Parse" eq executeFn($tr, "parse", ("'12x34x56x78'", "'x'", "-5" ))) || die "Failed on parse\n"; 
    ("34" eq executeFn($tr, "vparse", ("'12x34x56x78'", "'x'", "2" ))) || die "Failed on vparse\n"; 

    # pos
    (1 == executeFn($tr, "pos", ("'123123123123'", "'23'", "1", "1" ))) || die "Failed on pos\n"; 
    (3 == executeFn($tr, "pos", ("'123123123123'", "'12'", "1", "1" ))) || die "Failed on pos\n"; 
    (0 == executeFn($tr, "pos", ("'123123123123'", "'12'", "0", "1" ))) || die "Failed on pos\n"; 
    (9 == executeFn($tr, "pos", ("'123123123123'", "'12'", "0", "4" ))) || die "Failed on pos\n"; 
    (-1 == executeFn($tr, "pos", ("'123123123123'", "'12'", "0", "5" ))) || die "Failed on pos\n"; 
    (-999999 == executeFn($tr, "pos", ("'123123123123'", "'12'", "0", "-5" ))) || die "Failed on pos\n"; 
    (1 == executeFn($tr, "vpos", ("'123123123123'", "'23'", "1", "1" ))) || die "Failed on vpos\n"; 

    # proper
    ("Robert Schieck" eq executeFn($tr, "proper", ("'robert schieck'" ))) || die "Failed on proper\n";
    ("David Bowyer" eq executeFn($tr, "proper", ("'david bowyer'" ))) || die "Failed on proper\n";
    ("MER Systems Inc." eq executeFn($tr, "proper", ("'MER systems inc.'" ))) || die "Failed on proper\n";
    ("Robert Schieck" eq executeFn($tr, "vproper", ("'robert schieck'" ))) || die "Failed on vproper\n";

    # reverse
    ("able was I ere I saw elba" eq executeFn($tr, "reverse", ("'able was I ere I saw elba'" ))) || die "Failed on reverse\n";
    ("fedcba" eq executeFn($tr, "reverse", ("'abcdef'" ))) || die "Failed on reverse\n";
    ("fedcba" eq executeFn($tr, "vreverse", ("'abcdef'" ))) || die "Failed on vreverse\n";
   
    # lefts
    ("abcde" eq executeFn($tr, "lefts", ("'abcde'", "5" ))) || die "Failed on lefts\n";
    ("abc" eq executeFn($tr, "lefts", ("'abcde'", "3" ))) || die "Failed on lefts\n";
    ("Bad parameters in substring" eq executeFn($tr, "lefts", ("'abcde'", "0" ))) || die "Failed on lefts\n";
    ("abcde" eq executeFn($tr, "lefts", ("'abcde'", "6" ))) || die "Failed on lefts\n";
    ("abcde" eq executeFn($tr, "vlefts", ("'abcde'", "5" ))) || die "Failed on vlefts\n";

    # rights
    ("cfg" eq executeFn($tr, "rights", ("'abcfg'", "3" ))) || die "Failed on rights\n";
    ("abcfg" eq executeFn($tr, "rights", ("'abcfg'", "5" ))) || die "Failed on rights\n";
    ("Bad parameters in substring" eq executeFn($tr, "rights", ("'abcfg'", "6" ))) || die "Failed on rights\n";
    ("Bad parameters in substring" eq executeFn($tr, "rights", ("'abcfg'", "0" ))) || die "Failed on rights\n";

    # substring
    ("and" eq executeFn($tr, "substring", ("'this and that'", "6", "9" ))) || die "Failed on substr\n";
    ("Bad parameters in substring" eq executeFn($tr, "substring", ("'this and that'", "6", "2" ))) || die "Failed on substr\n";
    ("and" eq executeFn($tr, "vsubstring", ("'this and that'", "6", "9" ))) || die "Failed on substr\n";


    # replicate
    ("aaaaaaaaaa" eq executeFn($tr, "replicate", ("'a'", "10" ))) || die "Failed on replicate\n";
    ("aaaaaaaaaa" eq executeFn($tr, "vreplicate", ("'a'", "10" ))) || die "Failed on replicate\n";
}


sub testDate
{
    my ($tr) = @_; 

#    executeFn($tr, "fud_ttoc", ("CAST('1996-11-21 23:10:59.1111' AS TIMESTAMP)"));
#    executeFn($tr, "fud_ttoc", ("CAST('1996-11-21 23:10:59.1117' AS TIMESTAMP)"));
#    executeFn($tr, "fud_ttoc", ("CAST('1996-11-21 23:59:59.9999' AS TIMESTAMP)"));

   (1996 == executeFn($tr, "mer_year", ("CAST('1996-1-31  23:10:59.999' AS TIMESTAMP)"))) || die "Failed on mer_year\n"; 
   (1995 == executeFn($tr, "mer_year", ("CAST('1995-1-31  23:10:59.999' AS TIMESTAMP)"))) || die "Failed on mer_year\n"; 
   (2009 == executeFn($tr, "mer_year", ("CAST('2009-1-31  23:10:59.999' AS TIMESTAMP)"))) || die "Failed on mer_year\n"; 

   (12 == executeFn($tr, "mer_month", ("CAST('1996-12-31  23:10:59.999' AS TIMESTAMP)"))) || die "Failed on mer_month\n"; 
   (1 == executeFn($tr, "mer_month", ("CAST('1996-1-31  23:10:59.999' AS TIMESTAMP)"))) || die "Failed on mer_month\n"; 

   ("January" eq executeFn($tr, "month_of_year", ("CAST('1996-1-1' AS DATE)"))) || die "Failed on month-of_year\n"; 
   ("December" eq executeFn($tr, "month_of_year", ("CAST('1996-12-1' AS DATE)"))) || die "Failed on month-of_year\n"; 

   (1 == executeFn($tr, "mer_day", ("CAST('1996-12-1 23:10:59' AS TIMESTAMP)"))) || die "Failed on mer_day\n"; 
   (13 == executeFn($tr, "mer_day", ("CAST('1996-12-13 23:10:59' AS TIMESTAMP)"))) || die "Failed on mer_day\n"; 
   (31 == executeFn($tr, "mer_day", ("CAST('1996-12-31 23:10:59' AS TIMESTAMP)"))) || die "Failed on mer_day\n"; 

   (2 == executeFn($tr, "dow", ("CAST('1996-1-1 23:10:59' AS TIMESTAMP)"))) || die "Failed on dow\n"; 
   (4 == executeFn($tr, "dow", ("CAST('1996-1-31 23:10:59' AS TIMESTAMP)"))) || die "Failed on dow\n"; 

   ("Monday" eq executeFn($tr, "day_of_week", ("CAST('1996-1-1' AS DATE)"))) || die "Failed on day_of_week\n"; 
   ("Wednesday" eq executeFn($tr, "day_of_week", ("CAST('1996-1-31' AS DATE)"))) || die "Failed on day_of_week\n"; 

   (1 == executeFn($tr, "julian", ("CAST('1996-1-1 1:2:59' AS TIMESTAMP)"))) || die "Failed on julian\n"; 
   (31 == executeFn($tr, "julian", ("CAST('1996-1-31 1:2:59' AS TIMESTAMP)"))) || die "Failed on julian\n"; 
   (366 == executeFn($tr, "julian", ("CAST('1996-12-31 1:2:59' AS TIMESTAMP)"))) || die "Failed on julian\n"; 

   (0 == executeFn($tr, "mer_hour", ("CAST('1996-12-12 0:10:59' AS TIMESTAMP)"))) || die "Failed on mer_hour\n"; 
   (15 == executeFn($tr, "mer_hour", ("CAST('1996-12-12 15:10:59' AS TIMESTAMP)"))) || die "Failed on mer_hour\n"; 
   (23 == executeFn($tr, "mer_hour", ("CAST('1996-12-12 23:10:59' AS TIMESTAMP)"))) || die "Failed on mer_hour\n";

   (0 == executeFn($tr, "mer_minute", ("CAST('1996-12-12 1:0:59' AS TIMESTAMP)"))) || die "Failed on mer_minute\n";  
   (10 == executeFn($tr, "mer_minute", ("CAST('1996-12-12 1:10:59' AS TIMESTAMP)"))) || die "Failed on mer_minute\n";  
   (59 == executeFn($tr, "mer_minute", ("CAST('1996-12-12 1:59:59' AS TIMESTAMP)"))) || die "Failed on mer_minute\n";  

   (0 == executeFn($tr, "sec", ("CAST('1996-12-12 1:2:0' AS TIMESTAMP)"))) || die "Failed on sec\n";  
   (59 == executeFn($tr, "sec", ("CAST('1996-12-12 1:2:59' AS TIMESTAMP)"))) || die "Failed on sec\n";

   (0 == executeFn($tr, "msec", ("CAST('1996-12-31 23:10:59.0' AS TIMESTAMP)"))) || die "Failed on msec\n";   
   (220 == executeFn($tr, "msec", ("CAST('1996-12-31 23:10:59.22' AS TIMESTAMP)"))) || die "Failed on msec\n";
   (999 == executeFn($tr, "msec", ("CAST('1996-12-31 23:10:59.999' AS TIMESTAMP)"))) || die "Failed on msec\n";

   ("1996-11-21 23:59:59.9999" eq executeSQL2($tr, "select CAST(maxtime(CAST('1996-11-21 1:2:3.23' AS TIMESTAMP)) as VARCHAR(24)) from dual")) || die "Failed on maxtime\n";
   ("1996-01-02 23:59:59.9999" eq executeSQL2($tr, "select CAST(maxtime(CAST('1996-1-2 1:2:3' AS TIMESTAMP)) as VARCHAR(24)) from dual")) || die "Failed on maxtime\n";

   ("1996-01-02 00:00:00.0000" eq executeSQL2($tr, "select CAST(zerotime(CAST('1996-1-2 1:2:3' AS TIMESTAMP)) as VARCHAR(24)) from dual")) || die "Failed on zero time\n";
   ("1996-11-21 00:00:00.0000" eq executeSQL2($tr, "select CAST(zerotime(CAST('1996-11-21 1:2:3.23' AS TIMESTAMP)) as VARCHAR(24)) from dual")) || die "Failed on zero time\n";

   ("1996-01-31 23:59:59.9999" eq executeSQL2($tr, "select CAST(lastday(CAST('1996-1-2 1:2:3' AS TIMESTAMP)) as VARCHAR(24)) from dual")) || die "Failed on last day\n";

   ("1996-12-31 23:59:59.9999" eq executeSQL2($tr, "select CAST(lastday(CAST('1996-12-21 11:2:3' AS TIMESTAMP)) as VARCHAR(24)) from dual")) || die "Failed on last day\n";

   ("1996-01-01 00:00:00.0000" eq executeSQL2($tr, "select CAST(firstday(CAST('1996-1-2 1:2:3' AS TIMESTAMP)) as VARCHAR(24)) from dual")) || die "Failed on first day\n";

   ("1996-12-01 00:00:00.0000" eq executeSQL2($tr, "select CAST(firstday(CAST('1996-12-21 11:2:3' AS TIMESTAMP)) as VARCHAR(24)) from dual")) || die "Failed on first day\n";

   (1 == executeFn($tr, "week", ("CAST('1996-1-2 11:2:3' AS TIMESTAMP)"))) || die "Failed on week\n";   
   (51 == executeFn($tr, "week", ("CAST('1996-12-21 11:2:3' AS TIMESTAMP)"))) || die "Failed on week\n";

   ("96Q4" eq  executeFn($tr, "quarter", ("CAST('1996-12-1' AS DATE)", "1"))) || die "Failed on quarter\n";     
   ("00Q4" eq  executeFn($tr, "quarter", ("CAST('2000-1-31' AS DATE)", "2"))) || die "Failed on quarter\n";       
   ("01Q1" eq  executeFn($tr, "quarter", ("CAST('2000-2-1' AS DATE)", "2"))) || die "Failed on quarter\n";      
   ("97Q3" eq  executeFn($tr, "quarter", ("CAST('1996-11-30' AS DATE)", "3"))) || die "Failed on quarter\n";      
   ("97Q4" eq  executeFn($tr, "quarter", ("CAST('1996-12-1' AS DATE)", "3"))) || die "Failed on quarter\n";      
   ("96Q4" eq  executeFn($tr, "quarter", ("CAST('1996-10-1' AS DATE)", "1"))) || die "Failed on quarter\n";      
   ("96Q3" eq  executeFn($tr, "quarter", ("CAST('1996-9-30' AS DATE)", "1"))) || die "Failed on quarter\n";      

   ("1996-01-02 02:02:02.0010" eq executeSQL2($tr, "select CAST(add_time(CAST('1996-1-1 1:1:1' AS TIMESTAMP), 1, 1, 1, 1, 1) as VARCHAR(24)) from dual")) || die "Failed on addtime\n";
   ("1996-01-03 21:02:02.0010" eq executeSQL2($tr, "select CAST(add_time(CAST('1996-1-1 1:1:1' AS TIMESTAMP), 1, 44, 1, 1, 1) as VARCHAR(24)) from dual")) || die "Failed on addtime\n";
   ("1996-01-03 21:03:52.0010" eq executeSQL2($tr, "select CAST(add_time(CAST('1996-1-1 1:1:1' AS TIMESTAMP), 1, 44, 1, 111, 1) as VARCHAR(24)) from dual")) || die "Failed on addtime\n";

   ("1997-01-01 01:01:01.0000" eq executeSQL2($tr, "select CAST(add_time(CAST('1996-1-1 1:1:1' AS TIMESTAMP), 366, 0, 0, 0, 0) as VARCHAR(24)) from dual")) || die "Failed on addtime\n";

   ("2001-01-01 01:01:01.0000" eq executeSQL2($tr, "select CAST(add_time(CAST('2000-1-1 1:1:1' AS TIMESTAMP), 366, 0, 0, 0, 0) as VARCHAR(24)) from dual")) || die "Failed on addtime\n"; # Year 2000 a leap year

   ("1901-01-02 01:01:01.0000" eq executeSQL2($tr, "select CAST(add_time(CAST('1900-1-1 1:1:1' AS TIMESTAMP), 366, 0, 0, 0, 0) as VARCHAR(24)) from dual")) || die "Failed on addtime\n"; # Year 1900 not a leap year


   ("1999-04-16 01:01:01.0000" eq executeSQL2($tr, "select CAST(add_time(CAST('1999-2-15 1:1:1' AS TIMESTAMP), 60, 0, 0, 0, 0) as VARCHAR(24)) from dual")) || die "Failed on addtime\n";

   ("2000-04-16 01:01:01.0000" eq executeSQL2($tr, "select CAST(add_time(CAST('1999-2-15 1:1:1' AS TIMESTAMP), 426, 0, 0, 0, 0) as VARCHAR(24)) from dual")) || die "Failed on addtime\n";

   ("1997-04-16 01:01:01.0000" eq executeSQL2($tr, "select CAST(add_time(CAST('1996-2-15 1:1:1' AS TIMESTAMP), 426, 0, 0, 0, 0) as VARCHAR(24)) from dual")) || die "Failed on addtime\n";


   ("1995-12-30 23:59:59.9990" eq executeSQL2($tr, "select CAST(sub_time(CAST('1996-1-1 1:1:1' AS TIMESTAMP), 1, 1, 1, 1, 1) as VARCHAR(24)) from dual")) || die "Failed on subtime\n";

   ("1995-12-29 00:59:59.9990" eq executeSQL2($tr, "select CAST(sub_time(CAST('1996-1-1 1:1:1' AS TIMESTAMP), 1, 48, 1, 1, 1) as VARCHAR(24)) from dual")) || die "Failed on subtime\n";


   ("1996-01-01 01:01:01.0000" eq executeSQL2($tr, "select CAST(makedate(1996, 1, 1, 1, 1, 1) as VARCHAR(24)) from dual")) || die "Failed on makedate\n";

   ("1997-01-01 01:01:01.0000" eq executeSQL2($tr, "select CAST(makedate(1996, 13, 1, 1, 1, 1) as VARCHAR(24)) from dual")) || die "Failed on makedate\n";

   ("1996-02-01 01:01:01.0000" eq executeSQL2($tr, "select CAST(makedate(1996, 1, 32, 1, 1, 1) as VARCHAR(24)) from dual")) || die "Failed on makedate\n";


   (304  == executeFn($tr, "diffdate", ("CAST('1996-12-12 1:2:59.0' AS TIMESTAMP)", "CAST('1996-2-12 1:2:59.0' AS TIMESTAMP)", 4 ))) || die "Failed on diffdate\n";   

   (7296  == executeFn($tr, "diffdate", ("CAST('1996-12-12 1:2:59.0' AS TIMESTAMP)", "CAST('1996-2-12 1:2:59.0' AS TIMESTAMP)", 3 ))) || die "Failed on diffdate\n";   

   (437760  == executeFn($tr, "diffdate", ("CAST('1996-12-12 1:2:59.0' AS TIMESTAMP)", "CAST('1996-2-12 1:2:59.0' AS TIMESTAMP)", 2))) || die "Failed on diffdate\n";   

   (26265600  == executeFn($tr, "diffdate", ("CAST('1996-12-12 1:2:59.0' AS TIMESTAMP)", "CAST('1996-2-12 1:2:59.0' AS TIMESTAMP)", 1))) || die "Failed on diffdate\n";   

   (-999999  == executeFn($tr, "diffdate", ("CAST('1996-12-12 1:2:59.0' AS TIMESTAMP)", "CAST('1996-2-12 1:2:59.0' AS TIMESTAMP)", 0))) || die "Failed on diffdate\n";   

   (-999999  == executeFn($tr, "diffdate", ("CAST('1996-12-12 1:2:59.0' AS TIMESTAMP)", "CAST('1996-2-12 1:2:59.0' AS TIMESTAMP)", 5))) || die "Failed on diffdate\n";   

   (365  == executeFn($tr, "diffdate", ("CAST('1995-2-15 1:2:59.0' AS TIMESTAMP)", "CAST('1996-2-15 1:2:59.0' AS TIMESTAMP)", 4 ))) || die "Failed on diffdate\n";   # Because not leap year

   (365  == executeFn($tr, "diffdate", ("CAST('1996-2-15 1:2:59.0' AS TIMESTAMP)", "CAST('1995-2-15 1:2:59.0' AS TIMESTAMP)", 4 ))) || die "Failed on diffdate\n";   # Because not leap year

   (366  == executeFn($tr, "diffdate", ("CAST('1995-3-15 1:2:59.0' AS TIMESTAMP)", "CAST('1996-3-15 1:2:59.0' AS TIMESTAMP)", 4 ))) || die "Failed on diffdate\n";

   (366  == executeFn($tr, "diffdate", ("CAST('1996-3-15 1:2:59.0' AS TIMESTAMP)", "CAST('1995-3-15 1:2:59.0' AS TIMESTAMP)", 4 ))) || die "Failed on diffdate\n";


   (366  == executeFn($tr, "diffdate", ("CAST('1996-2-15 1:2:59.0' AS TIMESTAMP)", "CAST('1997-2-15 1:2:59.0' AS TIMESTAMP)", 4 ))) || die "Failed on diffdate\n";   # Because 1996 leap year

   (365  == executeFn($tr, "diffdate", ("CAST('1996-3-15 1:2:59.0' AS TIMESTAMP)", "CAST('1997-3-15 1:3:59.0' AS TIMESTAMP)", 4 ))) || die "Failed on diffdate\n";   # Because 1996 leap year, but past extra day

   (364  == executeFn($tr, "diffdate", ("CAST('1996-3-15 2:2:59.0' AS TIMESTAMP)", "CAST('1997-3-15 1:3:59.0' AS TIMESTAMP)", 4 ))) || die "Failed on diffdate\n";   # Because 1996 leap year, but past extra day and hour short
}




sub main
{
    my ($db, $tr, $st);
    
    print "Creating testfud.gbd database... ";
    $db = create IBPerl::Connection(
	Path => 'testfud.gdb',
	User => 'sysdba',
	Password => 'masterkey',
	Dialect => 3
    );

    ($db->{Handle} >= 0) || die "$0: $db->{Error}\n";
    print "ok\n";
    
    # Create a transaction
    print "Start transaction...";
    $tr = new IBPerl::Transaction(Database=>$db);
    ($tr->{Handle} >= 0) || die "$0: $db->{Error}\n";    
    print "ok\n";

    # Register the FUDLibrary UDFs with our new database
    print "Install registering FUDLibrary with testfud.gdb... "; 
    importSql($tr, "../install/install.sql");    
    importSql($tr, "../install/install_udflib_names.sql");
    $tr->commit; 
    print "ok\n";

    print "Creating table dual... ";
    createDual($db);
    print "ok\n";
 
    $tr = new IBPerl::Transaction(Database=>$db);    

    # Make sure we are testing the right version of the library
    (50 == executeFn($tr, "fud_ver", ())) || die "Wrong verson of FUDLibrary installed\n";
     
    # This version of FUDLibrary should emulate UDFLib 1.0
     compareDbls(1.0, executeFn($tr, "ver", ()), 1e-14) || die "Failed on ver\n";
    
    # Test all the functions
    testAbs($tr);
    testMaxMin($tr);
    testNumeric($tr);
    testString($tr);
    testDate($tr);

    $tr->commit; 

    $db->disconnect;
    
    print "Done!\n";

    # Clean up
    unlink("testfud.gdb");
}



main;

