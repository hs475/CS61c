/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				Changwei Jing
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	//YOUR CODE HERE
	int numr = 0, numg = 0, numb = 0, tmpcol, tmprow;
	int bitr = image->image[row][col].R & 1;
	int bitg = image->image[row][col].G & 1;
	int bitb = image->image[row][col].B & 1;
	Color* res = malloc(sizeof(Color));
	for (int i = -1; i < 2; ++i) {
		tmprow = (image->rows + row - 1) % image->rows;
		tmpcol = (image->cols + col + i) % image->cols;
		if (image->image[tmprow][tmpcol].R) numr++;
		if (image->image[tmprow][tmpcol].G) numg++;
		if (image->image[tmprow][tmpcol].B) numb++;
	}
	for (int i = -1; i < 2; i += 2) {
		tmpcol = (image->cols + col + i) % image->cols;
		if (image->image[row][tmpcol].R) numr++;
		if (image->image[row][tmpcol].G) numg++;
		if (image->image[row][tmpcol].B) numb++;
	}
	for (int i = -1; i < 2; ++i) {
		tmprow = (image->rows + row + 1) % image->rows;
		tmpcol = (image->cols + col + i) % image->cols;
		if (image->image[tmprow][tmpcol].R) numr++;
		if (image->image[tmprow][tmpcol].G) numg++;
		if (image->image[tmprow][tmpcol].B) numb++;
	}
	if (bitr) bitr = (rule >> (9 + numr)) & 1;
	else bitr = (rule >> numr) & 1;
	res->R = 255 * bitr;
	if (bitg) bitg = (rule >> (9 + numg)) & 1;
	else bitg = (rule >> numg) & 1;
	res->G = 255 * bitg;
	if (bitb) bitb = (rule >> (9 + numb)) & 1;
	else bitb = (rule >> numb) & 1;
	res->B = 255 * bitb;
	return res;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	//YOUR CODE HERE
	Image* tmp = malloc(sizeof(struct Image));
	tmp->image = malloc(image->rows * sizeof(struct Color*));
	for (int i = 0; i < image->rows; ++i) {
		tmp->image[i] = malloc(image->cols * sizeof(struct Color));
		for (int j = 0; j < image->cols; ++j) {
			Color *newColor = evaluateOneCell(image, i, j, rule);
			tmp->image[i][j] = *newColor;
			free(newColor);
		}
	}
	tmp->rows = image->rows;
	tmp->cols = image->cols;
	return tmp;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	Image *image, *tmp;
	uint32_t rule;
	char *filename;
	if (argc != 3) {
		printf("usage: %s filename rule\n",argv[0]);
		printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
		printf("rule is a hex number beginning with 0x; Life is 0x1808.\n");
		exit(-1);
	}
	filename = argv[1];
	rule = strtol(argv[2], NULL, 16);
	image = readData(filename);
	tmp = life(image, rule);
	writeData(tmp);
	freeImage(image);
	freeImage(tmp);
}
