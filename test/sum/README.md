`perl prep.pl -s spec.json -t sum.txt -o out.txt`

**spec.json** -- data set

```json
[0,1,2,3,4,5,6,7,8,9]
```

**sum.txt** -- report template with preprocessor commands

```perl
Reporting the sum of
all elements of array.

//; my $sum = 0;
//; for my $i (@{$spec}) {
$i
//;   $sum += $i;
//; }
--------
Sum: $sum
--------
```

**out.txt** -- output report file

```
Reporting the sum of
all elements of array.

0
1
2
3
4
5
6
7
8
9
--------
Sum: 45
--------
```
