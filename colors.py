import sys

def rgb_to_hsl(rgb: list):
    max_value = max(rgb)
    min_value = min(rgb)

    l = (max_value + min_value) / 2

    if max_value == min_value:
        h = s = 0  # achromatic
    else:
        delta = max_value - min_value
        s = delta / (2 - max_value - min_value) if l > 0.5 else delta / (max_value + min_value)

        if max_value == rgb[0]:
            h = (rgb[1] - rgb[2]) / delta + (6 if rgb[1] < rgb[2] else 0)
        elif max_value == rgb[1]:
            h = (rgb[2] - rgb[0]) / delta + 2
        else:
            h = (rgb[0] - rgb[1]) / delta + 4
        h /= 6

    return [h * 360, s * 100, l * 100]

def hsl_to_rgb(hsl: list):
    h, s, l = hsl
    s /= 100
    l /= 100

    if s == 0:
        r = g = b = l  # achromatic
    else:
        def hue_to_rgb(p, q, t):
            if t < 0:
                t += 1
            if t > 1:
                t -= 1
            if t < 1/6:
                return p + (q - p) * 6 * t
            if t < 1/2:
                return q
            if t < 2/3:
                return p + (q - p) * (2/3 - t) * 6
            return p

        q = l * (1 + s) if l < 0.5 else l + s - l * s
        p = 2 * l - q

        r = hue_to_rgb(p, q, h / 360 + 1/3)
        g = hue_to_rgb(p, q, h / 360)
        b = hue_to_rgb(p, q, h / 360 - 1/3)

    return [int(r * 255), int(g * 255), int(b * 255)]

def output(bright_colors, dimmed_colors):
    # 1. Convert HSL to RGB
    bright_rgb = [hsl_to_rgb([(c[0] + 360) % 360, c[1], c[2]]) for c in bright_colors]
    dimmed_rgb = [hsl_to_rgb([(c[0] + 360) % 360, c[1], c[2]]) for c in dimmed_colors]

    # 2. Convert RGB to Hex
    bright_hex = [f"{r:02x}{g:02x}{b:02x}" for r, g, b in bright_rgb]
    dimmed_hex = [f"{r:02x}{g:02x}{b:02x}" for r, g, b in dimmed_rgb]

    # 3. Generate JSON object
    colors = bright_hex + dimmed_hex

    print("{")
    for i, color in enumerate(colors):
        print(f'  "color{i}": "{color}"')
    print("}")

def main():
    hue_step = 15
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <#hex-code>")
        sys.exit()

    rgb = [int(sys.argv[1].strip("#")[i*2] + sys.argv[1].strip("#")[i*2 + 1], 16)/255 for i in range(0, 3)]
    hsl = rgb_to_hsl(rgb)

    bright_colors = [[hsl[0] + hue_step * (i - 4), hsl[1], hsl[2]] for i in range(0, 8)]

    dimmed_colors = map(lambda c: [c[0], c[1], c[2] * 0.5], bright_colors)

    output(bright_colors, dimmed_colors)

if __name__ == "__main__":
    main()
