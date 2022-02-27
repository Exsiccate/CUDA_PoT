#include <thrust/device_vector.h>
#include <thrust/transform.h>
#include <thrust/sequence.h>
#include <thrust/copy.h>
#include <thrust/fill.h>
#include <thrust/replace.h>
#include <thrust/functional.h>
#include <iostream>
#include <time.h>

int main(void)
{
    // allocate three device_vectors with 10 elements
    thrust::device_vector<__int32> PoT(300001);
    thrust::device_vector<__int32> Rest(300001);
    thrust::device_vector<__int32> Twos(300001);
    thrust::device_vector<__int32> Divs(300001);
    thrust::device_vector<__int32> Mults(300001);

    // fill last element with 1 
    PoT[300000] = 1;

    // fill Twos with twos
    thrust::fill(Twos.begin(), Twos.end(), 2);
    // fill Divs with twos
    thrust::fill(Divs.begin(), Divs.end(), 1000000000);

    struct tm newtime;
    __time64_t long_time;
    char timebuf[26];

    // Get time as 64-bit integer.
    _time64(&long_time);
    // Convert to local time.
    _localtime64_s(&newtime, &long_time);
    asctime_s(timebuf, 26, &newtime);
    printf("%.19s \n", timebuf);

    for (int i = 0; i < 10000; i++)
    {
        // compute PoT = PoT * 2 [in form of vector named twos]
        thrust::transform(PoT.begin(), PoT.end(), Twos.begin(), PoT.begin(), thrust::multiplies<__int32>());
        thrust::transform(PoT.begin(), PoT.end(), Divs.begin(), Rest.begin(), thrust::divides<__int32>());
        thrust::transform(Rest.begin(), Rest.end(), Divs.begin(), Mults.begin(), thrust::multiplies<__int32>());
        thrust::transform(PoT.begin(), PoT.end(), Mults.begin(), PoT.begin(), thrust::minus<__int32>());
        thrust::transform(PoT.begin(), PoT.end(), Rest.begin() + 1, PoT.begin(), thrust::plus<__int32>());
        // print PoT
        //thrust::copy(PoT.begin(), PoT.end(), std::ostream_iterator<__int32>(std::cout, ","));
        // print Rest
        //std::cout << i;
        // print \n
        //std::cout << "\n";
    }

    // Get time as 64-bit integer.
    _time64(&long_time);
    // Convert to local time.
    _localtime64_s(&newtime, &long_time);
    asctime_s(timebuf, 26, &newtime);
    printf("%.19s \n", timebuf);

    return 0;
}