%{
#include <stdio.h>
#include <string.h>
int variable_count = 0;
int constant_count = 0;
int operators_count = 0;
int kw_count = 0;
int symbol_count = 0;
int identifier_count = 0;
int special_symbol_count = 0;

FILE* output_file;
%}


kw  		("intezar"|"flot"|"str"|"charac"|"bool"|"long"| "if" | "else" | "elsif" | "brk" | "continue" | "constant" | "ret" | "static" | "try" | "catch")
single		("#")[^\n]*
multiline	("/#*").*?("\*#")
variable  	[a-zA-Z_][a-zA-Z_0-9]{0,14}
str     	\"[^\"]*\"
intezar    	[\+\-]?[0-9]+
flot 		[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?
charac		\'[^\n]\'
bool    	("false"|"true")


logic_oprtr	("or"|"and"|"xor")
bits_oprtr 	(&|\|\^|>>|<<)
math_oprtr   	(\+|\-|\*|\/|%) 
assignment_oprtr    "="
increment_oprtr	   ("++")
decrement_oprtr	  ("--")
power            ("**")

return            ("ret")
break             ("brk")
stop              ("continue")

%%
{kw}	        { fprintf(output_file, "%s\t- KEYWORD\n", yytext); kw_count++; }
{single}	{ fprintf(output_file, "%s\t- SINGLE_LINE_COMMENT\n", yytext); }
{multiline} 	{ fprintf(output_file, "%s\t- DOUBLE_LINE_COMMENT\n", yytext); }
"("             { fprintf(output_file, "%s\t- OPENING BRACKETS\n", yytext); special_symbol_count++; }
")"             { fprintf(output_file, "%s\t- CLOSING BRACKETS\n", yytext); special_symbol_count++; }
"{"             { fprintf(output_file, "%s\t- OPENING BRACES\n", yytext); special_symbol_count++; }
"}"             { fprintf(output_file, "%s\t- CLOSING BRACES\n", yytext); special_symbol_count++; }
";"             { fprintf(output_file, "%s\t- SEMICOLON\n", yytext); special_symbol_count++; }
","             { fprintf(output_file, "%s\t- COMMA\n", yytext); special_symbol_count++; }
">>"            { fprintf(output_file, "%s\t- INPUT\n", yytext); special_symbol_count++; }
"<<"            { fprintf(output_file, "%s\t- OUTPUT\n", yytext); special_symbol_count++; }
{logic_oprtr}                               	{ fprintf(output_file, "%s\t- LOGICAL OPERATOR\n", yytext); operators_count++; }
{bits_oprtr}                   	            	{ fprintf(output_file, "%s\t- BITWISE OPERATOR\n", yytext);operators_count++; }         
{math_oprtr}                                 	{ fprintf(output_file, "%s\t- Math operators\n", yytext); operators_count++; }
{assignment_oprtr}                              { fprintf(output_file, "%s\t- ASSIGNMENT\n", yytext); operators_count++; }
{increment_oprtr}                               { fprintf(output_file, "%s\t- INCREMENT\n", yytext); operators_count++; }
{decrement_oprtr}                               { fprintf(output_file, "%s\t- DECREMENT\n", yytext); operators_count++; }
{power}                                		{ fprintf(output_file, "%s\t- POWER\n", yytext); operators_count++; }
{bool}    		           {x = yytext; print("bool",  x);}            
"<"                                 		{ fprintf(output_file, "%s\t- LESS_THAN\n", yytext); operators_count++; }
"<="                                		{ fprintf(output_file, "%s\t- LESS_THAN_OR_EQUAL\n", yytext); operators_count++; }
">"                                 		{ fprintf(output_file, "%s\t- GREATER_THAN\n", yytext); operators_count++; }
">="                                		{ fprintf(output_file, "%s\t- GREATER_THAN_OR_EQUAL\n", yytext); operators_count++; }
"=="                                		{ fprintf(output_file, "%s\t- EQUALS\n", yytext); operators_count++; }
"!="                                		{ fprintf(output_file, "%s\t- NOT_EQUAL\n", yytext); operators_count++; }
[-+]?[0-9]+					{ fprintf(output_file, "%s\t- INTEGER_CONSTANT\n", yytext); constant_count++; }
[-+]?[0-9]*\.[0-9]+				{ fprintf(output_file, "%s\t- FLOATING_CONSTANT\n", yytext); constant_count++; }
\'[A-Z|a-z]\' 					{ fprintf(output_file, "%s\t- CHARACTER_CONSTANT\n", yytext); constant_count++; }
\".*\"                  			{ fprintf(output_file, "%s\t- STRING_LITERAL\n", yytext); constant_count++; }           
"input"                	            		{ fprintf(output_file, "%s\t- IDENTIFIER\n", yytext); identifier_count++; }
"output"                            		{ fprintf(output_file, "%s\t- IDENTIFIER\n", yytext); identifier_count++; }
[a-zA-Z_][a-zA-Z0-9_]*				{ fprintf(output_file, "%s\t- IDENTIFIER\n", yytext); identifier_count++; }
[a-z|A-Z|_]([a-z|A-Z|_]|[0-9])*\[[0-9]*\]	{ fprintf(output_file, "%s\t- ARRAY_IDENTIFIER\n", yytext); identifier_count++; }
.           					{ /* Ignore unrecognized characters */ }

%%

int main() {
    output_file = fopen("output.txt", "w"); // Open the output file
    if (output_file == NULL) {
        perror("Error opening output file");
        return 1;
    }
    
    FILE* input_file = fopen("input.txt", "r"); // Open the input file
    if (input_file == NULL) {
        perror("Error opening input file");
        return 1;
    }
    
    yyin = input_file; // Set the input file for the lexer
    yylex(); // Tokenize and analyze the code
    
    fclose(input_file); // Close the input file
    fclose(output_file); // Close the output file
    return 0;
}




