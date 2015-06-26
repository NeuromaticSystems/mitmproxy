from __future__ import print_function

import os
import sys
import mock
print("mock urwid: " + os.name, file=sys.stderr)
if os.name == "nt":
    m = mock.Mock()
    m.__version__ = "1.1.1"
    m.Widget = mock.Mock
    m.WidgetWrap = mock.Mock
    sys.modules['urwid'] = m
    sys.modules['urwid.util'] = mock.Mock()
