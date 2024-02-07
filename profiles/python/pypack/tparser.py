# from reckon_parser import *
from reckon_parser.utils import *
# from reckon_parser.parser import *
# from reckon_parser.mappers import *

stream = 'hi there %_%'
pct = F(lambda: Char('%'))
under = F(lambda: Char('_'))
sp = ((start + 'hi' + space + 'there') * join * first) - space >> (Some(pct|under) * join % 'face-me')
r = ParserRunner(stream)
print(r.run(sp).state.values[0])
print(f'{r.rest()!r}')
r.explain()
