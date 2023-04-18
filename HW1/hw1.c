#include <stdio.h>

/*  Zachary Rimshnick
	I pledge my honor that I have abided by the Stevens Honor System.
	Sorting Algorithm in task 3: Insertion Sort
	Bonus Points: I would like to be considered for bonus points
*/

void strcpy(char* src, char* dst) {
	// code will copy all characters in src string to dst string
	// only use if-else and goto
	
	// initialize index counter variable i as 0
	int i = 0; 

	// will be the loop that goto returns back to each time goto is called
	loop:                     
		if (src[i] != '\0') {  // run this if statement as long as the char at src index i is not null
			dst[i] = src[i];   // sets destination index i value equal to src index i value
			i++;               // increment index by 1
			goto loop;         // go back to label loop and iterate through again
		} 

}

int dot_prod(char* vec_a, char* vec_b, int length, int size_elem) {
	/*  
		Do not cast the vectors directly, such as
		int* va = (int*)vec_a;
	*/

	int v1, v2;             // initializes the variables that'll hold the values of vector at index i
	int i = 0;              // initializes the index counter variable i as 0
	int current_value = 0;  // initializes the variable for the current value (result) of the function 
	
	formula:                
		// need to cast each element in index i of vector to int variable, and turn the values from char to integers 
		v1 = (int*) vec_a[i];  
		v2 = (int*) vec_b[i];  

		// dot product: the products of the values paired from each index i of vector a and vector b, summed up
		// so this will add a new product of values from the next index to the total on each iteration
		current_value = current_value + (v1 * v2);  

		i = i + size_elem;   // i becomes the next index in the array

		// once the program iterates through entire array/vector, return the dot product value
		if (i == size_elem * length) {
			return current_value;
		} goto formula;      // if program hasn't iterated through entire array/vector, go back to goto label: formula

}

void sort_nib(int* arr, int length) {
	unsigned int new_array[sizeof(arr) * length]; // Inits new array for the individual digits to be stored in 
	unsigned char* p = (char*) arr;               // Unsigned char pointer to nav through old array to get nibbles
	int num_of_nibbles = sizeof(arr[0]) * length; // gets number of nibbles (4 bytes * number of elements in array)
	int z = 0;
	int counter = 0;

	start:        
		// hex is base 16, so to go from decimal to hex, div and find remainder
		new_array[counter] = *(p + z) / 16;       // div decimal by 16 to get initial result
		counter++;
		new_array[counter] = *(p + z) % 16;       // mod 16 to get remainder of prev. result, thus getting the individual hex value 
		counter++;
		z++;
		// repeat until all nibbles are accounted for
		if (z < num_of_nibbles) {
			goto start;
		}

// SORTING ALGORITHM - INSERTION SORT
  	int i, focus, j;
    for (i = 1; i < sizeof(arr)*length; i++) {
        focus = new_array[i];
        j = i - 1;
		printf("");

		// as it loops through, it checks if each element at index i+1 is greater than index i
		// if it is, then that becomes the focus element
		// if its less than, then it is inserted into the correct spot in the sorted portion of the array
        while ((new_array[j] > focus) && (j >= 0) ) {
            new_array[j + 1] = new_array[j];
            j = j - 1;
        }
        new_array[j + 1] = focus;
    } 

/// REPLACE OLD ARRAY WITH NEW
	// need to get array back into intended form (with 3 elements)
	int new_elem;
	int array_index = 0;
	counter = 1;
	z = 0;

	replacement:                    // GOTO LABEL
		new_elem = new_elem + new_array[z]; 
		counter++;
		if(counter == 9) {          // once counter reaches 9, reset it back to 1, fill in index of array with the sorted element, and reset it too
			counter = 1;
			arr[array_index] = new_elem;       
			new_elem = 0;
			array_index++;
		}
		new_elem = new_elem << 4;   // else, left shifts the new_elem by 4 bits to include next digit
		z++;            

		// need to loop back to replacement label until entire array is replaced
		if(z < (sizeof(arr) * length)) { 
			goto replacement;
		}	
}

int main() {

	char str1[]    = "382 is the best!";
	char str2[100] = {0};

	strcpy(str1, str2);
	puts(str1);
	puts(str2);

	int vec_a[3] = {12,34,10};
	int vec_b[3] = {10,20,30};
	int dot      = dot_prod((char*)vec_a, (char*)vec_b, 3, sizeof(int));

	printf("%d\n", dot);

	int arr[3] = {0x12BFDA09, 0x9089CDBA, 0x56788910};  /// should print like this:
	///////////// 0x00011256  0x78889999  0xAABBCDDF

	sort_nib(arr, 3);
	for (int i = 0; i < 3; i++) {
		printf("0x%08x ", arr[i]);
	}
	puts("");
	
	return 0;
}