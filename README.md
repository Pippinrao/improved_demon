# improved_demon
improved demon spectrum analysis

> 分析舰船噪声，主要方向为DEMON分析。
>
> 数据来源：[shipsear](http://atlanttic.uvigo.es/underwaternoise/)

## Cyclostationnary

- autofam.m

  计算舰船辐射噪声的循环谱；

- autofam_low.m

  仅计算舰船辐射噪声循环谱低频段（1个df）来获取螺旋桨信息；

- midfilt.cpp & midfilt.h 

  使用C++加速计算中值滤波

- sub_demon.m

  通过分频段计算demon谱（目前最常用的舰船辐射噪声分析方法之一，用作性能对比）

## Entropy

- spectrum_entropy.m

  计算循环谱每个每个频段谱熵来确定该频段包含舰船信息量，由此设计滤波器获得增强的DEMON谱。
