/*
   
	Copyright (C) 2013 Nicholas McAlpin
	"cstdlib" (by Aeonosphere) is available under the terms of the Mozilla Public License Version 2.0 (MPL v2.0)
	"stringh.inc" (by Aeonosphere) is available under the terms of the Mozilla Public License Version 2.0 (MPL v2.0)

	VERSION: "stringh.inc": v0.5
           
*/


#include <a_samp> //Necessary #include (.inc file)...    
#define MAX_STRING 2048 //Maximum string length strncpy and strncat can handle... 
     
		//Definition of C's strcpy...
		/*
		Name: strcpy
		Usage: strcpy(dest, src, (explicit) size of dest)
    	*/
#if defined strcpy(%0,%1,%2)
	#undef strcpy(%0,%1,%2)
#endif
#define strcpy(%0,%1,%2) \
			strcat((%0[0] = '\0', %0), %1, %2)
     
    //Public function for C's strncpy...
    /*
            Name: strncpy
            Usage: strncpy(dest, src, num chars from start, (explicit) size of dest)
    */
#if defined strncpy(%0,%1,%2,%3)
	#undef strncpy(%0,%1,%2,%3)
#endif
forward strncpy(dest[], src[], num, sDest);
public strncpy(dest[], src[] num, sDest)
{
	new cchar[MAX_STRING];
	strmid(cchar, src, 0, (num-1));
	strdel(cchar, num, strlen(cchar));
	strcat((dest[0] = '\0', dest), cchar, sDest);
	return 1;
}
     
    //Public function for C's strncat...
    /*
            Name: strncat
            Usage: strncat(dest, src, num of chars from start, (explicit) size of dest)
    */
#if defined strncat(%0,%1,%2,%3)
	#undef strncat(%0,%1,%2,%3)
#endif
forward strncat(dest[], src[], num, sDest);
public strncat(dest[], src[], num, sDest)
{
	new cchar[MAX_STRING];
	strmid(cchar, src, 0, (num-1));
	strdel(cchar, num, strlen(cchar));
	strcat(dest, cchar, sDest);
	return 1;
}

	//Re-application of strcmp, bringing it in line with the C standard...
    /*
            Name: strcmp
            Usage: strcmp(string1, string2)
    */
#if defined strcmp(%0,%1,%2,%3)
	#undef strcmp(%0,%1,%2,%3)
#endif
#if defined strcmp(%0,%1)
	#undef strcmp(%0,%1)
#endif
#define strcmp(%0,%1) \
			strcmp(%0,%1,false)
           
    //Re-application of strcmp, bringing it in line with the C standard...
    /*
            Name: strncmp
            Usage: strncmp(string1, string2, num chars from start)
    */
#if defined strncmp(%0,%1,%2,%3)
	#undef strncmp(%0,%1,%2,%3)
#endif
#define strncmp(%0,%1,%2) \
			strcmp(%0,%1,false,%2)
                                   
    //Re-application of strcmp, bringing it in line with the C standard...
    /*
            Name: strcasecmp
            Usage: strcasecmp(string1, string2)
            Special: case is always ignored here
    */
#if defined strcasecmp(%0,%1)
	#undef strcasecmp(%0,%1)\
#endif
#if defined strcasecmp(%0,%1,%2)
	#undef strcasecmp(%0,%1,%2)
#endif
#if defined strcasecmp(%0,%1,%2,%3)
	#undef strcasecmp(%0,%1,%2,%3)
#endif
#define strcasecmp(%0,%1) \
			strcmp(%0,%1,true)
                           
    //Re-application of strcmp, bringing it in line with the C standard...
    /*
            Name: strncasecmp
            Usage: strncasecmp(string1, string2, num chars from start)
            Special: case is always ignored here
    */
#if defined strncasecmp(%0,%1,%2)
	#undef strncasecmp(%0,%1,%2)
#endif
#if defined strncasecmp(%0,%1,%2,%3)
	#undef strncasecmp(%0,%1,%2,%3)
#endif
#define strncasecmp(%0,%1,%2) \
			strcmp(%0,%1,true,%2)