#include <iostream>
#include <assert.h>
#include <cstdlib>
#include <thread>
using namespace std;


// Point computation (serial)
// Implemented in smdb.cpp
int ComputeMandelbrotPoint(int x, int y);

// Implement the thread function which will be called by the spawned threads
//
// This function is called by the main thread
// It will spawn and join threads, calling a thread function that
// you'll implement
//
void Compute_Given_Chunk(int** points,int dimX,int current_Y,int chunkSize){
    for(int i=0; i<dimX; i++){
        for(int j = 0; j < chunkSize;j++){
            if(current_Y+j<dimX){
            points[current_Y+j][i] = ComputeMandelbrotPoint(i, current_Y+j);
            }
        }
    }
}

// If the return code is false, disable plotting and reporting which won't
// work if the multithraded code hasn't been implemented
bool Mandelbrot_multiThreaded(int** pts, int dimX, int dimY, int numThreads, int chunkSize)
{
    //cerr << "Working on it" << endl;
    // Change the return code to true when you've imlemented this code
    // A return code of false will disable plotting, as plotting
    // won't function correctly with an empty image.
    //////////// add your code here //////////////////////////////////
    int current_Y = 0;
    thread thrds[numThreads];
    while(current_Y<dimY){
        if(chunkSize > 0){
            for(int i = 0; i < numThreads;i++){
                if(chunkSize+current_Y<dimY){
                    thrds[i] = thread(Compute_Given_Chunk,pts,dimX,current_Y,chunkSize);
                    current_Y = current_Y + chunkSize;
                }
                else{
                    thrds[i] = thread(Compute_Given_Chunk,pts,dimX,current_Y,dimY - current_Y);
                    current_Y = current_Y + dimY - current_Y;
                }
            }
            for(int i = 0; i < numThreads;i++){
                thrds[i].join();
            }
        }
        else{
            int chunkSizeART = dimY/numThreads;
            for(int i = 0; i < numThreads;i++){
                if(chunkSize+current_Y<dimY){
                    thrds[i] = thread(Compute_Given_Chunk,pts,dimX,current_Y,chunkSizeART);
                    current_Y = current_Y + chunkSizeART;
                }
                else{
                    thrds[i] = thread(Compute_Given_Chunk,pts,dimX,current_Y,dimY - current_Y);
                    current_Y = current_Y + dimY - current_Y;
                }
            }
            for(int i = 0; i < numThreads;i++){
                thrds[i].join();
            }
        }
	}
    return true;
}
