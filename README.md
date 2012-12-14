census-name-generator
---------------------

A brain-dead easy-to-use artificial name generator.  Syntax looks like this:

    namegen.pl [options]

    Options:
    -n --names     Number of names to generate
    -d --download  Download census name data
    -r --ratio     Ratio of female vs male names as percentage (default 50)
    -? --help      Display this help and exit


The script uses 2010 Census data to ensure a realistic distribution.  ("John Smith" is more likely than
"Marcellus Wallace", but both are possible.)  Distribution is 50/50 male to female, but can be configured
in the script.

Sample run:

    $ ./namegen.pl -d
    Downloading last name census data... Done.
    Downloading female first name census data... Done.
    Downloading male first name census data... Done.

    $ ./namegen.pl -n 10
    Samuel Bowman
    Sheila Gervais
    Edith Brown
    Jenny Lee
    Harold Mendoza
    Gloria Phipps
    Dawn Andrews
    Freida Goldberg
    Lorraine Hicks
    Elizabeth King

Once the data has been downloaded, it takes about 2-3 seconds to generate a million fake names.
