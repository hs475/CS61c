/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				Changwei Jing
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	//YOUR CODE HERE
	Color *res = malloc(sizeof(Color));
	int t = image->image[row][col].B & 1;
	res->R = 255 * t;
	res->G = 255 * t;
	res->B = 255 * t;
	return res;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	//YOUR CODE HERE
	Image* tmp = malloc(sizeof(struct Image));
	tmp->rows = image->rows;
	tmp->cols = image->cols;
	tmp->image = malloc(image->rows * sizeof(struct Color*));
	for (int i = 0; i < image->rows; ++i) {
		tmp->image[i] = malloc(image->cols * sizeof(struct Color));
		for (int j = 0; j < image->cols; ++j) {
			int t = image->image[i][j].B & 1;
			tmp->image[i][j].R = 255 * t;
			tmp->image[i][j].G = 255 * t;
			tmp->image[i][j].B = 255 * t;
		}
	}
	return tmp;
}

void processCLI(int argc, char **argv, char **filename) 
{
	if (argc != 2) {
		printf("usage: %s filename\n",argv[0]);
		printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
		exit(-1);
	}
	*filename = argv[1];
}
/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.


argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	Image *image, *tmp;
	char *filename;
	processCLI(argc,argv,&filename);
	image = readData(filename);
	tmp = steganography(image);
	writeData(tmp);
	freeImage(image);
	freeImage(tmp);
}