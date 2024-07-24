import re

word2num = {
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9',
    'zero': '0'
}

def convert2nums(line, map):
    pattern = '(?=(' + '|'.join(map.keys()) + '|\\d))'
    return re.sub(pattern, lambda x: map.get(x.group(1), x.group(1)), line)

def process_file(filename, map):
    total = 0
    with open(filename, 'r') as f:
        for line in f:
            converted_line = convert2nums(line.strip(), map)
            numbers = re.findall(r'\d', converted_line)
            if numbers:
                num = int(numbers[0] + numbers[-1])
                total += num
    return total

total = process_file("../day1_input.txt", word2num)
print(total)
