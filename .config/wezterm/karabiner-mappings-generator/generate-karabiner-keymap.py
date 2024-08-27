# wezterm show-keys --lua | python3 wezterm-keymap-to-json.py | python3 generate-karabiner-keymap.py | cb
import sys
import json

description = "Map (shift) option + a-z and option + 0-9 to (shift) command + a-z and command + 0-9 in Wezterm"

special_characters = {
    "`": "grave_accent_and_tilde",
    "-": "hyphen",
    "=": "equal_sign",
    "[": "open_bracket",
    "]": "close_bracket",
    "\\": "backslash",
    ";": "semicolon",
    "'": "quote",
    ",": "comma",
    ".": "period",
    "/": "slash",
    "_": "hyphen",
    "+": "equal_sign",
    "{": "open_bracket",
    "}": "close_bracket",
    "|": "backslash",
    ":": "semicolon",
    "\"": "quote",
    "<": "comma",
    ">": "period",
    "?": "slash"
}

def create_karabiner_json(key):
    base = {
        "conditions": [
            {
                "bundle_identifiers": [
                    "^com.github.wez.wezterm$"
                ],
                "type": "frontmost_application_if"
            }
        ],
        "type": "basic",
        "from": {
            "key_code": special_characters.get(key, key),
            "modifiers": {
                "mandatory": ["command"]
            }
        },
        "to": [
            {
                "key_code": special_characters.get(key, key),
                "modifiers": ["option"]
            }
        ]
    }
    
    # Add "optional": ["shift"] only for letters
    if key.isalpha():
        base["from"]["modifiers"]["optional"] = ["shift"]
    
    return base

# Read JSON input from stdin
input_json = json.load(sys.stdin)

# Create Karabiner-Elements JSON for each key
karabiner_json = {"description": description, "manipulators": [create_karabiner_json(key) for key in input_json]}

# Print the result as JSON
print(json.dumps(karabiner_json, indent=2))
