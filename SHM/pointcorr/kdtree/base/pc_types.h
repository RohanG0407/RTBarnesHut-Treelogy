/*************************************************************************************************
 * Copyright (C) 2017, Nikhil Hegde, Jianqiao Liu, Kirshanthan Sundararajah, Milind Kulkarni, and 
 * Purdue University. All Rights Reserved. See Copyright.txt
*************************************************************************************************/
#ifndef PC_TYPES_H_
#define PC_TYPES_H_

const int MAX_POINTS_IN_CELL = 1;

class Point {
public:
	Point();
	~Point();

	float *coord;
	int corr;
#ifdef TRACK_TRAVERSALS
	int num_nodes_traversed;
	int id;
private:
	static int next_id;
#endif
};

class Node {
public:
	Node();
	~Node();

	int axis;
	float splitval;
	float *min;
	float *max;
	Point* points[MAX_POINTS_IN_CELL];
	Node *left;
	Node *right;
#ifdef METRICS
	int numPointsVisited;
#endif
#ifdef TRACK_TRAVERSALS
	int id;
private:
	static int next_id;
#endif
};

#endif /* PC_TYPES_H_ */
