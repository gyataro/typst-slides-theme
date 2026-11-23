"""Generate the tile SVGs in theme/tiles. Standard library only.

Colors are tokens that Typst replaces: #000001 dark, #000002 mid, #000003 background.
Coordinates: tile center is (0, 0), edges at +/-50, y points down.
"""
import math
from pathlib import Path

DARK, MID, BG = "#000001", "#000002", "#000003"
OUT = Path(__file__).parent / "tiles"


def poly(points, fill):
    d = "M" + "L".join(f"{x:.2f} {y:.2f}" for x, y in points) + "Z"
    return f'<path d="{d}" fill="{fill}"/>'


def dot(x, y, r, fill=DARK):
    return f'<circle cx="{x:.2f}" cy="{y:.2f}" r="{r}" fill="{fill}"/>'


def bezier(p0, p1, p2, p3, n=24):
    out = []
    for i in range(n + 1):
        t = i / n
        a, b, c, d = (1 - t) ** 3, 3 * t * (1 - t) ** 2, 3 * t * t * (1 - t), t ** 3
        out.append(tuple(a * p0[k] + b * p1[k] + c * p2[k] + d * p3[k] for k in (0, 1)))
    return out


def sides(points, width):
    """Offset a centerline to both sides by half of width(t)."""
    left, right, n = [], [], len(points) - 1
    for i, (x, y) in enumerate(points):
        (ax, ay), (bx, by) = points[max(i - 1, 0)], points[min(i + 1, n)]
        dx, dy = bx - ax, by - ay
        length = math.hypot(dx, dy) or 1
        w = width(i / n) / 2
        left.append((x - dy / length * w, y + dx / length * w))
        right.append((x + dy / length * w, y - dx / length * w))
    return left, right


def brush(points, width, fill=DARK):
    left, right = sides(points, width)
    return poly(left + right[::-1], fill)


def curve(x, y, angle, length, turn, power=1.0, n=48):
    """Line whose heading turns by `turn` degrees; power > 1 curls towards its end."""
    pts = [(x, y)]
    for i in range(n):
        h = math.radians(angle + turn * ((i + .5) / n) ** power)
        x, y = x + math.cos(h) * length / n, y + math.sin(h) * length / n
        pts.append((x, y))
    return pts


def leaf(x, y, angle, length, width, bend=0, fat=.45, tones=(DARK, MID), vein=True):
    """Two-toned leaf: widest at `fat` along its length."""
    pts = curve(x, y, angle - bend / 2, length, bend)
    k = math.log(.5) / math.log(fat)
    left, right = sides(pts, lambda t: width * math.sin(math.pi * min(t, 1) ** k) ** .85 if 0 < t < 1 else 0)
    out = poly(left + pts[::-1], tones[0]) + poly(right + pts[::-1], tones[1])
    if vein:
        out += brush(pts[6:-7], lambda t: .9 * (1 - t), BG)
    return out


def scroll(x, y, angle, length, turn, width, tone=DARK, bulb=2.2):
    pts = curve(x, y, angle, length, turn, 1.7)
    return brush(pts, lambda t: .6 + width * math.sin(math.pi * (t * .9 + .08)) ** .8, tone) + dot(*pts[-1], bulb, tone)


def mirror_diag(s):
    return s + f'<g transform="matrix(0 1 1 0 0 0)">{s}</g>'


def four(s):
    return "".join(f'<g transform="rotate({a})">{s}</g>' for a in (0, 90, 180, 270))


def save(name, body, box=(-50, -50, 100, 100)):
    OUT.mkdir(exist_ok=True)
    x, y, w, h = box
    (OUT / f"{name}.svg").write_text(
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{x} {y} {w} {h}" width="{w}" height="{h}">{body}</svg>\n',
        encoding="utf-8")


def bloom():
    frame = (bezier((50, 0), (43, 4), (35, 9), (34, 19)) + bezier((34, 19), (34, 28), (28, 34), (19, 34))[1:]
             + bezier((19, 34), (9, 35), (4, 43), (0, 50))[1:])
    q = brush(frame, lambda t: 2.2 + 3.4 * math.sin(math.pi * t) ** 2, MID)
    inner = [(x * .915, y * .915) for x, y in frame[8:-8]]
    q += brush(inner, lambda t: .2 + 1.0 * math.sin(math.pi * t))
    q += leaf(5, 0, 0, 24, 8.5, 0)
    q += leaf(4, 4, 45, 21, 11, 14, fat=.62, tones=(MID, MID))
    q += brush(curve(5, 4.5, 38, 14, 12), lambda t: 1.7 * (1 - t))
    for a in (22.5, 67.5):
        q += dot(21 * math.cos(math.radians(a)), 21 * math.sin(math.radians(a)), 1.5)
    q += leaf(47.5, 47.5, 225, 20, 7.5, 0)
    q += mirror_diag(leaf(47.5, 45.5, 203, 18, 6, 34, tones=(MID, MID)))
    save("bloom", four(q) + dot(0, 0, 4) + dot(0, 0, 1.5, BG))


def vine():
    half = scroll(20, 21, 12, 34, -330, 2.9, bulb=1.9)
    half += leaf(35, 31, 8, 14, 5, -34, tones=(MID, MID))
    half += leaf(33, 8, -8, 10, 3.6, -20, tones=(MID, MID), vein=False)
    q = leaf(5, 5, 45, 36, 13, 0, fat=.55, tones=(MID, MID), vein=False)
    q += brush(curve(9, 9, 45, 22, 0), lambda t: .3 + 2.2 * math.sin(math.pi * t))
    q += mirror_diag(half)
    q += leaf(31, 31, 45, 23, 7.5)
    q += leaf(5, 0, 0, 17, 5)
    q += leaf(50, 0, 180, 12, 5, tones=(MID, MID), vein=False)
    save("vine", four(q) + dot(0, 0, 3))


def wave():
    def scale(cx, cy):
        s = f'<circle cx="{cx}" cy="{cy}" r="50" fill="{BG}"/>'
        for r, w, tone in ((48, 2.6, DARK), (40, 1.5, MID), (33, 2.2, DARK)):
            arc = [(cx + r * math.cos(a), cy + r * math.sin(a))
                   for a in (math.pi + math.pi * i / 48 for i in range(49))]
            s += brush(arc, lambda t: w * (.65 + .35 * math.sin(math.pi * t)), tone)
        for a, length, bend in ((-90, 21, 0), (-125, 20, 16), (-55, 20, -16)):
            rad = math.radians(a)
            s += leaf(cx + 8 * math.cos(rad), cy + 8 * math.sin(rad), a, length, 6.5, bend)
        return s

    rows = []
    for i in range(-1, 8):
        cy = -50 + i * 25
        rows += [scale(cx, cy) for cx in ((-50, 50) if i % 2 == 0 else (-100, 0, 100))]
    save("wave", "".join(rows))


def border():
    # Straight edging: a solid bar, then one scallop per repeat holding a small bud.
    arc = [(10 + 10 * math.cos(a), 4 + 7.5 * math.sin(a)) for a in (math.pi * i / 32 for i in range(33))]
    s = f'<rect width="20" height="4" fill="{DARK}"/>'
    s += brush(arc, lambda t: 1.1, MID)
    s += leaf(10, 4, 90, 4.6, 2.6, tones=(MID, MID), vein=False)
    save("border", s, (0, 0, 20, 12))


for make in (bloom, vine, wave, border):
    make()
