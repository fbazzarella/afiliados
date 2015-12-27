#!/usr/bin/python

import sys
from flanker.addresslib import address

email = str(sys.argv[1])
valid = address.validate_address(email)

if valid == None:
  sys.exit(1)
else:
  sys.exit(0)
