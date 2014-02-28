`perl prep.pl -s test/sum/spec.json -t test/sum/sum.txt -o out.txt`

**spec.json** -- data set

```json
[0,1,2,3,4,5,6,7,8,9]
```

**sum.txt** -- Report template

```perl
//; my $sum = 0;
//; for my $i (@{$spec}) {
$i
//;   $sum += $i;
//; }
--------
$sum
```

**out.txt** -- output file

```
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
45
```
