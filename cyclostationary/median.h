#include "mex.h"
#include <memory.h>

//extern void mexFunction(int nlhs, mxArray *plhs[],
//	int nrhs, const mxArray *prhs[]);
template <typename real>
real median_t(real* a, int mid, int left, int right)
{
	if (left >= right || left > mid || right < mid)
	{
		return a[mid];
	}
	real key = a[right];
	int i = left; int j = right;
	while (i < j)
	{
		while (a[i] <= key && i < j)
		{
			i++;
		}
		a[j] = a[i];
		while (a[j] >= key && i < j)
		{
			j--;
		}
		a[i] = a[j];
	}
	a[j] = key;
	if (i - 1 >= mid)
	{
		return median_t(a, mid, left, i - 1 );
	}
	else
	{
		return median_t(a, mid, i , right);
	}	
}

template <typename real>
real median(real *a, size_t n)
{
	if (n % 2 == 1)
	{
		return median_t(a, n/2, 0, n - 1);
	}
	else
	{
		return (median_t(a, n / 2 - 1, 0, n - 1) + median_t(a, n/2, 0, n - 1))/2;
	}	
}

template <typename real>
void midfilt_t(real *x,real *y, size_t n, size_t point)
{
	size_t left = 0, right = 0;
	real *tmp = new real[point * 2 + 1];
	for (unsigned int i = 0; i < n; i++)
	{
		if (i > point)
		{
			left = i - point;
		}
		if (i + point < n)
		{
			right = i + point;
		}
		else
		{
			right = n - 1;
		}
		memcpy(tmp, x + left, (right - left + 1)*sizeof(real));
		y[i] = median(tmp, right - left + 1);
	}
	return;
}


