""" 
The python package for the EDOL project.

- database access
- common data handling

"""

from edol.db   import *
from edol.errorHandler import *
CYAN         = '\033[34m'
END          = '\033[0m'

__all__ = [
        'errorHandler',
        'db',
        ]

print(f'Loading {__name__} modules')
print(f"""{CYAN}
    ┌─┐┌┬─┐┌─┐┬
    ├┤  │ ││ ││
    └─┘─┴─┘└─┘┴─┘
    {END}""")
