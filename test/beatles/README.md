`perl prep.pl -s beatles.json -t band.txt -o out.txt`

**beatles.json** -- data set

```json
{
  "band" : {
    "name" : "The Beatles",
    "people" : [
      {"first":"Ringo",  "second":"Starr",     "year":1940},
      {"first":"John",   "second":"Lennon",    "year":1940},
      {"first":"Paul",   "second":"McCartney", "year":1942},
      {"first":"George", "second":"Harrison",  "year":1943}
    ]
  }
}
```

**band.txt** -- report template with preprocessor commands

```perl
Rock band: $spec->{band}->{name}

People:
//; for my $e (@{$spec->{band}->{people}}) {
$e->{year}	$e->{first}	$e->{second}
//; }
```

**out.txt** -- output report file

```
Rock band: The Beatles

People:
1940	Ringo	Starr
1940	John	Lennon
1942	Paul	McCartney
1943	George	Harrison
```
