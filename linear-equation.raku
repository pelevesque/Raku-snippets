my $program = '  -3x   -4 + 5+3x-71x   +4x = x -2+43x-12x +5 ';

    # Remove all spaces.
$program ~~ s:g/\s//;

grammar Linear {
    token TOP     { <equation>           }
    rule equation { <expr> '=' <expr>    }
    rule expr     { <term>+              }
    rule term     { <x> | <n>            }
    rule x        { <sign>? <digits>?'x' }
    rule n        { <sign>? <digits>     }
    token digits  { \d+                  }
    token sign    { '+' | '-'            }
}

class Calculations {
    method TOP  ($/) { make $<equation>.made }
    method equation ($/) {
        make $<expr>[0].made ~ ' = ' ~ $<expr>[1].made
    }
    method expr ($/) { make do {
        my $x = 0;
        my $n = 0;
        for $<term> {
                # TODO: Better way to differentiate between x and n?
            given .Str.trim {
                if $_.ends-with('x') {
                    $x += +$_.chop;
                }
                else {
                    $n += +$_;
                }
            }
        }
           # TODO: Return as object:
           # {
           #     x => $x,
           #     n => $n,
           # {
        $x ~ 'x + ' ~ $n;
    } }
}

say Linear.parse($program, actions => Calculations).made;
=finish

Output: -67x + 1 = 31x + 3

I still need to make these calculations in the equation method:

-67x + 1     = 31x + 3
-67x + 1 - 1 = 31x + 3 - 1
-67x         = 31x + 2
-67x + 67x   = 31x + 2 + 67x
-67x + 67x   = 31x + 2 + 67x
0            = 98x + 2
0 - 2        = 98x + 2 - 2
-2           = 98x
-2 / 98      = 98x / 98
-1/49        = x
