#include <glib.h>
#include <stdio.h>
#include <commentThread.h>





typedef struct commentThread {

    GString * id;
    GString * user;
    GString * date;
    GString * timestamp; 
    GString * comentTxt; 
    GString * likes; 
    int hasReplies;
    int numberOfReplies;
    CommentThread replies[]; 
}*CommentThread;




CommentThread newCommentThread(){
    CommentThread ct = malloc(sizeof(struct commentThread));
    ct->id = g_string_new("");
    ct->user = g_string_new("");
    ct->date = g_string_new("");
    ct->timestamp = g_string_new(""); 
    ct->comentTxt = g_string_new("");
    ct->likes = g_string_new("");
    ct->hasReplies = FALSE;
    ct->numberOfReplies = 0; 
    //ct->replies
    return ct;
}



void freeCommentThread(CommentThread c){
    g_string_free(c->id,TRUE);
    g_string_free(c->user,TRUE);
    g_string_free(c->date,TRUE);
    g_string_free(c->timestamp,TRUE);
    g_string_free(c->comentTxt,TRUE);
    
    c->hasReplies = FALSE;
    c->numberOfReplies = 0;
    //g_list_free(c->replies);


}


void setID(CommentThread c,char* s){
    g_string_append(c->id,s);


}

void setUser(CommentThread c,char* s){
    //printf("QND ADICIONA %s\n",s);
    g_string_append(c->user,s);


}
void setDate(CommentThread c,char* s){
    g_string_append(c->date,s);

}

void setTimeStamp(CommentThread c,char* t){
    g_string_append(c->timestamp,t);
}

void addCommentTxt(CommentThread c,char* s){
    g_string_append(c->comentTxt,s);

}


void addLikes(CommentThread c,char* s){
    //g_string_append(c->likes,s);
}

void setHasReplaiesTRUE(CommentThread c){
    c->hasReplies = TRUE;
}

void addNumberOfReplies(CommentThread c,int r){
    c->numberOfReplies += r;
}


void addReplieToList(CommentThread c,CommentThread r){
    //indefinido
}

void formatToJSON(CommentThread c){
    char *cat;
    cat = g_string_free(c->id, FALSE);
    g_print("ID : %s\n", cat);
    
    cat = g_string_free(c->user, FALSE);
    g_print("USERNAME : %s\n", cat);

    
    cat = g_string_free(c->date, FALSE);
    g_print("DATA : %s\n", cat);
    
    cat = g_string_free(c->timestamp, FALSE);
    g_print("HORA : %s\n", cat);
    
    cat = g_string_free(c->comentTxt, FALSE);
    g_print("TEXT : %s\n", cat);
    printf("\n");
    g_free(cat);
    


}

CommentThread addnewComment(CommentThread head){
    head->hasReplies = TRUE;
    head->replies[head->numberOfReplies] = newCommentThread();
    CommentThread curr = head->replies[head->numberOfReplies];

    head->numberOfReplies++;

    return curr;

}



int getNumberOfReplies(CommentThread c){
    return c->numberOfReplies;


}

CommentThread getReply(CommentThread c,int p){
    return c->replies[p];


}

CommentThread getCurrentReply(CommentThread c){
    int tmp = c->numberOfReplies - 1 ;
    return c->replies[tmp];

}










