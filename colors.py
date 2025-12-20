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
    s = min(max(s, 0), 100)
    l = min(max(l, 0), 100)
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

def print_colored_squares(colors):
    for color in colors[:8]:
        r, g, b = hsl_to_rgb([(color[0] + 360) % 360, color[1], color[2]])
        print(f"\033[48;2;{r};{g};{b}m  \033[0m", end="")
    print()
    for color in colors[8:]:
        r, g, b = hsl_to_rgb([(color[0] + 360) % 360, color[1], color[2]])
        print(f"\033[48;2;{r};{g};{b}m  \033[0m", end="")
    print()

def output(bright_colors, dimmed_colors):
    # 1. Convert HSL to RGB
    bright_rgb = [hsl_to_rgb([(c[0] + 360) % 360, c[1], c[2]]) for c in bright_colors]
    dimmed_rgb = [hsl_to_rgb([(c[0] + 360) % 360, c[1], c[2]]) for c in dimmed_colors]

    # 2. Convert RGB to Hex
    bright_hex = [f"{r:02x}{g:02x}{b:02x}" for r, g, b in bright_rgb]
    dimmed_hex = [f"{r:02x}{g:02x}{b:02x}" for r, g, b in dimmed_rgb]

    # 3. Generate JSON object
    colors = bright_rgb + dimmed_rgb

    print("{")
    for i, color in enumerate(colors):
        print(f'  "color{i}"="{color[0]},{color[1]},{color[2]}";')
    print("}")

def main():
    hue_step = 10

    if len(sys.argv) < 2 or "-h" in sys.argv or "--help" in sys.argv:
        print(f"Usage: {sys.argv[0]} <#hex-code> <#optional-hex-end>")
        print(f"Flags:")
        print(f"  -h, --help                         Show this help message and exit")
        print(f"  --hue-step <int>                   Set the hue step for single color palette generation (default: 10)")
        print(f"  --range <start-color> <end-color>  Generate palette between two colors")
        print(f"  --debug                            Enable debug output")
        sys.exit()

    if "--hue-step" in sys.argv:
        idx = sys.argv.index("--hue-step")
        if idx + 1 < len(sys.argv):
            hue_step = int(sys.argv[idx + 1])
            del sys.argv[idx:idx + 2]
        else:
            print("Error: --hue-step requires an integer argument.")
            sys.exit(1)
    
    if "--range" in sys.argv:
        idx = sys.argv.index("--range")
        if idx + 2 < len(sys.argv):
            # Validate format
            if not (sys.argv[idx + 1].startswith("#") and len(sys.argv[idx + 1]) == 7 and
                    sys.argv[idx + 2].startswith("#") and len(sys.argv[idx + 2]) == 7):
                print("Error: Colors must be in #RRGGBB format.")
                sys.exit(1)

            start_color = sys.argv[idx + 1]
            end_color = sys.argv[idx + 2]
            sys.argv.append(start_color)
            sys.argv.append(end_color)
        else:
            print("Error: --range requires two color arguments.")
            sys.exit(1)

    if "--range" in sys.argv:
        # Two colors, generate palette between them
        start_rgb = [int(sys.argv[-2].strip("#")[i*2] + sys.argv[-2].strip("#")[i*2 + 1], 16)/255 for i in range(0, 3)]
        end_rgb = [int(sys.argv[-1].strip("#")[i*2] + sys.argv[-1].strip("#")[i*2 + 1], 16)/255 for i in range(0, 3)]

        start_hsl = rgb_to_hsl(start_rgb)
        end_hsl = rgb_to_hsl(end_rgb)

        bright_colors = []

        for i in range(0, 8):
            ratio = i / 7
            if start_hsl[0] - end_hsl[0] > 180:
                end_hsl[0] += 360
            elif end_hsl[0] - start_hsl[0] > 180:
                start_hsl[0] += 360
            h = start_hsl[0] + (end_hsl[0] - start_hsl[0]) * ratio
            s = start_hsl[1] + (end_hsl[1] - start_hsl[1]) * ratio
            l = start_hsl[2] + (end_hsl[2] - start_hsl[2]) * ratio
            bright_colors.append([h, s, l])

        dimmed_colors = map(lambda c: [c[0], c[1] * 0.8, c[2] * 1.5], bright_colors)

        if "--debug" in sys.argv:
            print_colored_squares(bright_colors + list(dimmed_colors))
        else:
            output(bright_colors, dimmed_colors)
    else:
        # Single color, generate palette with HUE step
        
        rgb = [int(sys.argv[1].strip("#")[i*2] + sys.argv[1].strip("#")[i*2 + 1], 16)/255 for i in range(0, 3)]
        hsl = rgb_to_hsl(rgb)

        bright_colors = [[hsl[0] + hue_step * (i - 4), hsl[1], hsl[2]] for i in range(0, 8)]

        dimmed_colors = map(lambda c: [c[0], c[1], c[2] * 1.5], bright_colors)

        if "--debug" in sys.argv:
            print_colored_squares(bright_colors + list(dimmed_colors))
        else:
            output(bright_colors, dimmed_colors)
    
    sys.exit(0)



if __name__ == "__main__":
    main()
