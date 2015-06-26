import os
import sys
import mock
if os.name == "nt":
	print("mock urwid", file=sys.stderr)
    m = mock.Mock()
    m.__version__ = "1.1.1"
    m.Widget = mock.Mock
    m.WidgetWrap = mock.Mock
    sys.modules['urwid'] = m
    sys.modules['urwid.util'] = mock.Mock()
