%{
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <glib.h>
#include "lex.yy.c"
int yyerror(char * s); 


typedef struct dataBase {
       GString * serverIp;
       int connect_max;
       GString * enabled;
       int portsNumber; 
       int ports[];

}*DataBase;

typedef struct owner {
       GString * name;
       GString * date;
       GString * time;
       
}*Owner;

typedef struct servers {
       GString * nome;
       GString * ip;
       GString * dc;
       GSList * hosts;
}*Servers;

typedef struct toml {
       GString * titulo;
       GSList * arrDB; 
       GSList * arrOwner; 
       GSList * arrSv; 
} *Toml;

Toml head;
Servers currSv;
Owner currOwner;
DataBase currDB;

Toml newToml(){
       Toml tl = malloc(sizeof(struct toml));
       tl->titulo = g_string_new("");
       tl->arrDB = NULL;
       tl->arrOwner = NULL;
       tl->arrSv = NULL;
       return tl;
}

void initCurrOwner(){
       currOwner = malloc(sizeof(struct owner));
       currOwner->name = g_string_new("");
       currOwner->date = g_string_new("");
       currOwner->time = g_string_new("");  
}

void addNewOwner(){
       Owner l = currOwner;
       head->arrOwner = g_slist_append(head->arrOwner,l);
       initCurrOwner();
}

void addOwnerName(char * str){
       currOwner->name = g_string_append(currOwner->name,str);
}

void addOwnerDate(char * str){
       currOwner->date = g_string_append(currOwner->date,str);    
}

void addOwnerTime(char * str){
       currOwner->time = g_string_append(currOwner->time,str);       
}

// dataBase
void initCurrDB(){
       currDB = malloc(sizeof(struct dataBase));
       currDB->serverIp = g_string_new("");
       currDB->connect_max = -1;
       currDB->enabled =  g_string_new("");
       currDB->portsNumber = 0;
       //currDB->ports
}

void addNewDB(){
       head->arrDB = g_slist_append(head->arrDB,currDB);
       initCurrDB();
}

void addDbSvIp(char * str){
       currDB->serverIp = g_string_append(currDB->serverIp,str);
}

void addDbPort(int port){
       currDB->ports[currDB->portsNumber] = port;   
       currDB->portsNumber++;  
}

void addDbConnectMax(int i){
       currDB->connect_max = i;       
}

void addDbEnabled(char * str){
       currDB->enabled = g_string_append(currDB->enabled,str);       
}

//servers.
void initCurrSvs(){
       currSv = malloc(sizeof(struct servers));
       currSv->nome = g_string_new("");
       currSv->ip = g_string_new("");
       currSv->dc = g_string_new("");
       currSv->hosts = NULL;
}

void addNewServidor(){
    head->arrSv = g_slist_append(head->arrSv,currSv);
    initCurrSvs();
}

void addSvNome(char * str){

       currSv->nome = g_string_append(currSv->nome,str); 
}

void addSvIP(char * str){
       currSv->ip = g_string_append(currSv->ip,str); 
}

void addSvDC(char * str){
       currSv->dc = g_string_append(currSv->dc,str); 
}

void addSvHost(char * str){
       currSv->hosts = g_slist_append(currSv->hosts,str); 
}
FILE* fp;
// json
void printComma() {
       fputs(",\n",fp);
}

void printCloseJsonBracket(int end) {
       if(end == 1)
       fputs("}\n",fp);
       else fputs("},\n",fp);
}

void printOpenJsonBracket() {
       fputs("{\n",fp);
}


void printTitle() {
       char *cat;
       cat = g_string_free(head->titulo, FALSE);
       fputs("       \"title\" : \"",fp);
       fputs(cat,fp);
       fputs("\",\n",fp);

}

void printDatabase(DataBase db) {
       fputs("       \"database\":",fp);
       printOpenJsonBracket();
       char *cat;
       cat = g_string_free(db->serverIp, FALSE);
       fputs("         \"server\": \"",fp);
       fputs(cat,fp);
       fputs("\"",fp);
       printComma();
       fputs("         \"connection_max\": ",fp);
       fprintf(fp,"%d",db->connect_max);
       printComma();
       cat = g_string_free(db->enabled, FALSE);
       fputs("         \"enabled\": \"",fp);
       fputs(cat,fp);
       fputs("\"",fp);
       printComma();
       fputs("         \"ports\": [\n",fp);
       for(int i=0; i < db->portsNumber; i++){
       if(i == db->portsNumber-1) {
       fputs("           ",fp);
       fprintf(fp,"%d\n",db->ports[i]);
       } else {
              fputs("           ",fp);       
              fprintf(fp,"%d,\n",db->ports[i]);
       }
       }
       fputs("         ]\n",fp);
       printCloseJsonBracket(0);
     

}

void printOwner(Owner owner) {
       fputs("       \"owner\": ",fp);
       printOpenJsonBracket();
       char *cat;
       cat = g_string_free(owner->name, FALSE);
       fputs("         \"name\": \"",fp);
       fputs(cat,fp);
       fputs("\"",fp);
       printComma();
       cat = g_string_free(owner->date, FALSE);
       fputs("         \"date\": \"",fp);
       fputs(cat,fp);
       fputs("\"",fp);
       printComma();
       cat = g_string_free(owner->time, FALSE);
       fputs("         \"time\": \"",fp);
       fputs(cat,fp);
       fputs("\"\n",fp);
       printCloseJsonBracket(0);
       
}

void printServer(Servers serv) {
       char *cat;
       cat = g_string_free(serv->ip, FALSE);
       fputs("           \"ip\": \"",fp);
       fputs(cat,fp);
       fputs("\"",fp);
       printComma();
       cat = g_string_free(serv->dc, FALSE);
       fputs("           \"dc\": \"",fp);
       fputs(cat,fp);
       fputs("\"",fp);
       int len = g_slist_length(serv->hosts);
       if(len>0) {
       printComma();
       fputs("           \"hosts\": [\n",fp);
       } 
       for(int i = 0; i<len; i++) {
              if(len-i == 1){
              fputs("             ",fp);
              fputs("\"",fp);
              fputs((char*)g_slist_nth_data(serv->hosts,i),fp);
              fputs("\"\n",fp);
              }else {
                     fputs("             ",fp);
                     fputs("\"",fp);       
                     fputs((char*)g_slist_nth_data(serv->hosts,i),fp);
                     fputs("\",\n",fp);
              }
       }
       if(len>0)
       fputs("           ]\n",fp);
       else
       fputs("\n",fp);

}


void printDatabases() {

       int len = g_slist_length(head->arrDB);
       for(int i = 0; i<len; i++) {
              printDatabase(g_slist_nth_data(head->arrDB,i));
       }
}

void printOwners() {
       int len = g_slist_length(head->arrOwner);
       for(int i = 0; i<len; i++) {
              printOwner(g_slist_nth_data(head->arrOwner,i));
       }
}

void printServers() {
       fputs("       \"servers\":",fp);
       printOpenJsonBracket();
       int len = g_slist_length(head->arrSv);
       char *cat;
       for(int i = 0; i<len; i++) {
              Servers d = (Servers) g_slist_nth_data(head->arrSv,i);
              cat = g_string_free(d->nome, FALSE);
              fputs("         \"",fp);
              fputs(cat,fp);
              fputs("\": ",fp);
              printOpenJsonBracket();
              printServer(d);
              fputs("         ",fp);
              printCloseJsonBracket(len-i);
       }
       fputs("       ",fp);
       printCloseJsonBracket(1);
}



void openFile(char * f){
    fp = fopen(f,"w+");
}


void formatToJson() {
       printOpenJsonBracket();
       printTitle();
       printDatabases();
       printOwners();
       printServers();
       printCloseJsonBracket(1);
}



%}
%union{char* nome; int numero;}

%token TITLE DATABASE SERVERS OWNER 

%token NAME DATE TIME

%token SERVER PORTS CONNECT_MAX DB_ENABLED

%token IP DC HOSTS
 
%token <nome> texto
%token <nome> SUBSERVER
%token <numero> num

%%
Toml : Titulo Body
     | Body  
     ;

Titulo : TITLE '=' texto {head->titulo = g_string_append(head->titulo,$3);}
       ;

Body : Body Struct
     | Struct
     ;


Struct : '[' ']'
       | '[' OWNER ']' OWNER_Struct {addNewOwner();}
       | '[' DATABASE ']' DBStruct {addNewDB();}
       | '[' SERVERS ']' SvStruct 
       ;

OWNER_Struct : OWNER_Struct OWNER_Elem
             | OWNER_Elem  
             ;

OWNER_Elem: NAME '=' texto {addOwnerName($3);}
          | DATE '=' texto {addOwnerDate($3);}
          | TIME '=' texto {addOwnerTime($3);}
          ;

DBStruct : DBStruct DBElem
         | DBElem
         ;
 
DBElem : SERVER '=' texto {addDbSvIp($3);}
       | PORTS  '=' Array {;}
       | CONNECT_MAX '=' num {addDbConnectMax($3);}
       | DB_ENABLED '=' texto {addDbEnabled($3);}
       ;

SvStruct : SvStruct SvComp
         | SvComp 
         ;

SvComp : SUBSERVER LSvELem {addSvNome($1);addNewServidor();}
       | SUBSERVER {addSvNome($1);addNewServidor();}
       ;

LSvELem : LSvELem SvELem
        | SvELem
        ;    

SvELem : IP '=' texto {addSvIP($3);}
       | DC '=' texto {addSvDC($3);}
       | HOSTS '=' Array
       ;

Array : '[' ']'
      | '[' ArrayElem ']'
      ;


ArrayElem : texto ',' ArrayElem {addSvHost($1);}
          | num ',' ArrayElem {addDbPort($1);}
          | texto {addSvHost($1);}
          | num  {addDbPort($1);}
          ;

%%

int yyerror(char *s) { 
    printf("ERRO: %s\n",s); return(0);
    
}

int main(){
    head = newToml();
    initCurrOwner();
    initCurrDB();
    initCurrSvs();   
    yyparse(); 
    
    openFile("output.json");
    formatToJson();
    return 0;
}