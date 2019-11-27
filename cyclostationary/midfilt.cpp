#include "median.h"
#define DATA  prhs[0]
#define POINT prhs[1]
#define MIDDATA plhs[0]

void mexFunction(int nlhs, mxArray *plhs[], 
	int nrhs, const mxArray *prhs[])
{
	if (nrhs != 2)
			mexErrMsgTxt("Wrong number of input arguments.\n");
		// 检查输入变量数量是否正确，否则报错

		if (nlhs > 1)
			mexErrMsgTxt("Too many output argumnents.\n");
		// 检查输出变量数量是否正确，否则报错



		size_t M = (mxGetM(DATA));
		size_t N = (mxGetN(DATA));
		// 得到输入矩阵A的行数和列数

		MIDDATA = mxCreateDoubleMatrix(M, N, mxREAL);
		// 为输出矩阵B分配存储空间

		double *data = mxGetPr(DATA);
		double *middata = mxGetPr(MIDDATA);
		size_t point = (size_t)*(mxGetPr(POINT));
		midfilt_t(data, middata, M*N, point);
}