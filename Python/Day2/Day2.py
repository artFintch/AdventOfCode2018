from collections import Counter

twice = 0
threeTimes = 0
lines = [line for line in iter(input, '')]
for line in lines:
    counter = {count for char, count in Counter(line).most_common(2)}
    if 3 in counter:
        threeTimes += 1
    if 2 in counter:
        twice += 1
print(twice * threeTimes)