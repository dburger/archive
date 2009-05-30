#include "huffman.h"

/*                                                                  
    fileroutines.c created for ICS 212 by                           
    David J. Burger.                                                
    This file contains functions designed to                        
    be used in routines concerning files.                           

    Creation date:  01/28/01
    Last Modified:  02/10/01 */

/* a modified bubblesort routine, modified to accept                
   a second array that it performs the same swaps on                
   while it sorts according to the values in the first              
   array. This bubble sort sorts in descending order.
   Input:  the integer array to be sorted a[], a
           corresponding integer array b[], and the
           number of items in the array n
   Output: array a[] is sorted in descending order
           with identical swaps performed on array
           b[] */            
void modBubbleSort(int a[], int b[], int n) {                       
                                                                    
    int sorted = 0;                                                 
    int i, pass, temp;                                              
                                                                    
    for (pass=1;(pass<n) && !sorted;++pass) {                       
        sorted = 1;                                                 
        for (i=0;i<n-pass;i++)                                      
          if (a[i]<a[i+1]) {                                        
                temp = a[i];                                        
                a[i] = a[i+1];                                      
                a[i+1] = temp;                                      
                                                                    
                temp = b[i];                                        
                b[i] = b[i+1];                                      
                b[i+1] = temp;                                      
                sorted = 0;                                         
          }                                                         
    }                                                               
}                                                                       

/* this function computes the bytecount of a file
   which is a frequency count of the bytes in a
   file.
   Input:  the filename of the file to compute the
           the bytecount on, int arrays b[] and s[]
           of size 256
   Output: array b[] contains the descending frequency
           count with the corresponding ascii character
           in array s[] */               
void freqCount(char *filename, int b[], int s[]) {                   
                                                                    
    int c, i, nchars=0;                                             
    FILE *fp;                                                       
                                                                    
    /* attempt to open the source file */                           
    fp = fopen(filename, "rb");                                     
    if (fp==NULL) {                                                 
        printf("Could not open %s.\n",filename);
        exit(0);                                                    
    }                                                               
                                                                    
    /* initialize the arrays */                                     
    for (i=0;i<256;i++) {
        b[i]=0;                                     
        s[i]=i;
    }                                     
                                                                    
    /* read the character data and keep track in b */               
    while((c=getc(fp))!=EOF) {                                      
        b[c]++;                                                     
        nchars++;                                                   
    }                                                               
                                                                    
    fclose(fp);                                                     
                                                                    
    /* sort the array of byte counts and perform the same swaps     
       on array s to keep track of which byte value has what count */
    modBubbleSort(b,s,256);                                         
                                                                    
}








