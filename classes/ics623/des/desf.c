

#include "des.h"

/* The following is the table for selection functions S1 to S8  */
/* Here they are arranged so that you simply use the six-bit    */
/* block in its natural form as the index into the table.       */
/* Note, however, that si in the standard is s[i-1] here.       */

char s[16][64] = {
   {14,  0,  4, 15, 13,  7,  1,  4,  2, 14, 15,  2, 11, 13,  8,  1,
     3, 10, 10,  6,  6, 12, 12, 11,  5,  9,  9,  5,  0,  3,  7,  8,
     4, 15,  1, 12, 14,  8,  8,  2, 13,  4,  6,  9,  2,  1, 11,  7,
    15,  5, 12, 11,  9,  3,  7, 14,  3, 10, 10,  0,  5,  6,  0, 13},
   {15,  3,  1, 13,  8,  4, 14,  7,  6, 15, 11,  2,  3,  8,  4, 14, 
     9, 12,  7,  0,  2,  1, 13, 10, 12,  6,  0,  9,  5, 11, 10,  5, 
     0, 13, 14,  8,  7, 10, 11,  1, 10,  3,  4, 15, 13,  4,  1,  2,
     5, 11,  8,  6, 12,  7,  6, 12,  9,  0,  3,  5,  2, 14, 15,  9},
   {10, 13,  0,  7,  9,  0, 14,  9,  6,  3,  3,  4, 15,  6,  5, 10,
     1,  2, 13,  8, 12,  5,  7, 14, 11, 12,  4, 11,  2, 15,  8,  1, 
    13,  1,  6, 10,  4, 13,  9,  0,  8,  6, 15,  9,  3,  8,  0,  7,
    11,  4,  1, 15,  2, 14, 12,  3,  5, 11, 10,  5, 14,  2,  7, 12},
   { 7, 13, 13,  8, 14, 11,  3,  5,  0,  6,  6, 15,  9,  0, 10,  3,
     1,  4,  2,  7,  8,  2,  5, 12, 11,  1, 12, 10,  4, 14, 15,  9,
    10,  3,  6, 15,  9,  0,  0,  6, 12, 10, 11,  1,  7, 13, 13,  8,
    15,  9,  1,  4,  3,  5, 14, 11,  5, 12,  2,  7,  8,  2,  4, 14},
   { 2, 14, 12, 11,  4,  2,  1, 12,  7,  4, 10,  7, 11, 13,  6,  1, 
     8,  5,  5,  0,  3, 15, 15, 10, 13,  3,  0,  9, 14,  8,  9,  6,
     4, 11,  2,  8,  1, 12, 11,  7, 10,  1, 13, 14,  7,  2,  8, 13,
    15,  6,  9, 15, 12,  0,  5,  9,  6, 10,  3,  4,  0,  5, 14,  3},
   {12, 10,  1, 15, 10,  4, 15,  2,  9,  7,  2, 12,  6,  9,  8,  5, 
     0,  6, 13,  1,  3, 13,  4, 14, 14,  0,  7, 11,  5,  3, 11,  8,
     9,  4, 14,  3, 15,  2,  5, 12,  2,  9,  8,  5, 12, 15,  3, 10, 
     7, 11,  0, 14,  4,  1, 10,  7,  1,  6, 13,  0, 11,  8,  6, 13},
   { 4, 13, 11,  0,  2, 11, 14,  7, 15,  4,  0,  9,  8,  1, 13, 10,
     3, 14, 12,  3,  9,  5,  7, 12,  5,  2, 10, 15,  6,  8,  1,  6,
     1,  6,  4, 11, 11, 13, 13,  8, 12,  1,  3,  4,  7, 10, 14,  7, 
    10,  9, 15,  5,  6,  0,  8, 15,  0, 14,  5,  2,  9,  3,  2, 12},
   {13,  1,  2, 15,  8, 13,  4,  8,  6, 10, 15,  3, 11,  7,  1,  4, 
    10, 12,  9,  5,  3,  6, 14, 11,  5,  0,  0, 14, 12,  9,  7,  2,
     7,  2, 11,  1,  4, 14,  1,  7,  9,  4, 12, 10, 14,  8,  2, 13, 
     0, 15,  6, 12, 10,  9, 13,  0, 15,  3,  3,  5,  5,  6,  8, 11}  };

/* This procedure does the initial permutation on 64 bits */
/* in two 32 bit words, li and ri, and puts the result in */
/* lo and ro. There is one line per bit. Note that the    */
/* parameters are li and ri for input and pointers to lo  */
/* and ro for output.                                     */

void ip(unsigned long li, unsigned long ri, 
        unsigned long *lo, unsigned long *ro)
{
   *lo = 0;
   *ro = 0;
   *lo |= (ri & 0x00000040) << 25;   /*  out01 <- in58  */
   *lo |= (ri & 0x00004000) << 16;   /*  out02 <- in50  */
   *lo |= (ri & 0x00400000) <<  7;   /*  out03 <- in42  */
   *lo |= (ri & 0x40000000) >>  2;   /*  out04 <- in34  */
   *lo |= (li & 0x00000040) << 21;   /*  out05 <- in26  */
   *lo |= (li & 0x00004000) << 12;   /*  out06 <- in18  */
   *lo |= (li & 0x00400000) <<  3;   /*  out07 <- in10  */
   *lo |= (li & 0x40000000) >>  6;   /*  out08 <- in02  */
   *lo |= (ri & 0x00000010) << 19;   /*  out09 <- in60  */
   *lo |= (ri & 0x00001000) << 10;   /*  out10 <- in52  */
   *lo |= (ri & 0x00100000) <<  1;   /*  out11 <- in44  */
   *lo |= (ri & 0x10000000) >>  8;   /*  out12 <- in36  */
   *lo |= (li & 0x00000010) << 15;   /*  out13 <- in28  */
   *lo |= (li & 0x00001000) <<  6;   /*  out14 <- in20  */
   *lo |= (li & 0x00100000) >>  3;   /*  out15 <- in12  */
   *lo |= (li & 0x10000000) >> 12;   /*  out16 <- in04  */
   *lo |= (ri & 0x00000004) << 13;   /*  out17 <- in62  */
   *lo |= (ri & 0x00000400) <<  4;   /*  out18 <- in54  */
   *lo |= (ri & 0x00040000) >>  5;   /*  out19 <- in46  */
   *lo |= (ri & 0x04000000) >> 14;   /*  out20 <- in38  */
   *lo |= (li & 0x00000004) <<  9;   /*  out21 <- in30  */
   *lo |= (li & 0x00000400);         /*  out22 <- in22  */
   *lo |= (li & 0x00040000) >>  9;   /*  out23 <- in14  */
   *lo |= (li & 0x04000000) >> 18;   /*  out24 <- in06  */
   *lo |= (ri & 0x00000001) <<  7;   /*  out25 <- in64  */
   *lo |= (ri & 0x00000100) >>  2;   /*  out26 <- in56  */
   *lo |= (ri & 0x00010000) >> 11;   /*  out27 <- in48  */
   *lo |= (ri & 0x01000000) >> 20;   /*  out28 <- in40  */
   *lo |= (li & 0x00000001) <<  3;   /*  out29 <- in32  */
   *lo |= (li & 0x00000100) >>  6;   /*  out30 <- in24  */
   *lo |= (li & 0x00010000) >> 15;   /*  out31 <- in16  */
   *lo |= (li & 0x01000000) >> 24;   /*  out32 <- in08  */
   *ro |= (ri & 0x00000080) << 24;   /*  out33 <- in57  */
   *ro |= (ri & 0x00008000) << 15;   /*  out34 <- in49  */
   *ro |= (ri & 0x00800000) <<  6;   /*  out35 <- in41  */
   *ro |= (ri & 0x80000000) >>  3;   /*  out36 <- in33  */
   *ro |= (li & 0x00000080) << 20;   /*  out37 <- in25  */
   *ro |= (li & 0x00008000) << 11;   /*  out38 <- in17  */
   *ro |= (li & 0x00800000) <<  2;   /*  out39 <- in09  */
   *ro |= (li & 0x80000000) >>  7;   /*  out40 <- in01  */
   *ro |= (ri & 0x00000020) << 18;   /*  out41 <- in59  */
   *ro |= (ri & 0x00002000) <<  9;   /*  out42 <- in51  */
   *ro |= (ri & 0x00200000);         /*  out43 <- in43  */
   *ro |= (ri & 0x20000000) >>  9;   /*  out44 <- in35  */
   *ro |= (li & 0x00000020) << 14;   /*  out45 <- in27  */
   *ro |= (li & 0x00002000) <<  5;   /*  out46 <- in19  */
   *ro |= (li & 0x00200000) >>  4;   /*  out47 <- in11  */
   *ro |= (li & 0x20000000) >> 13;   /*  out48 <- in03  */
   *ro |= (ri & 0x00000008) << 12;   /*  out49 <- in61  */
   *ro |= (ri & 0x00000800) <<  3;   /*  out50 <- in53  */
   *ro |= (ri & 0x00080000) >>  6;   /*  out51 <- in45  */
   *ro |= (ri & 0x08000000) >> 15;   /*  out52 <- in37  */
   *ro |= (li & 0x00000008) <<  8;   /*  out53 <- in29  */
   *ro |= (li & 0x00000800) >>  1;   /*  out54 <- in21  */
   *ro |= (li & 0x00080000) >> 10;   /*  out55 <- in13  */
   *ro |= (li & 0x08000000) >> 19;   /*  out56 <- in05  */
   *ro |= (ri & 0x00000002) <<  6;   /*  out57 <- in63  */
   *ro |= (ri & 0x00000200) >>  3;   /*  out58 <- in55  */
   *ro |= (ri & 0x00020000) >> 12;   /*  out59 <- in47  */
   *ro |= (ri & 0x02000000) >> 21;   /*  out60 <- in39  */
   *ro |= (li & 0x00000002) <<  2;   /*  out61 <- in31  */
   *ro |= (li & 0x00000200) >>  7;   /*  out62 <- in23  */
   *ro |= (li & 0x00020000) >> 16;   /*  out63 <- in15  */
   *ro |= (li & 0x02000000) >> 25;   /*  out64 <- in07  */
}

/* This procedure does the final permutation on 64 bits   */
/* in two 32 bit words, li and ri, and puts the result in */
/* lo and ro. There is one line per bit. Note that the    */
/* parameters are li and ri for input and pointers to lo  */
/* and ro for output.                                     */

void ipinv(unsigned long li, unsigned long ri, 
           unsigned long *lo, unsigned long *ro)
{
   *lo = 0;
   *ro = 0;
   *lo |= (ri & 0x01000000) <<  7;   /*  out01 <- in40  */
   *lo |= (li & 0x01000000) <<  6;   /*  out02 <- in08  */
   *lo |= (ri & 0x00010000) << 13;   /*  out03 <- in48  */
   *lo |= (li & 0x00010000) << 12;   /*  out04 <- in16  */
   *lo |= (ri & 0x00000100) << 19;   /*  out05 <- in56  */
   *lo |= (li & 0x00000100) << 18;   /*  out06 <- in24  */
   *lo |= (ri & 0x00000001) << 25;   /*  out07 <- in64  */
   *lo |= (li & 0x00000001) << 24;   /*  out08 <- in32  */
   *lo |= (ri & 0x02000000) >>  2;   /*  out09 <- in39  */
   *lo |= (li & 0x02000000) >>  3;   /*  out10 <- in07  */
   *lo |= (ri & 0x00020000) <<  4;   /*  out11 <- in47  */
   *lo |= (li & 0x00020000) <<  3;   /*  out12 <- in15  */
   *lo |= (ri & 0x00000200) << 10;   /*  out13 <- in55  */
   *lo |= (li & 0x00000200) <<  9;   /*  out14 <- in23  */
   *lo |= (ri & 0x00000002) << 16;   /*  out15 <- in63  */
   *lo |= (li & 0x00000002) << 15;   /*  out16 <- in31  */
   *lo |= (ri & 0x04000000) >> 11;   /*  out17 <- in38  */
   *lo |= (li & 0x04000000) >> 12;   /*  out18 <- in06  */
   *lo |= (ri & 0x00040000) >>  5;   /*  out19 <- in46  */
   *lo |= (li & 0x00040000) >>  6;   /*  out20 <- in14  */
   *lo |= (ri & 0x00000400) <<  1;   /*  out21 <- in54  */
   *lo |= (li & 0x00000400);         /*  out22 <- in22  */
   *lo |= (ri & 0x00000004) <<  7;   /*  out23 <- in62  */
   *lo |= (li & 0x00000004) <<  6;   /*  out24 <- in30  */
   *lo |= (ri & 0x08000000) >> 20;   /*  out25 <- in37  */
   *lo |= (li & 0x08000000) >> 21;   /*  out26 <- in05  */
   *lo |= (ri & 0x00080000) >> 14;   /*  out27 <- in45  */
   *lo |= (li & 0x00080000) >> 15;   /*  out28 <- in13  */
   *lo |= (ri & 0x00000800) >>  8;   /*  out29 <- in53  */
   *lo |= (li & 0x00000800) >>  9;   /*  out30 <- in21  */
   *lo |= (ri & 0x00000008) >>  2;   /*  out31 <- in61  */
   *lo |= (li & 0x00000008) >>  3;   /*  out32 <- in29  */
   *ro |= (ri & 0x10000000) <<  3;   /*  out33 <- in36  */
   *ro |= (li & 0x10000000) <<  2;   /*  out34 <- in04  */
   *ro |= (ri & 0x00100000) <<  9;   /*  out35 <- in44  */
   *ro |= (li & 0x00100000) <<  8;   /*  out36 <- in12  */
   *ro |= (ri & 0x00001000) << 15;   /*  out37 <- in52  */
   *ro |= (li & 0x00001000) << 14;   /*  out38 <- in20  */
   *ro |= (ri & 0x00000010) << 21;   /*  out39 <- in60  */
   *ro |= (li & 0x00000010) << 20;   /*  out40 <- in28  */
   *ro |= (ri & 0x20000000) >>  6;   /*  out41 <- in35  */
   *ro |= (li & 0x20000000) >>  7;   /*  out42 <- in03  */
   *ro |= (ri & 0x00200000);         /*  out43 <- in43  */
   *ro |= (li & 0x00200000) >>  1;   /*  out44 <- in11  */
   *ro |= (ri & 0x00002000) <<  6;   /*  out45 <- in51  */
   *ro |= (li & 0x00002000) <<  5;   /*  out46 <- in19  */
   *ro |= (ri & 0x00000020) << 12;   /*  out47 <- in59  */
   *ro |= (li & 0x00000020) << 11;   /*  out48 <- in27  */
   *ro |= (ri & 0x40000000) >> 15;   /*  out49 <- in34  */
   *ro |= (li & 0x40000000) >> 16;   /*  out50 <- in02  */
   *ro |= (ri & 0x00400000) >>  9;   /*  out51 <- in42  */
   *ro |= (li & 0x00400000) >> 10;   /*  out52 <- in10  */
   *ro |= (ri & 0x00004000) >>  3;   /*  out53 <- in50  */
   *ro |= (li & 0x00004000) >>  4;   /*  out54 <- in18  */
   *ro |= (ri & 0x00000040) <<  3;   /*  out55 <- in58  */
   *ro |= (li & 0x00000040) <<  2;   /*  out56 <- in26  */
   *ro |= (ri & 0x80000000) >> 24;   /*  out57 <- in33  */
   *ro |= (li & 0x80000000) >> 25;   /*  out58 <- in01  */
   *ro |= (ri & 0x00800000) >> 18;   /*  out59 <- in41  */
   *ro |= (li & 0x00800000) >> 19;   /*  out60 <- in09  */
   *ro |= (ri & 0x00008000) >> 12;   /*  out61 <- in49  */
   *ro |= (li & 0x00008000) >> 13;   /*  out62 <- in17  */
   *ro |= (ri & 0x00000080) >>  6;   /*  out63 <- in57  */
   *ro |= (li & 0x00000080) >>  7;   /*  out64 <- in25  */
}


/*  This procedure does bit selection E, putting the result  */
/*  as two words, lo and ro, with 24 bits in each, placed at */
/*  the left of the 32-bit result, with 8 zeros at the right.*/
/*  Note that the parameters are 32-bit ri for input and     */
/*  pointers to lo and ro for output.                        */

void e(unsigned long ri, unsigned long *lo, unsigned long *ro)
{
   *lo = 0;
   *ro = 0;
   *lo |= (ri & 0x00000001) << 31;   /*  out01 <- in32  */
   *lo |= (ri & 0x80000000) >>  1;   /*  out02 <- in01  */
   *lo |= (ri & 0x40000000) >>  1;   /*  out03 <- in02  */
   *lo |= (ri & 0x20000000) >>  1;   /*  out04 <- in03  */
   *lo |= (ri & 0x10000000) >>  1;   /*  out05 <- in04  */
   *lo |= (ri & 0x08000000) >>  1;   /*  out06 <- in05  */
   *lo |= (ri & 0x10000000) >>  3;   /*  out07 <- in04  */
   *lo |= (ri & 0x08000000) >>  3;   /*  out08 <- in05  */
   *lo |= (ri & 0x04000000) >>  3;   /*  out09 <- in06  */
   *lo |= (ri & 0x02000000) >>  3;   /*  out10 <- in07  */
   *lo |= (ri & 0x01000000) >>  3;   /*  out11 <- in08  */
   *lo |= (ri & 0x00800000) >>  3;   /*  out12 <- in09  */
   *lo |= (ri & 0x01000000) >>  5;   /*  out13 <- in08  */
   *lo |= (ri & 0x00800000) >>  5;   /*  out14 <- in09  */
   *lo |= (ri & 0x00400000) >>  5;   /*  out15 <- in10  */
   *lo |= (ri & 0x00200000) >>  5;   /*  out16 <- in11  */
   *lo |= (ri & 0x00100000) >>  5;   /*  out17 <- in12  */
   *lo |= (ri & 0x00080000) >>  5;   /*  out18 <- in13  */
   *lo |= (ri & 0x00100000) >>  7;   /*  out19 <- in12  */
   *lo |= (ri & 0x00080000) >>  7;   /*  out20 <- in13  */
   *lo |= (ri & 0x00040000) >>  7;   /*  out21 <- in14  */
   *lo |= (ri & 0x00020000) >>  7;   /*  out22 <- in15  */
   *lo |= (ri & 0x00010000) >>  7;   /*  out23 <- in16  */
   *lo |= (ri & 0x00008000) >>  7;   /*  out24 <- in17  */
   *ro |= (ri & 0x00010000) << 15;   /*  out25 <- in16  */
   *ro |= (ri & 0x00008000) << 15;   /*  out26 <- in17  */
   *ro |= (ri & 0x00004000) << 15;   /*  out27 <- in18  */
   *ro |= (ri & 0x00002000) << 15;   /*  out28 <- in19  */
   *ro |= (ri & 0x00001000) << 15;   /*  out29 <- in20  */
   *ro |= (ri & 0x00000800) << 15;   /*  out30 <- in21  */
   *ro |= (ri & 0x00001000) << 13;   /*  out31 <- in20  */
   *ro |= (ri & 0x00000800) << 13;   /*  out32 <- in21  */
   *ro |= (ri & 0x00000400) << 13;   /*  out33 <- in22  */
   *ro |= (ri & 0x00000200) << 13;   /*  out34 <- in23  */
   *ro |= (ri & 0x00000100) << 13;   /*  out35 <- in24  */
   *ro |= (ri & 0x00000080) << 13;   /*  out36 <- in25  */
   *ro |= (ri & 0x00000100) << 11;   /*  out37 <- in24  */
   *ro |= (ri & 0x00000080) << 11;   /*  out38 <- in25  */
   *ro |= (ri & 0x00000040) << 11;   /*  out39 <- in26  */
   *ro |= (ri & 0x00000020) << 11;   /*  out40 <- in27  */
   *ro |= (ri & 0x00000010) << 11;   /*  out41 <- in28  */
   *ro |= (ri & 0x00000008) << 11;   /*  out42 <- in29  */
   *ro |= (ri & 0x00000010) <<  9;   /*  out43 <- in28  */
   *ro |= (ri & 0x00000008) <<  9;   /*  out44 <- in29  */
   *ro |= (ri & 0x00000004) <<  9;   /*  out45 <- in30  */
   *ro |= (ri & 0x00000002) <<  9;   /*  out46 <- in31  */
   *ro |= (ri & 0x00000001) <<  9;   /*  out47 <- in32  */
   *ro |= (ri & 0x80000000) >> 23;   /*  out48 <- in01  */
}

/* This procedure does the permutation P on 32 bit word   */
/* li and puts the result in lo. Note that the parameter  */
/* is the input li and the result is retured as the       */
/* as the function value.                                 */

unsigned long p(unsigned long li)
{
   unsigned long lo;

   lo = 0;
   lo |= (li & 0x00010000) << 15;   /*  out01 <- in16  */
   lo |= (li & 0x02000000) <<  5;   /*  out02 <- in07  */
   lo |= (li & 0x00001000) << 17;   /*  out03 <- in20  */
   lo |= (li & 0x00000800) << 17;   /*  out04 <- in21  */
   lo |= (li & 0x00000008) << 24;   /*  out05 <- in29  */
   lo |= (li & 0x00100000) <<  6;   /*  out06 <- in12  */
   lo |= (li & 0x00000010) << 21;   /*  out07 <- in28  */
   lo |= (li & 0x00008000) <<  9;   /*  out08 <- in17  */
   lo |= (li & 0x80000000) >>  8;   /*  out09 <- in01  */
   lo |= (li & 0x00020000) <<  5;   /*  out10 <- in15  */
   lo |= (li & 0x00000200) << 12;   /*  out11 <- in23  */
   lo |= (li & 0x00000040) << 14;   /*  out12 <- in26  */
   lo |= (li & 0x08000000) >>  8;   /*  out13 <- in05  */
   lo |= (li & 0x00004000) <<  4;   /*  out14 <- in18  */
   lo |= (li & 0x00000002) << 16;   /*  out15 <- in31  */
   lo |= (li & 0x00400000) >>  6;   /*  out16 <- in10  */
   lo |= (li & 0x40000000) >> 15;   /*  out17 <- in02  */
   lo |= (li & 0x01000000) >> 10;   /*  out18 <- in08  */
   lo |= (li & 0x00000100) <<  5;   /*  out19 <- in24  */
   lo |= (li & 0x00040000) >>  6;   /*  out20 <- in14  */
   lo |= (li & 0x00000001) << 11;   /*  out21 <- in32  */
   lo |= (li & 0x00000020) <<  5;   /*  out22 <- in27  */
   lo |= (li & 0x20000000) >> 20;   /*  out23 <- in03  */
   lo |= (li & 0x00800000) >> 15;   /*  out24 <- in09  */
   lo |= (li & 0x00002000) >>  6;   /*  out25 <- in19  */
   lo |= (li & 0x00080000) >> 13;   /*  out26 <- in13  */
   lo |= (li & 0x00000004) <<  3;   /*  out27 <- in30  */
   lo |= (li & 0x04000000) >> 22;   /*  out28 <- in06  */
   lo |= (li & 0x00000400) >>  7;   /*  out29 <- in22  */
   lo |= (li & 0x00200000) >> 19;   /*  out30 <- in11  */
   lo |= (li & 0x10000000) >> 27;   /*  out31 <- in04  */
   lo |= (li & 0x00000080) >>  7;   /*  out32 <- in25  */
   return lo;
}


/* This procedure does the "permutation" PC-1 on 64 bits  */
/* in two 32 bit words, li and ri, and puts the 56-bit    */
/* result in lo and ro, 28 bits in each, at the left of   */
/* the 32-bit result, with 4 zeros at the right. Note     */
/* that the parameters are li and ri for input and        */
/* pointers to lo and ro for output.                      */

void pc1(unsigned long li, unsigned long ri, 
         unsigned long *lo, unsigned long *ro)
{
   *lo = 0;
   *ro = 0;
   *lo |= (ri & 0x00000080) << 24;   /*  out01 <- in57  */
   *lo |= (ri & 0x00008000) << 15;   /*  out02 <- in49  */
   *lo |= (ri & 0x00800000) <<  6;   /*  out03 <- in41  */
   *lo |= (ri & 0x80000000) >>  3;   /*  out04 <- in33  */
   *lo |= (li & 0x00000080) << 20;   /*  out05 <- in25  */
   *lo |= (li & 0x00008000) << 11;   /*  out06 <- in17  */
   *lo |= (li & 0x00800000) <<  2;   /*  out07 <- in09  */
   *lo |= (li & 0x80000000) >>  7;   /*  out08 <- in01  */
   *lo |= (ri & 0x00000040) << 17;   /*  out09 <- in58  */
   *lo |= (ri & 0x00004000) <<  8;   /*  out10 <- in50  */
   *lo |= (ri & 0x00400000) >>  1;   /*  out11 <- in42  */
   *lo |= (ri & 0x40000000) >> 10;   /*  out12 <- in34  */
   *lo |= (li & 0x00000040) << 13;   /*  out13 <- in26  */
   *lo |= (li & 0x00004000) <<  4;   /*  out14 <- in18  */
   *lo |= (li & 0x00400000) >>  5;   /*  out15 <- in10  */
   *lo |= (li & 0x40000000) >> 14;   /*  out16 <- in02  */
   *lo |= (ri & 0x00000020) << 10;   /*  out17 <- in59  */
   *lo |= (ri & 0x00002000) <<  1;   /*  out18 <- in51  */
   *lo |= (ri & 0x00200000) >>  8;   /*  out19 <- in43  */
   *lo |= (ri & 0x20000000) >> 17;   /*  out20 <- in35  */
   *lo |= (li & 0x00000020) <<  6;   /*  out21 <- in27  */
   *lo |= (li & 0x00002000) >>  3;   /*  out22 <- in19  */
   *lo |= (li & 0x00200000) >> 12;   /*  out23 <- in11  */
   *lo |= (li & 0x20000000) >> 21;   /*  out24 <- in03  */
   *lo |= (ri & 0x00000010) <<  3;   /*  out25 <- in60  */
   *lo |= (ri & 0x00001000) >>  6;   /*  out26 <- in52  */
   *lo |= (ri & 0x00100000) >> 15;   /*  out27 <- in44  */
   *lo |= (ri & 0x10000000) >> 24;   /*  out28 <- in36  */
   *ro |= (ri & 0x00000002) << 30;   /*  out29 <- in63  */
   *ro |= (ri & 0x00000200) << 21;   /*  out30 <- in55  */
   *ro |= (ri & 0x00020000) << 12;   /*  out31 <- in47  */
   *ro |= (ri & 0x02000000) <<  3;   /*  out32 <- in39  */
   *ro |= (li & 0x00000002) << 26;   /*  out33 <- in31  */
   *ro |= (li & 0x00000200) << 17;   /*  out34 <- in23  */
   *ro |= (li & 0x00020000) <<  8;   /*  out35 <- in15  */
   *ro |= (li & 0x02000000) >>  1;   /*  out36 <- in07  */
   *ro |= (ri & 0x00000004) << 21;   /*  out37 <- in62  */
   *ro |= (ri & 0x00000400) << 12;   /*  out38 <- in54  */
   *ro |= (ri & 0x00040000) <<  3;   /*  out39 <- in46  */
   *ro |= (ri & 0x04000000) >>  6;   /*  out40 <- in38  */
   *ro |= (li & 0x00000004) << 17;   /*  out41 <- in30  */
   *ro |= (li & 0x00000400) <<  8;   /*  out42 <- in22  */
   *ro |= (li & 0x00040000) >>  1;   /*  out43 <- in14  */
   *ro |= (li & 0x04000000) >> 10;   /*  out44 <- in06  */
   *ro |= (ri & 0x00000008) << 12;   /*  out45 <- in61  */
   *ro |= (ri & 0x00000800) <<  3;   /*  out46 <- in53  */
   *ro |= (ri & 0x00080000) >>  6;   /*  out47 <- in45  */
   *ro |= (ri & 0x08000000) >> 15;   /*  out48 <- in37  */
   *ro |= (li & 0x00000008) <<  8;   /*  out49 <- in29  */
   *ro |= (li & 0x00000800) >>  1;   /*  out50 <- in21  */
   *ro |= (li & 0x00080000) >> 10;   /*  out51 <- in13  */
   *ro |= (li & 0x08000000) >> 19;   /*  out52 <- in05  */
   *ro |= (li & 0x00000010) <<  3;   /*  out53 <- in28  */
   *ro |= (li & 0x00001000) >>  6;   /*  out54 <- in20  */
   *ro |= (li & 0x00100000) >> 15;   /*  out55 <- in12  */
   *ro |= (li & 0x10000000) >> 24;   /*  out56 <- in04  */
}


/* This procedure does the "permutation" PC-2 on 56 bits  */
/* in two 32 bit words, li and ri with 28 bits in each,   */
/* and puts the 48-bit result in lo and ro, with 24 bits  */
/* in each. There is one line per bit in the program.     */
/* Note that the parameters are li and ri for input and   */
/* pointers to lo and ro for output, and both for the     */
/* input and the output, the data is at the left of the   */
/* 32-bit word and zeros are filled in at the right.      */


void pc2(unsigned long li, unsigned long ri, 
         unsigned long *lo, unsigned long *ro)
{
   *lo = 0;
   *ro = 0;
   *lo |= (li & 0x00040000) << 13;   /*  out01 <- in14  */
   *lo |= (li & 0x00008000) << 15;   /*  out02 <- in17  */
   *lo |= (li & 0x00200000) <<  8;   /*  out03 <- in11  */
   *lo |= (li & 0x00000100) << 20;   /*  out04 <- in24  */
   *lo |= (li & 0x80000000) >>  4;   /*  out05 <- in01  */
   *lo |= (li & 0x08000000) >>  1;   /*  out06 <- in05  */
   *lo |= (li & 0x20000000) >>  4;   /*  out07 <- in03  */
   *lo |= (li & 0x00000010) << 20;   /*  out08 <- in28  */
   *lo |= (li & 0x00020000) <<  6;   /*  out09 <- in15  */
   *lo |= (li & 0x04000000) >>  4;   /*  out10 <- in06  */
   *lo |= (li & 0x00000800) << 10;   /*  out11 <- in21  */
   *lo |= (li & 0x00400000) >>  2;   /*  out12 <- in10  */
   *lo |= (li & 0x00000200) << 10;   /*  out13 <- in23  */
   *lo |= (li & 0x00002000) <<  5;   /*  out14 <- in19  */
   *lo |= (li & 0x00100000) >>  3;   /*  out15 <- in12  */
   *lo |= (li & 0x10000000) >> 12;   /*  out16 <- in04  */
   *lo |= (li & 0x00000040) <<  9;   /*  out17 <- in26  */
   *lo |= (li & 0x01000000) >> 10;   /*  out18 <- in08  */
   *lo |= (li & 0x00010000) >>  3;   /*  out19 <- in16  */
   *lo |= (li & 0x02000000) >> 13;   /*  out20 <- in07  */
   *lo |= (li & 0x00000020) <<  6;   /*  out21 <- in27  */
   *lo |= (li & 0x00001000) >>  2;   /*  out22 <- in20  */
   *lo |= (li & 0x00080000) >> 10;   /*  out23 <- in13  */
   *lo |= (li & 0x40000000) >> 22;   /*  out24 <- in02  */
   *ro |= (ri & 0x00080000) << 12;   /*  out25 <- in41  */
   *ro |= (ri & 0x00000100) << 22;   /*  out26 <- in52  */
   *ro |= (ri & 0x20000000);         /*  out27 <- in31  */
   *ro |= (ri & 0x00800000) <<  5;   /*  out28 <- in37  */
   *ro |= (ri & 0x00002000) << 14;   /*  out29 <- in47  */
   *ro |= (ri & 0x00000020) << 21;   /*  out30 <- in55  */
   *ro |= (ri & 0x40000000) >>  5;   /*  out31 <- in30  */
   *ro |= (ri & 0x00100000) <<  4;   /*  out32 <- in40  */
   *ro |= (ri & 0x00000200) << 14;   /*  out33 <- in51  */
   *ro |= (ri & 0x00008000) <<  7;   /*  out34 <- in45  */
   *ro |= (ri & 0x08000000) >>  6;   /*  out35 <- in33  */
   *ro |= (ri & 0x00001000) <<  8;   /*  out36 <- in48  */
   *ro |= (ri & 0x00010000) <<  3;   /*  out37 <- in44  */
   *ro |= (ri & 0x00000800) <<  7;   /*  out38 <- in49  */
   *ro |= (ri & 0x00200000) >>  4;   /*  out39 <- in39  */
   *ro |= (ri & 0x00000010) << 12;   /*  out40 <- in56  */
   *ro |= (ri & 0x04000000) >> 11;   /*  out41 <- in34  */
   *ro |= (ri & 0x00000080) <<  7;   /*  out42 <- in53  */
   *ro |= (ri & 0x00004000) >>  1;   /*  out43 <- in46  */
   *ro |= (ri & 0x00040000) >>  6;   /*  out44 <- in42  */
   *ro |= (ri & 0x00000400) <<  1;   /*  out45 <- in50  */
   *ro |= (ri & 0x01000000) >> 14;   /*  out46 <- in36  */
   *ro |= (ri & 0x80000000) >> 22;   /*  out47 <- in29  */
   *ro |= (ri & 0x10000000) >> 20;   /*  out48 <- in32  */
}
