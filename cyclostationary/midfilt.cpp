#include "median.h"
#define DATA  prhs[0]
#define POINT prhs[1]
#define MIDDATA plhs[0]

void mexFunction(int nlhs, mxArray *plhs[], 
	int nrhs, const mxArray *prhs[])
{
	if (nrhs != 2)
			mexErrMsgTxt("Wrong number of input arguments.\n");
		// ���������������Ƿ���ȷ�����򱨴�

		if (nlhs > 1)
			mexErrMsgTxt("Too many output argumnents.\n");
		// ���������������Ƿ���ȷ�����򱨴�



		size_t M = (mxGetM(DATA));
		size_t N = (mxGetN(DATA));
		// �õ��������A������������

		MIDDATA = mxCreateDoubleMatrix(M, N, mxREAL);
		// Ϊ�������B����洢�ռ�

		double *data = mxGetPr(DATA);
		double *middata = mxGetPr(MIDDATA);
		size_t point = (size_t)*(mxGetPr(POINT));
		midfilt_t(data, middata, M*N, point);
}