#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct Vectors {
    size_t size;
    char **buffer;
    int index;
} Vector;

int main() {
    FILE *file = fopen("day-1-part-1-input.txt", "rb" );
    size_t file_length;
    char* input_string = 0;
    if(file == NULL) {
        perror("Error opening file");
        return(-1);
    }

    fseek(file, 0, SEEK_END);
    file_length = ftell(file);
    fseek(file, 0, SEEK_SET);
    input_string = malloc(file_length);
    if (input_string) {
        fread(input_string, 1, file_length, file);
    }

    Vector elves;
    elves.size = 8192;
    elves.buffer = malloc(elves.size);
    elves.index = 0;
    // Split input_string into substrings
    int last = 0;
    int input_string_char_index = 0;
    while(input_string_char_index < file_length) {
        input_string_char_index++;
        if(
            input_string[input_string_char_index] == '\n' && 
            ((input_string_char_index + 1) < file_length) && input_string[input_string_char_index + 1] == '\n'
        ) {
            
            elves.buffer[elves.index] = (char*)malloc(input_string_char_index - last + 2);
            for(int j = 0; (last + j) < input_string_char_index; j++) {
                elves.buffer[elves.index][j] = input_string[j + last];
            }

            elves.buffer[elves.index][input_string_char_index - last] = '\n';
            elves.buffer[elves.index][input_string_char_index - last + 1] = '\0';

            elves.index++;
            if(elves.index > elves.size) {
                elves.size = elves.size * 2;
                int *result = (int*)realloc(elves.buffer, elves.size);
                
                if(result == NULL) {
                    perror("Error in realloc");
                    return(-1);
                }
            }

            while (input_string[input_string_char_index] == '\n') {
                input_string_char_index++;
            }
            last = input_string_char_index;
        } 
    }

    int largest = 0;
    for(int j = 0; j < elves.index; j++ ) {
        char* token;
        char* s = malloc(strlen(elves.buffer[j])+ 1);
        strcpy(s, elves.buffer[j]);
        token = strtok(s, "\n\0");
        int total = 0;

        /* walk through other tokens */
        while( token != NULL ) {         
            total = total + atoi(token);
            token = strtok(NULL, "\n\0");
        }

        if(total > largest) {
            largest = total;
            
        }
        
    }

   printf("%d\n", largest);
   return 0;
}
