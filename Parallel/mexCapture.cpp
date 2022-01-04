#include "opencvmex.hpp"
// #include "mexopencv/include/mexopencv.hpp"
// #include "mexopencv/include/MxArray.hpp"
// #include "matcv.h"
#include "mex.h"
#include <thread>
#include <string>
#include <future>
#include <iostream>
#include "matrix.h"
#include "opencv2/opencv.hpp"
#include "opencv2/objdetect/objdetect.hpp"
#include "opencv2/imgproc/imgproc.hpp"

using namespace std;   
using namespace cv;

void call_thread(string, Mat *);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
     if (nrhs != 2) {
    mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin", 
            "MEXCPP requires two input arguments.");
  } 

  string URL1 = mxArrayToString(prhs[0]);
  string URL2 =  mxArrayToString(prhs[1]);
    
    nlhs = 2;
    
    Mat im1;
    Mat im2;
    
    Mat *ptr_im1;
    Mat *ptr_im2;
    
    ptr_im1 = &im1;
    ptr_im2 = &im2;

    thread t1(call_thread, URL1, ptr_im1);
    thread t2(call_thread, URL2, ptr_im2);

    t1.join();
    t2.join();        
                    
   mxArray *ptr1 = ocvMxArrayFromMat_uint8(im1);
   mxArray *ptr2 = ocvMxArrayFromMat_uint8(im2);
    
    plhs[0] = ptr1;
  
     plhs[1] = ptr2;
  
    return;
}


void call_thread(string URL, Mat *im){
    
    VideoCapture cap(URL);

    cap.read(*im);

 }  