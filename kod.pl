:- use_module(library(clpfd)).


/* Given latin square Q and some rows of P orotogonal to Q this predicat
 * is trying to find next row of P
 * S is list of sets that are possible to put in row in matrix ortogonal to Q
 * Qrow is row of Q matrix
 * Q_ort is list of pairs that occured before
 * L is list that represent row of matrix that we want to find
 * R is list of sets that  will be posible to put in entries of next row
 * Q_ort_new s list of pairs that occured before and in this row
 * */
ort_row(S,Qrow,Q_ort,L,R,Q_ort_new):-ort_row(S,Qrow,Q_ort,[],L,S,[],R,Q_ort_new).
ort_row([],[],Q_ort,Lacc,L,[],Racc,R,Q_ort):- reverse(Lacc,L),reverse(Racc,R).
ort_row([[H|T]| S],[Qrow_H|Qrow_T],Q_ort,Lacc,L,[Q|S1],Racc,R,Q_ort_new):- \+ member(H,Lacc), \+ member(point(H,Qrow_H),Q_ort),
    Q_ort1 = [point(H,Qrow_H)|Q_ort],Lacc1 = [H|Lacc],delete(Q,H,Q1),Racc1 = [Q1|Racc],ort_row(S,Qrow_T,Q_ort1,Lacc1,L,S1,Racc1,R,Q_ort_new).

ort_row([[H|T]| S],Qrow,Q_ort,Lacc,L,S1,Racc,R,Q_ort_new):- ort_row([T | S],Qrow,Q_ort,Lacc,L,S1,Racc,R,Q_ort_new).
/*For given list this predicat generate list of form [point(h,h)] where h are elements from H  */
pair(H,Q_ort):-pair(H,Q_ort,[]).
pair([],Acc,Acc).
pair([H|T],Q_ort,Acc):- Acc1=[ point(H,H) |Acc],pair(T,Q_ort,Acc1).
/*This predicat for latin square A=[H|Q] is trying to find latin square B=[H|P] ortogonal to A*/
ort_matrix([H|Q],[H|P]):-pair(H,Q_ort),transpose(Q,Q_T),ort_matrix(Q,Q_ort,P,Q_T).
ort_matrix([Qrow|Q],Q_ort,[L|P],S):-ort_row(S,Qrow,Q_ort,L,R,Q_ort_new),ort_matrix(Q,Q_ort_new,P,R).
ort_matrix([],B,[],D).

/*ort_matrix([[1,2,3],[2,3,1],[3,1,2]],P)*/
/*ort_matrix([[1,2,3,4],[2,3,4,1],[3,4,1,2],[4,1,2,3]],P)*/
/*ort_matrix([[1,2,3,4],[2,1,4,3],[3,4,1,2],[4,3,2,1]],P)*/
/*ort_matrix([[1,2,3,4,5,6],[2,3,4,5,6,1],[3,4,5,6,1,2],[4,5,6,1,2,3],[5,6,1,2,3,4],[6,1,2,3,4,5]],P)*/

/* S is list of sets from which we want to create system of distict representant
 * K is element that is forbidden in system of distict representant
 * L is system of distict representant 
 * R is list of sets that remained
 * */
sdr(S,K,L,R):-sdr(S,K,[],L,S,[],R).
sdr([],K,Lacc,L,[],Racc,R):- reverse(Lacc,L),reverse(Racc,R).
sdr([[H|T]| S],K,Lacc,L,[Q|S1],Racc,R):- K\=H, \+ member(H,Lacc),Lacc1 = [H|Lacc],delete(Q,H,Q1),Racc1 = [Q1|Racc],sdr(S,K,Lacc1,L,S1,Racc1,R).
sdr([[H|T]| S],K,Lacc,L,S1,Racc,R):- sdr([T | S],K,Lacc,L,S1,Racc,R).

/* this predicat create a list that is using to create system of distict representant 
 * to create a reduced latin square
 * */
sets_for_sdr([H|T],S):-sets_for_sdr(T,[H|T],S).
sets_for_sdr([H|T],L,[P|S]):-delete(L,H,P),sets_for_sdr(T,L,S).
sets_for_sdr([],L,[]). 
/* this predicat create reduced latin square that element are from some list L
 * first row and colum of this matrix are list L
 * 
 *  */
red_matrix([H|T],[[H|T]|P]):-sets_for_sdr([H|T],S),red_matrix(T,P,S).
red_matrix([H|L],[[H|L1]|P],S):-sdr(S,H,L1,R),red_matrix(L,P,R).
red_matrix([],[],S).
/* this predicat is trying to find latin square 2 that entries are from L
 * Q is reduced latin square
 * P is latin square such that first row is L
 * */
find_ort(L,Q,P):-red_matrix(L,Q),ort_matrix(Q,P).
/*example of query */
/*finding ortogonal squares*/
/*find_ort([1,2],Q,P)*/
/*find_ort([1,2,3],Q,P)*/
/*find_ort([1,2,3,4],Q,P)*/
/*find_ort([1,2,3,4,5],Q,P)*/
/*find_ort([1,2,3,4,5,6],Q,P)*/	

/*finding reduced square*/
/* red_matrix([1,2,3],Q)*/
/* red_matrix([1,2,3,4],Q)*/
/* red_matrix([1,2,3,4,5],Q)*/
