#!/usr/bin/python

import sys, re, math, urllib.request

def loadBadge(url, place):
	opener = urllib.request.build_opener()
	opener.addheaders=[('User-Agent',  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.1 Safari/605.1.15')]
	urllib.request.install_opener(opener)	
	urllib.request.urlretrieve(url, place)	

def generateSingleBadgeURL(left, color):
	return 'https://img.shields.io/badge/{}-{}.svg'.format(left, color)

def parseLine(line):
	day = re.search('Day\d+', line).group(0).lower()
	name = re.search('\stest[^]]*', line).group(0).strip().lower()[4:]
	average = re.search('average:\s[^,]+', line).group(0)
	speed = math.ceil(float(re.findall("\d+\.\d+", average)[0]) * 1000.0)
	speed = (1, speed)[speed > 0]
	return day, name, str(speed)

def makeColor(speed):
	if speed < 100:
		return 'brightgreen'
	elif speed < 300:
		return 'yellow'
	elif speed < 1000:
		return 'orange'
	else:
		return 'red'

def generateMetricsBadges(input):
	for line in input:
		striped = line.strip()
		if 'measured' in striped: 
			day, name, speed = parseLine(striped)
			color = makeColor(int(speed))
			url = generateSingleBadgeURL(speed + '_ms', color)
			place = 'Metrics/' + day + '_' + name + '.svg'
			loadBadge(url, place)
			print(day, name, speed, 'ms')
	
generateMetricsBadges(sys.stdin)
