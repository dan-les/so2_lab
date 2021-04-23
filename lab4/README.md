### Lab 4

* Dzialajcy skrypt: 
[ `movies.sh`](./movies.sh)
```bash
>> ./movies.sh [params]
```
Parametry:
```bash
>> ./movies.sh -h

-d DIRECTORY
        Directory with files describing movies
-a ACTOR
        Search movies that this ACTOR played in
-t QUERY
        Search movies with given QUERY in title
-y YEAR
        Search movies made after the YEAR
-R QUERY
        Search movies that contains QUERY in plot
-i 
        Ignore letter size in searching by plot (param: -R)
-f FILENAME
        Saves results to file (default: results.txt)
-x
        Prints results in XML format
-h
        Prints this help message
```