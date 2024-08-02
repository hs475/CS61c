/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>

#include "imageloader.h"


//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	//YOUR CODE HERE
	char buf[20];
	int t;
	Image* tmp = malloc(sizeof(struct Image));
	FILE *fp = fopen(filename, "r+");
	fscanf(fp, "%s%d%d%d", buf, &tmp->cols, &tmp->rows, &t);
	tmp->image = malloc(tmp->rows * sizeof(struct Color*));
	for (int i = 0; i < tmp->rows; ++i) {
		tmp->image[i] = malloc(tmp->cols * sizeof(struct Color));
		for (int j = 0; j < tmp->cols; ++j) {
			fscanf(fp, "%hhu%hhu%hhu", &tmp->image[i][j].R, &tmp->image[i][j].G, &tmp->image[i][j].B);
		}
	}
	fclose(fp);
	return tmp;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
	printf("P3\n");
	printf("%d %d\n", image->cols, image->rows);
	printf("255\n");
	for (int i = 0; i < image->rows; ++i) {
		for (int j = 0; j < image->cols; ++j) {
			printf("%3d %3d %3d", image->image[i][j].R, image->image[i][j].G, image->image[i][j].B);
			if (j < image->cols - 1) printf("   ");
			else printf("\n");
		}
	}
	return;
}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
	for (int i = 0; i < image->rows; ++i) free(image->image[i]);
	free(image->image);
	free(image);
}
