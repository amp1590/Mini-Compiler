/* C Declarations */

%{
   
   #include "me.tab.h"
   #include <stdlib.h>
   void yyerror(char *);

%}

KEYWORDS IFC,ELC,FLoop,LessT,GreaterT,LessTEqualT,equ,equequ,LSB,RSB,LFB,RFB,dosum,dosub,somul,dodiv,dopower,fact,sin,cos,tan,ln,till,GreaterTEqualT
DATATYPE int,char,float,string,void main
PUNCTUATUATION sm,cm

%%
count[' '][a-z]*.header[' ']end {return HEADER;}

"!!".*                                { printf("This is a single line comment\n"); printf("%s\n",yytext);}
[@][@][^*]*[*]+([^*/][^*]*[*]+)*[/]   {printf("This is a double line comment\n"); printf("%s\n",yytext);}

[a-z]              { yylval = *yytext;  return VAR;}	  
[0-9]*[.]?[0-9]+   { yylval = atoi(yytext);return NUM;}

"int"		          { return INT;	}
"char"		          { return CHAR;}
"float"		          { return FLOAT;}
"string"              { return STRING;}

"void main"           {return VOID_MAIN ;}

"IFC"                 {return IF ;}
"ELC"                 {return ELSE ;}
"FLoop"               {return FOR ;}
"switch" 		      { return SWITCH; }
"case"   		      { return CASE;   }
"break"  		      { return BREAK;  }
"default" 		      { return DEFAULT; }

"LessT"               {return '<' ;}
"GreaterT"            {return '>' ;}
"LessTEqualT"         {return '<=' ;}
"GreaterTEqualT"      {return '>=' ;}
"NotE"                {return '!=' ;}

"RET"                 {return RETURN ;}

"LSB"                 {return '{' ;}
"RSB"                 {return '}' ;}
"LFB"                 {return '(' ;}
"RFB"                 {return ')' ;}

"sm"                  {return ';' ;}
"cm"                  {return ',' ;}

"dosum"               {return '+' ;}
"dosub"               {return '-' ;}
"domul"               {return '*' ;}
"dodiv"               {return '/' ;}
"dopower"             {return '^' ;}

"fact"                { return FACT;}
"sin"                 { return SIN;}
"cos"                 { return COS;}
"tan"                 { return TAN;}
"ln"                  { return LN;}

":"                   {return ':' ;}
"increase"            {return '++' ;}
"equ"                 {return '=' ;}
"equequ"              {return '==' ;}
"till"                {return TILL ;}

[ \t\n]*	;

.	{ yyerror("Unknown Character.\n");}

%%

int yywrap()
{
  return 1;
}

int main()
{
	yyin = freopen("source.txt","r",stdin);
	yyout = freopen("out.txt","w",stdout);
	yyparse();
	return 0;
}