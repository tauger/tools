#!/usr/bin/awk -f

BEGIN { 
				x1=0; 
				x2=0; 
				x3=0; 
				x4=0;
				total=0;
}
{
				total+=$2;
				if ( $1<10 ) { 
								x1+=$2;
				}
				if ( $1>=10 && $1<20 ) { 
								x2+=$2;
				}
				if ( $1>=20 && $1<30 ) { 
								x3+=$2;
				}
				if ( $1>=30 && $1<40 ) { 
								x4+=$2;
				}
}
END {	
				print "0-9 " x1/total;
				print "10-19 " x2/total;
				print "20-29 " x3/total;
				print "30-39 " x4/total;
}
