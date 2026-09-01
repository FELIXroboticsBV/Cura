# FELIXFoodSwitch_XOffset_v3.py
# FELIX Food Switch – X-offset (v3)
# Layer-aware X-offset post-process script for Cura 5.x

from ..Script import Script
import re

class FELIXFoodSwitch_XOffset_v3(Script):
    def __init__(self):
        super().__init__()
        # per-line regexen
        self._re_comment = re.compile(r'^\s*;')
        self._re_g92     = re.compile(r'(^|\s)G92(\s|$)', re.IGNORECASE)
        self._re_g90     = re.compile(r'(^|\s)G90(\s|$)', re.IGNORECASE)
        self._re_g91     = re.compile(r'(^|\s)G91(\s|$)', re.IGNORECASE)
        self._re_xtoken  = re.compile(r'([Xx])(-?\d+(?:\.\d+)?)')

    def getSettingDataString(self):
        return """{
            "name": "FELIX Food Switch - X-offset",
            "key": "FelixFoodSwitch_XOffset_v3",
            "metadata": {},
            "version": 2,
            "settings": {
                "x_offset": {
                    "label": "Offset X (mm)",
                    "description": "Adds to each X value (e.g. -60).",
                    "type": "float",
                    "default_value": -60.0
                },
                "only_absolute": {
                    "label": "Absolute mode only (G90)",
                    "description": "Adjust only X in G90 segments (recommended).",
                    "type": "bool",
                    "default_value": true
                }
            }
        }"""

    def execute(self, data):
        # settings (with safe defaults)
        try:
            x_offset = float(self.getSettingValueByKey("x_offset") or -60.0)
        except Exception:
            x_offset = -60.0
        try:
            only_abs = self.getSettingValueByKey("only_absolute")
            if isinstance(only_abs, str):
                only_abs = only_abs.lower() in ("true","1","yes","on")
            elif not isinstance(only_abs, bool):
                only_abs = True
        except Exception:
            only_abs = True

        total_changed = 0

        # for each CHUNK (start/layers/end); each item is multi-line text
        for idx, chunk in enumerate(data):
            absolute = True  # G90 until G91 is seen
            lines = chunk.splitlines(True)
            out_lines = []

            for line in lines:
                if self._re_g90.search(line): absolute = True
                if self._re_g91.search(line): absolute = False

                if self._re_comment.match(line) or self._re_g92.search(line):
                    out_lines.append(line); continue
                if only_abs and not absolute:
                    out_lines.append(line); continue

                def _sub(m):
                    nonlocal total_changed
                    X = m.group(1)
                    try:
                        v0 = float(m.group(2))
                    except ValueError:
                        return m.group(0)
                    v1 = v0 + x_offset
                    total_changed += 1
                    return f"{X}{v1:.3f}"

                out_lines.append(self._re_xtoken.sub(_sub, line))

            data[idx] = "".join(out_lines)

        if data:
            header = (
                f"; FELIX Food Switch - X-offset (v3) applied: X += {x_offset:.3f}"
                + (" | only G90" if only_abs else "")
                + f" | total X tokens changed: {total_changed}\n"
            )
            data[0] = header + data[0]

        return data
