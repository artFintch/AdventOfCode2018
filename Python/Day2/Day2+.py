from itertools import combinations

lines = [line for line in iter(input, '')]
for line, line2 in combinations(lines, 2):
	count = 0
	pos = 0
	for j in range(len(line)):
		if line[j] != line2[j]:
			count += 1
			pos = j
	if count == 1:
		print(line[:pos] + line[pos + 1:])
		break