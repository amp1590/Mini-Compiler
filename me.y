/* C Declarations */

%{
	#include<stdio.h>
	#include <malloc.h>
	#include <stdlib.h>
	#include <math.h>
	#include <string.h>
    #define PI 3.14159265
	void yyerror(char *);
	int yylex(void);
	int sym[26];
	int a[5]; 
    int store[5];    
    int r;
    int fact(int n)
    {
        int i,sum=1;
        for(i=1;i<=n;i++)
        { 
            sum=sum*i;
        }
        return sum;
    }
	
%}

/* BISON Declarations */

%token NUM VAR IF ELSE FOR VOID_MAIN INT CHAR FLOAT STRING RETURN BREAK SWITCH DEFAULT CASE HEADER SIN COS TAN LN FACT TILL
%nonassoc IFX
%nonassoc ELSE
%nonassoc DEFAULT
%nonassoc SWITCHX
%nonassoc CASE
%left '<' '>'
%left '+' '-'
%left '*' '/'
%left '='
%right FACT
%left '^'

/* Simple grammar rules */

%%

program: VOID_MAIN '(' ')' '{' cstatement '}'
	 ;

cstatement: /* empty */

	| cstatement statement
	;


statement: ';'
    | cdec

	| exp ';' 			{ printf("value of exp: %d\n", $1); }

    | VAR '=' exp ';'   { 
							sym[$1] = $3; 
							printf("Value of the variable: %d\t\n",$3);
						}
																							  
	| FOR '(' NUM TILL NUM ')' '{' exp ';' '}'  {
	                                            int i;
	                                            for(i=$3 ; i<$5 ; i++) 
									            {
									               printf("Value: %d\n",$8);
									               printf("value of the loop: %d\n", i);
									            }									
				                            }
	                                                                                             
	| SWITCH '(' VAR ')' '{' st  '}'  %prec SWITCHX   {     for(r=0;r<3;r++)
                                                                {
                                                                 if(a[r]==sym[$3])
                                                                    {
                                                                     printf("Value of Case %d : %d\n",sym[$3],store[r]);
                                                                     break;
                                                                     }
                                                                 }

                                                   
                                                       }
	
	| IF '(' exp ')' exp ';' %prec IFX {
								if($3)
								{
									printf("\nvalue of exp in IF: %d\n",$5);
								}
								else
								{
									printf("condition value zero in IF block\n");
								}
							}

	| IF '(' exp ')' exp ';' ELSE exp ';' {
								 	if($3)
									{
										printf("value of exp in IF: %d\n",$5);
									}
									else
									{
										printf("value of exp in ELSE: %d\n",$8);
									}
								   }
	;
	
st   : st1

    ;
st1   : st1  st1
	| CASE NUM ':' exp ';' BREAK ';'  {                                                 
                                            a[r]=$2;                                                       
                                            store[r]=$4;            
                                            r++;                                                 
                                      }
	;
	
cdec: TYPE ID1 ';' 
    ;

ID1: ID
     | ID1 ',' ID
     ;
	 
ID:  VAR
     ;

TYPE:   INT
      | CHAR
      | FLOAT
      | STRING
      ;

exp: NUM				{ $$ = $1; 	}

	| VAR				{ $$ = sym[$1]; }

	| exp '+' exp	{ $$ = $1 + $3; }
	| VAR '+' exp   { $$ = sym[$1] + $3;}
	| exp '+' VAR   { $$ = $1 + sym[$3];}
	| VAR '+' VAR   { $$ = sym[$1] + sym[$3];}

	| exp '-' exp	{ $$ = $1 - $3; }
	| VAR '-' exp   { $$ = sym[$1] - $3;}
	| exp '-' VAR   { $$ = $1 - sym[$3];}
	| VAR '-' VAR   { $$ = sym[$1] - sym[$3];}

	| exp '*' exp	{ $$ = $1 * $3; }
	| VAR '*' exp   { $$ = sym[$1] * $3;}
	| exp '*' VAR   { $$ = $1 * sym[$3];}
	| VAR '*' VAR   { $$ = sym[$1] * sym[$3];}

	| exp '/' exp	{ 	if($3) 
				  		{
				     		$$ = $1 / $3;
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\ndivision by zero\t");
				  		} 	
				    }
	| VAR '/' exp   { 	if($3) 
				  		{
				     			$$ = sym[$1] / $3;
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\ndivision by zero\t");
				  		} 	
				    }
	| exp '/' VAR   { 	if(sym[$3]) 
				  		{
				     			$$ = $1 / sym[$3];
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\ndivision by zero\t");
				  		} 	
				    }
	| VAR '/' VAR   { 	if(sym[$3]) 
				  		{
				     			$$ = sym[$1] / sym[$3];
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\ndivision by zero\t");
				  		} 	
				    }
    
	| exp '^' exp	                     { $$ = pow($1,$3); }                        
    | VAR '^' exp                        { $$ = pow(sym[$1],$3);}
    | exp '^' VAR                        { $$ = pow($1,sym[$3]);}
    | VAR '^' VAR                        { $$ = pow(sym[$1],sym[$3]);}

    | FACT '(' exp ')'                   {  $$ = fact($3); } 	
    | FACT '(' VAR ')'                   {  $$ = fact(sym[$3]);}

    | SIN '(' exp ')'                    {  $$ = sin(($3*PI)/180); }  
    | SIN '(' VAR ')'                    {  $$ = sin((sym[$3]*PI)/180);}

    | COS '(' exp ')'                    {  $$ = cos(($3*PI)/180); }  
    | COS '(' VAR ')'                    {  $$ = cos((sym[$3]*PI)/180);}

    | TAN '(' exp ')'                    {  $$ = tan(($3*PI)/180); }  
    | TAN '(' VAR ')'                    {  $$ = tan((sym[$3]*PI)/180);}

    | LN '(' exp ')'                     {  $$ = log($3); }  
    | LN '(' VAR ')'                     {  $$ = log(sym[$3]);}
	
	| VAR '=' exp                        {sym[$1] = $3;}				
    | VAR '=' VAR                 	     { sym[$1] = sym[$3];} 
    | VAR '==' VAR                       { $$ = (sym[$1] == sym[$3]); }

	| exp '<' exp	                     { $$ = $1 < $3; }
	| exp '<' VAR	                     { $$ = $1 < sym[$3]; }
	| VAR '<' exp	                     { $$ = sym[$1] < $3; }
	| VAR '<' VAR                        { $$ = (sym[$1] < sym[$3]); }
	
	| exp '<=' exp	                     { $$ = $1 <= $3; }
	| exp '<=' VAR	                     { $$ = $1 <= sym[$3]; }
	| VAR '<=' exp	                     { $$ = sym[$1] <= $3; }
	| VAR '<=' VAR                        { $$ = (sym[$1] <= sym[$3]); }


	| exp '>' exp	                     { $$ = $1 > $3; }
	| exp '>' VAR	                     { $$ = $1 > sym[$3]; }
	| VAR '>' exp	                     { $$ = sym[$1] > $3; }
	| VAR '>' VAR                        { $$ = (sym[$1] > sym[$3]); }
	
	| exp '>=' exp	                     { $$ = $1 >= $3; }
	| exp '>=' VAR	                     { $$ = $1 >= sym[$3]; }
	| VAR '>=' exp	                     { $$ = sym[$1] >= $3; }
	| VAR '>=' VAR                       { $$ = (sym[$1] >= sym[$3]); }

	| '(' exp ')'		                 { $$ = $2;	}
	
	;
%%

void yyerror(char *s) {
fprintf(stderr, "%s\n", s);
}

