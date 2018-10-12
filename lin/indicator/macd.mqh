/ / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                                                                                   m a c d . m q h   |  
 / / |                                                                                                                     l i n b i r g   |  
 / / |                                                                                           h t t p s : / / w w w . m q l 5 . c o m   |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 # p r o p e r t y   c o p y r i g h t   " l i n b i r g "  
 # p r o p e r t y   l i n k             " h t t p s : / / w w w . m q l 5 . c o m "  
 # p r o p e r t y   s t r i c t  
  
 i n p u t   d o u b l e   M A C D O p e n L e v e l   = 6 ;  
 i n p u t   d o u b l e   M A C D C l o s e L e v e l = 5 ;  
 i n p u t   i n t         C h e c k P e r i o d = 2 4 ;  
  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                                                                                                     |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 b o o l   C h e c k F o r G o l d ( d o u b l e   M a c d C u r r e n t , d o u b l e   M a c d P r e v i o u s , d o u b l e   S i g n a l C u r r e n t , d o u b l e   S i g n a l P r e v i o u s )  
 {  
       i f ( M a c d C u r r e n t > S i g n a l C u r r e n t   & &   M a c d P r e v i o u s < S i g n a l P r e v i o u s )  
           {  
             i f ( M a t h A b s ( M a c d C u r r e n t ) > ( M A C D O p e n L e v e l * P o i n t ) )  
                 {  
                   / / P r i n t ( " �hKm0Rё�S" ) ;  
                   r e t u r n   t r u e ;  
                 }  
  
             P r i n t ( " ё�SN�n�� _�N�vؚ�^" ) ;  
           }  
  
       r e t u r n   f a l s e ;  
 }  
  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                                                                                                     |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 b o o l   C h e c k F o r D e a t h ( d o u b l e   M a c d C u r r e n t , d o u b l e   M a c d P r e v i o u s , d o u b l e   S i g n a l C u r r e n t , d o u b l e   S i g n a l P r e v i o u s )  
 {  
       i f ( M a c d C u r r e n t < S i g n a l C u r r e n t   & &   M a c d P r e v i o u s > S i g n a l P r e v i o u s )  
           {  
             i f ( M a t h A b s ( M a c d C u r r e n t ) > ( M A C D O p e n L e v e l * P o i n t ) )  
                 {  
                   / / P r i n t ( " �hKm0R{k�S" ) ;  
                   r e t u r n   t r u e ;  
                 }  
             P r i n t ( " {k�SN�n�� _�N�vؚ�^" ) ;  
           }  
  
       r e t u r n   f a l s e ;  
 }  
  
  
 / / �h�g N\�e�Q/f&T	g0 t�N�vё�S 
 b o o l   C h e c k F o r G o l d I n H o u r ( )  
 {  
       d o u b l e   M a c d C u r r e n t , M a c d P r e , S i g n a l C u r r e n t , S i g n a l P r e ;  
       f o r ( i n t   i = 0 ; i < C h e c k P e r i o d ; i + + )  
           {  
             M a c d C u r r e n t = i M A C D ( N U L L , 0 , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ M A I N , i ) ;  
             M a c d P r e = i M A C D ( N U L L , 0 , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ M A I N , i + 1 ) ;  
             S i g n a l C u r r e n t = i M A C D ( N U L L , 0 , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ S I G N A L , i ) ;  
             S i g n a l P r e = i M A C D ( N U L L , 0 , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ S I G N A L , i + 1 ) ;  
  
             / / (W0 t�N�vё�S 
             i f ( C h e c k F o r G o l d ( M a c d C u r r e n t , M a c d P r e , S i g n a l C u r r e n t , S i g n a l P r e ) & & M a c d C u r r e n t < 0 )  
             {  
                   P r i n t ( " (W0 t�N�vё�S" ) ;  
                   r e t u r n   t r u e ;  
             }  
           }  
  
       r e t u r n   f a l s e ;  
 }  
  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 / / |                                                                                                                                     |  
 / / + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +  
 b o o l   C h e c k F o r D e a t h I n H o u r ( )  
 {  
       d o u b l e   M a c d C u r r e n t , M a c d P r e , S i g n a l C u r r e n t , S i g n a l P r e ;  
       f o r ( i n t   i = 0 ; i < C h e c k P e r i o d ; i + + )  
           {  
             M a c d C u r r e n t = i M A C D ( N U L L , 0 , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ M A I N , i ) ;  
             M a c d P r e = i M A C D ( N U L L , 0 , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ M A I N , i + 1 ) ;  
             S i g n a l C u r r e n t = i M A C D ( N U L L , 0 , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ S I G N A L , i ) ;  
             S i g n a l P r e = i M A C D ( N U L L , 0 , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ S I G N A L , i + 1 ) ;  
  
             / / (W0 t�
N�v{k�S 
             i f ( C h e c k F o r D e a t h ( M a c d C u r r e n t , M a c d P r e , S i g n a l C u r r e n t , S i g n a l P r e ) & & M a c d C u r r e n t > 0 )  
             {  
                   P r i n t ( " (W0 t�
N�v{k�S" ) ;  
                   r e t u r n   t r u e ;  
             }  
 }  
  
       r e t u r n   f a l s e ;  
 }  
  
  
  
   b o o l   i s D e a t h ( i n t   i , i n t   t i m e f r a m e )  
   {  
       d o u b l e   M a c d C u r r e n t = i M A C D ( N U L L , t i m e f r a m e , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ M A I N , i ) ;  
       d o u b l e   M a c d P r e = i M A C D ( N U L L , t i m e f r a m e , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ M A I N , i + 1 ) ;  
       d o u b l e   S i g n a l C u r r e n t = i M A C D ( N U L L , t i m e f r a m e , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ S I G N A L , i ) ;  
       d o u b l e   S i g n a l P r e = i M A C D ( N U L L , t i m e f r a m e , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ S I G N A L , i + 1 ) ;  
  
       r e t u r n   C h e c k F o r D e a t h ( M a c d C u r r e n t , M a c d P r e , S i g n a l C u r r e n t , S i g n a l P r e ) ;  
   }  
  
   b o o l   i s G o l d ( i n t   i , i n t   t i m e f r a m e )  
   {  
       d o u b l e   M a c d C u r r e n t = i M A C D ( N U L L , t i m e f r a m e , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ M A I N , i ) ;  
       d o u b l e   M a c d P r e = i M A C D ( N U L L , t i m e f r a m e , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ M A I N , i + 1 ) ;  
       d o u b l e   S i g n a l C u r r e n t = i M A C D ( N U L L , t i m e f r a m e , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ S I G N A L , i ) ;  
       d o u b l e   S i g n a l P r e = i M A C D ( N U L L , t i m e f r a m e , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ S I G N A L , i + 1 ) ;  
  
       r e t u r n   C h e c k F o r G o l d ( M a c d C u r r e n t , M a c d P r e , S i g n a l C u r r e n t , S i g n a l P r e ) ;  
   }  
  
   b o o l   i s B e l o w Z e r o ( i n t   i , i n t   t i m e f r a m e )  
   {  
       d o u b l e   M a c d C u r r e n t = i M A C D ( N U L L , t i m e f r a m e , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ M A I N , i ) ;  
       i f ( M a c d C u r r e n t   <   0   & &   M a t h A b s ( M a c d C u r r e n t ) > ( M A C D O p e n L e v e l * P o i n t ) )  
       {  
             P r i n t ( " i s B e l o w Z e r o : ,{" , i , " MOn�vm a c d (W0 t�KNN" ) ;  
             r e t u r n   t r u e ;  
       }  
       r e t u r n   f a l s e ;  
   }  
  
   b o o l   i s A b o v e Z e r o ( i n t   i , i n t   t i m e f r a m e )  
   {  
       d o u b l e   M a c d C u r r e n t = i M A C D ( N U L L , t i m e f r a m e , M A T r e n d P e r i o d F a s t , M A T r e n d P e r i o d , 9 , P R I C E _ C L O S E , M O D E _ M A I N , i ) ;  
       i f ( M a c d C u r r e n t   >   0   & &   M a t h A b s ( M a c d C u r r e n t ) > ( M A C D O p e n L e v e l * P o i n t ) )  
       {  
             P r i n t ( " i s B e l o w Z e r o : ,{" , i , " MOn�vm a c d (W0 t�KN
N" ) ;  
             r e t u r n   t r u e ;  
       }  
       r e t u r n   f a l s e ;  
   }  
  
   / /  g'Y�gwb a r �vpe�v 
   i n t   M A X _ C O U N T   =   5 0 0 ;  
   i n t   f i n d F i r s t D e a t h ( i n t   t i m e f r a m e )  
   {  
       f o r ( i n t   i = 0 ; i < M A X _ C O U N T ; i + + )  
       {  
             i f ( i s D e a t h ( i , t i m e f r a m e ) ) r e t u r n   i ;  
       }  
  
       r e t u r n   M A X _ C O U N T ; / / �Y�gi = 3 0 0 h�:y�l	g~b0R0�^�NO	gُHNEN؏�l	g{k�S�v�`�Q 
   }  
  
   i n t   f i n d F i r s t G o l d ( i n t   t i m e f r a m e )  
   {  
       f o r ( i n t   i = 0 ; i < M A X _ C O U N T ; i + + )  
       {  
             i f ( i s G o l d ( i , t i m e f r a m e ) ) r e t u r n   i ;  
       }  
  
       r e t u r n   M A X _ C O U N T ; / / �Y�gi = 3 0 0 h�:y�l	g~b0R0�^�NO	gُHNEN؏�l	gё�S�v�`�Q 
   }  
  
   b o o l   i s F i r s t G o l d ( i n t   t i m e f r a m e )  
   {  
       r e t u r n   f i n d F i r s t G o l d ( t i m e f r a m e ) < f i n d F i r s t D e a t h ( t i m e f r a m e ) ;  
   }  
  
   b o o l   i s F i r s t D e a t h ( i n t   t i m e f r a m e )  
   {  
       r e t u r n   f i n d F i r s t D e a t h ( t i m e f r a m e ) < f i n d F i r s t G o l d ( t i m e f r a m e ) ;  
   }  
  
  
   / / �Y�g,{ N*N/fё�Sv^Nё�S(W0 t�KNN 
   b o o l   i s M a c d L o n g ( i n t   t i m e f r a m e )  
   {  
       i f ( i s F i r s t G o l d ( t i m e f r a m e ) )  
       {  
             i n t   i   =   f i n d F i r s t G o l d ( t i m e f r a m e ) ;  
             P r i n t ( " i s M a c d S h o r t : ,{ N*N:Nё�S�MOn(W" , i , "     t i m e f r a m e     " , t i m e f r a m e ) ;  
             r e t u r n   i s B e l o w Z e r o ( i , t i m e f r a m e ) ;  
       }  
       P r i n t ( " i s M a c d S h o r t : m a c d N/fwY" ) ;  
       r e t u r n   f a l s e ;  
   }  
  
   / / �Y�g,{ N*N/f{k�Sv^N{k�S(W0 t�KN
N 
   b o o l   i s M a c d S h o r t ( i n t   t i m e f r a m e )  
   {  
       i f ( i s F i r s t D e a t h ( t i m e f r a m e ) )  
       {  
             i n t   i   =   f i n d F i r s t D e a t h ( t i m e f r a m e ) ;  
             P r i n t ( " i s M a c d S h o r t : ,{ N*N:N{k�S�MOn(W" , i , "     t i m e f r a m e     " , t i m e f r a m e ) ;  
             r e t u r n   i s A b o v e Z e r o ( i , t i m e f r a m e ) ;  
       }  
       P r i n t ( " i s M a c d S h o r t : m a c d N/fwzz" ) ;  
       r e t u r n   f a l s e ;  
   }  
  
    
  
   b o o l   i s M a c d 4 H L o n g ( )  
   {  
       r e t u r n   i s M a c d L o n g ( P E R I O D _ H 4 ) ;  
   }  
  
   b o o l   i s M a c d 4 H S h o r t ( )  
   {  
       r e t u r n   i s M a c d S h o r t ( P E R I O D _ H 4 ) ;  
   }  
 