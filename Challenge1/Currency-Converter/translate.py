import os
import re
from deep_translator import GoogleTranslator

# Cấu hình
BASE_DIR = os.path.dirname(__file__)
INPUT_FILE = os.path.join(BASE_DIR, 'vi.lproj/Localizable.strings')
OUTPUT_FILE = os.path.join(BASE_DIR, 'en.lproj/Localizable.strings')

# Khởi tạo dịch giả
translator = GoogleTranslator(source='vi', target='en')

# Biểu thức chính quy để khớp các cặp key-value, chỉ khớp khi cả key và value đều nằm trong dấu ngoặc kép
pattern = re.compile(r'^"(.+?)"\s*=\s*"(?!\1)(.+?)";$')

def translate_text(text):
    try:
        translated_text = translator.translate(text)
        return translated_text
    except Exception as e:
        print(f"Lỗi khi dịch '{text}': {e}")
        return text  # Trả về văn bản gốc nếu dịch thất bại

def main():
    # Đọc các key đã có trong file output
    existing_keys = set()
    if os.path.exists(OUTPUT_FILE):
        with open(OUTPUT_FILE, 'r', encoding='utf-8') as f:
            for line in f:
                match = pattern.match(line.strip())
                if match:
                    key, _ = match.groups()
                    existing_keys.add(key)

    translated_lines = []
    with open(INPUT_FILE, 'r', encoding='utf-8') as f:
        for line in f:
            match = pattern.match(line.strip())
            if match:
                key, value = match.groups()
                if key not in existing_keys:
                    translated_value = translate_text(value)
                    translated_line = f'"{key}" = "{translated_value}";\n'
                    print(f'Dịch: "{value}" -> "{translated_value}"')
                    translated_lines.append(translated_line)
            else:
                translated_lines.append(line)

    with open(OUTPUT_FILE, 'a', encoding='utf-8') as f:
        f.writelines(translated_lines)
    print(f'Dịch hoàn tất. Kết quả được ghi vào {OUTPUT_FILE}')

if __name__ == '__main__':
    main()